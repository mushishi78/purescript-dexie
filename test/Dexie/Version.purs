module Test.Dexie.Version where

import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Foreign.Object as Object
import Test.Helpers (assertEqual, cleanUp, unsafeGet, withDB)
import Test.Unit (TestSuite, suite, test)

versionTests :: TestSuite
versionTests = suite "version" do
  test "can make an upgrade migration" do
    cleanUp

    -- Move off version 0
    withDB "db" $ \db -> toAff do
      DB.version 1 db # void
      DB.open db

    -- Migrate from 1 -> 2
    withDB "db" $ \db -> toAff do
      DB.version 2 db
        >>= Version.stores (Object.singleton "foo" "id")
        >>= Version.upgrade (
          \_ -> do
            -- Add row to table
            DB.table "foo" db
              >>= Table.add_ { id: 1, name: "John" } Nothing
        )
        # void

      DB.open db

      -- Check that row is there
      DB.table "foo" db
        >>= unsafeGet 1
        >>= assertEqual (Just { id: 1, name: "John" })

  test "can make 2 asynchronous migrations serially" do
    cleanUp

    -- Move off version 0
    withDB "db" $ \db -> toAff do
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "++id" # Object.insert "bar" "++id")
        # void
      DB.open db

    withDB "db" $ \db -> toAff do
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "++id" # Object.insert "bar" "++id")
        # void

      -- Migrate from 1 -> 2 slowly
      DB.version 2 db
        >>= Version.upgrade (
          \_ -> do
            -- Waste some time inserting into a different table
            bar <- DB.table "bar" db
            Table.add_ {} Nothing bar
            Table.add_ {} Nothing bar
            Table.add_ {} Nothing bar
            Table.add_ {} Nothing bar

            -- Add row to foo table
            DB.table "foo" db
              >>= Table.add_ { name: "John" } Nothing
        )
        # void

      -- Migrate from 2 -> 3 quicker
      DB.version 3 db
        >>= Version.upgrade (
          \_ -> do
            -- Add another row to foo table
            DB.table "foo" db
              >>= Table.add_ { name: "Harry" } Nothing
        )
        # void

      DB.open db

      -- Check that row 1 is John, not Harry
      DB.table "foo" db
        >>= unsafeGet 1
        >>= assertEqual (Just { id: 1, name: "John" })

