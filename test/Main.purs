module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Dexie as Dexie
import Dexie.DB (DB)
import Dexie.DB as DB
import Dexie.Table as Table
import Dexie.Version as Version
import Effect (Effect)
import Effect.Aff (Aff, bracket, launchAff_)
import Foreign (unsafeToForeign)
import Foreign.Object as Object
import Test.Unit (Test, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "basic usage" do
    test "can write data to indexed db" $ withCleanDB "db" $ \db -> do
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "id")
        # void

      add db "foo" { id: 1, name: "John" } Nothing

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
          >>= Version.upgrade (\_ -> launchAff_ (add db "foo" { id: 1, name: "John" } Nothing))
          # void

        DB.open db

    test "can write with an non-inbound key" $ withCleanDB "db" $ \db -> do
      DB.version 1 db
        >>= Version.stores (Object.singleton "foo" "")
        # void

      add db "foo" { name: "John" } (Just 1)

cleanUp :: Aff Unit
cleanUp = Dexie.getDatabaseNames >>= traverse_ Dexie.delete

withCleanDB :: String -> (DB -> Test) -> Test
withCleanDB dbName fn = cleanUp *> withDB dbName fn

withDB :: String -> (DB -> Test) -> Test
withDB dbName = bracket (Dexie.new dbName) DB.close 

add :: forall a b. DB -> String -> a -> Maybe b -> Aff Unit
add db storeName item maybeKey = do
  DB.table storeName db
    >>= Table.add (unsafeToForeign item) (maybeKey)
    # void
