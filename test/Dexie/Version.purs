module Test.Dexie.Version where

import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Data (Table)
import Dexie.IndexedValue (class IndexedValue)
import Dexie.Promise (Promise, toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Foreign (unsafeFromForeign)
import Test.Helpers (assertEqual, cleanUp, withDB)
import Test.Unit (TestSuite, suite, test)

versionTests :: TestSuite
versionTests = suite "version" do
  let
    unsafeGet :: forall key item. IndexedValue key => key -> Table -> Promise (Maybe item)
    unsafeGet key table = Table.get key table # map (map unsafeFromForeign)

    nothingInt :: Maybe Int
    nothingInt = Nothing

  test "can make an upgrade migration" do
    cleanUp

    -- Move off version 0
    withDB "db" $ \db -> toAff do
      DB.version 1 db # void
      DB.open db

    -- Migrate from 1 -> 2
    withDB "db" $ \db -> toAff do
      DB.version 2 db
        >>= Version.stores { foo: Just "id" }
        >>= Version.upgrade_
          ( \_ -> do
              -- Add row to table
              Table.add_ { id: 1, name: "John" } nothingInt =<< DB.table "foo" db
          )

      DB.open db

      -- Check that row is there
      DB.table "foo" db
        >>= unsafeGet 1
        >>= assertEqual (Just { id: 1, name: "John" })

  test "can make 2 asynchronous migrations serially" do
    cleanUp

    -- Move off version 0
    withDB "db" $ \db -> toAff do
      DB.version 1 db >>= Version.stores_ { foo: Just "++id", bar: Just "++id" }
      DB.open db

    withDB "db" $ \db -> toAff do
      DB.version 1 db >>= Version.stores_ { foo: Just "++id", bar: Just "++id" }

      -- Migrate from 1 -> 2 slowly
      DB.version 2 db >>= Version.upgrade_
        ( \_ -> do
            -- Waste some time inserting into a different table
            bar <- DB.table "bar" db
            Table.add_ {} nothingInt bar
            Table.add_ {} nothingInt bar
            Table.add_ {} nothingInt bar
            Table.add_ {} nothingInt bar

            -- Add row to foo table
            Table.add_ { name: "John" } nothingInt =<< DB.table "foo" db
        )

      -- Migrate from 2 -> 3 quicker
      DB.version 3 db >>= Version.upgrade_
        ( \_ -> do
            -- Add another row to foo table
            Table.add_ { name: "Harry" } nothingInt =<< DB.table "foo" db
        )

      DB.open db

      -- Check that row 1 is John, not Harry
      assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet 1 =<< DB.table "foo" db
