module Test.Dexie.Transaction where

import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Promise as Promise
import Dexie.Table as Table
import Dexie.Transaction as Transaction
import Dexie.Version as Version
import Effect.Aff (try)
import Effect.Class (liftEffect)
import Effect.Exception (throwException, error)
import Foreign.Object (fromHomogeneous)
import Test.Helpers (assert, assertEqual, unsafeDelay, withCleanDB)
import Test.Unit (TestSuite, suite, test)

transactionTests :: TestSuite
transactionTests = suite "transaction" do
  let
    nothingInt :: Maybe Int
    nothingInt = Nothing

  test "can rollback transaction" $ withCleanDB "db" $ \db -> Promise.toAff $ do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "id" })

    void $ try $ DB.transaction db "rw" [ "foo" ] \trnx -> do
      table <- Transaction.table "foo" trnx
      Table.add_ { id: 1, name: "John" } nothingInt table
      liftEffect $ throwException (error "somethings wrong") # void

    assertEqual 0 =<< Table.count =<< DB.table "foo" db

  test "can make concurrent writes if promises not awaited" $ withCleanDB "db" $ \db -> Promise.toAff $ do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "++", bar: Just "++" })

    foo <- DB.table "foo" db
    bar <- DB.table "bar" db

    -- Start writing to foo but don't wait
    p <- Promise.launch $ do
      Table.add_ "One" nothingInt foo
      Table.add_ "Two" nothingInt foo
      unsafeDelay 1.0
      Table.add_ "Three" nothingInt foo
      Table.add_ "Four" nothingInt foo

    -- Write to bar at the same time
    Table.add_ "One" nothingInt bar
    assertEqual 1 =<< Table.count bar

    -- Check that writing to foo is in progress
    c <- Table.count foo
    assert "count should be between 0 and 4" $ c > 0 && c < 4

    -- Check that foo has 4 rows at the end
    Promise.join p # void
    assertEqual 4 =<< Table.count foo

  test "cannot make concurrent read if in a transaction" $ withCleanDB "db" $ \db -> Promise.toAff $ do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "++" })

    -- Start writing to foo in transaction but don't wait
    void $ Promise.launch $ DB.transaction db "rw" [ "foo" ] \trnx -> do
      foo <- Transaction.table "foo" trnx
      Table.add_ "One" nothingInt foo
      Table.add_ "Two" nothingInt foo
      Table.add_ "Three" nothingInt foo
      Table.add_ "Four" nothingInt foo

    -- Check that you can't read from foo whilst in progress
    assertEqual 0 =<< Table.count =<< DB.table "foo" db

    -- Check that you can't read from foo until the whole transaction has committed
    unsafeDelay 1.0
    assertEqual 4 =<< Table.count =<< DB.table "foo" db
