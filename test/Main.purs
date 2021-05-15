module Test.Main where

import Prelude

import Data.Foldable (traverse_)
import Dexie as Dexie
import Dexie.DB as DB
import Dexie.Table as Table
import Dexie.Version as Version
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)
import Foreign.Object as Object
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "basic usage" do
    test "can write data to indexed db" do
      cleanup

      db <- liftEffect (Dexie.new "db")
      _ <- liftEffect $ DB.version 1 db >>= Version.stores (Object.singleton "foo" "id")
      _ <- liftEffect (DB.table "foo" db) >>= Table.add (unsafeToForeign { id: 1, name: "John" })

      pure unit


cleanup :: Aff Unit
cleanup = Dexie.getDatabaseNames >>= traverse_ Dexie.delete
