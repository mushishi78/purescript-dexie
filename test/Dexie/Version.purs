module Test.Dexie.Version where

import Prelude

import Data.Maybe (Maybe(..))
import Dexie.DB as DB
import Dexie.Table as Table
import Dexie.Version as Version
import Effect.Aff (launchAff_)
import Foreign.Object as Object
import Test.Helpers (cleanUp, unsafeGet, withDB)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

versionTests :: TestSuite
versionTests = suite "version" do
  test "can make an upgrade migration" $ do
    cleanUp

    -- Move off version 0
    withDB "db" $ \db -> do
      DB.version 1 db # void
      DB.open db

    -- Migrate from 1 -> 2
    withDB "db" $ \db -> do
      DB.version 2 db
        >>= Version.stores (Object.singleton "foo" "id")
        >>= Version.upgrade (
          \_ -> launchAff_ do
            -- Add row to table
            DB.table "foo" db
              >>= Table.add_ { id: 1, name: "John" } Nothing
        )
        # void

      DB.open db

      -- Check that row is there
      DB.table "foo" db
        >>= unsafeGet 1
        >>= Assert.equal (Just { id: 1, name: "John" })
