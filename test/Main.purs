module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Dexie as Dexie
import Dexie.DB (DB)
import Dexie.DB as DB
import Dexie.Table (Table)
import Dexie.Table as Table
import Dexie.Version as Version
import Effect (Effect)
import Effect.Aff (Aff, bracket, launchAff_)
import Foreign (unsafeFromForeign)
import Foreign.Object as Object
import Test.Unit (Test, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "basic usage" do
    test "can write and read data to indexed db" $ withCleanDB "db" $ \db -> do
      -- Migrate to version 1
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "id")
        # void

      -- Get reference to table
      table <- DB.table "foo" db

      -- Add one row
      add_ { id: 1, name: "John" } Nothing table

      -- Check it equals what we'd expect
      unsafeGet 1 table
        >>= Assert.equal (Just { id: 1, name: "John" }) 

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
                >>= add_ { id: 1, name: "John" } Nothing
          )
          # void

        DB.open db

        -- Check that row is there
        DB.table "foo" db
          >>= unsafeGet 1
          >>= Assert.equal (Just { id: 1, name: "John" }) 

    test "can write with an non-inbound key" $ withCleanDB "db" $ \db -> do
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "")
        # void

      -- Get reference to table
      table <- DB.table "foo" db

      -- Add one row
      add_ { name: "John" } (Just 1) table

      -- Read from row 1
      maybeValue <- unsafeGet 1 table

      -- Check it equals what we'd expect
      Assert.equal (Just { name: "John" }) maybeValue 

cleanUp :: Aff Unit
cleanUp = Dexie.getDatabaseNames >>= traverse_ Dexie.delete

withCleanDB :: String -> (DB -> Test) -> Test
withCleanDB dbName fn = cleanUp *> withDB dbName fn

withDB :: String -> (DB -> Test) -> Test
withDB dbName = bracket (Dexie.new dbName) DB.close 

add_ :: forall a b. a -> Maybe b -> Table -> Aff Unit
add_ item maybeKey table = Table.add item maybeKey table # void

unsafeGet :: forall key item. key -> Table -> Aff (Maybe item)
unsafeGet key table = Table.get key table # map (map unsafeFromForeign)
