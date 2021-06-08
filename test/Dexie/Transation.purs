module Test.Dexie.Transaction where


import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Transaction as Transaction
import Dexie.Version as Version
import Effect.Aff (try)
import Effect.Class (liftEffect)
import Effect.Exception (throwException, error)
import Foreign.Object as Object
import Test.Helpers (assertEqual, unsafeGet, withCleanDB)
import Test.Unit (TestSuite, suite, test)

transactionTests :: TestSuite
transactionTests = suite "transaction" do
  test "can rollback transaction" $ withCleanDB "db" $ \db -> toAff $ do
    DB.version 1 db
      >>= Version.stores (Object.singleton "foo" "id")
      # void

    void $ try $ DB.transaction db "rw" ["foo"] \trnx -> do
      table <- Transaction.table "foo" trnx
      Table.add_ { id: 1, name: "John" } Nothing table
      liftEffect $ throwException (error "somethings wrong") # void

    table <- DB.table "foo" db
    unsafeGet 1 table
      >>= assertEqual (Nothing :: Maybe { id :: Int, name :: String })
