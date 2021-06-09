module Test.Dexie.Table where

import Prelude

import Dexie.Promise (toAff)
import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Table as Table
import Dexie.Version as Version
import Foreign.Object as Object
import Test.Helpers (withCleanDB, unsafeGet, assertEqual)
import Test.Unit (TestSuite, suite, test)

tableTests :: TestSuite
tableTests = suite "table" do
  test "can add with an inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Add one row
    Table.add_ { id: 1, name: "John" } Nothing foo

    -- Check it equals what we'd expect
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet 1 foo

  test "can add with a non-inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db

    -- Add one row
    Table.add_ { name: "John" } (Just 1) foo

    -- Check it equals what we'd expect
    assertEqual (Just { name: "John" }) =<< unsafeGet 1 foo
