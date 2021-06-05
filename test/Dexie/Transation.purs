module Test.Dexie.Transaction where


import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Transaction as Transaction
import Dexie.Version as Version
import Effect.Aff (attempt)
import Effect.Class (liftEffect)
import Effect.Exception (throwException, error)
import Foreign.Object as Object
import Test.Helpers (withCleanDB, unsafeGet)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

transactionTests :: TestSuite
transactionTests = suite "table" do
  test "can rollback transaction" $ withCleanDB "db" $ \db -> do
    DB.version 1 db
      >>= Version.stores (Object.singleton "foo" "id")
      # void

    void $ attempt $ DB.transaction db "rw" ["foo"] \trnx -> do
      table <- Transaction.table "foo" trnx
      Transaction.add_ { id: 1, name: "John" } Nothing table
      throwException (error "somethings wrong") # void
      pure Nothing

    table <- DB.table "foo" db
    unsafeGet 1 table
      >>= Assert.equal (Nothing :: Maybe { id :: Int, name :: String })
