module Test.Helpers where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe)
import Dexie as Dexie
import Dexie.DB (DB)
import Dexie.DB as DB
import Dexie.Table (Table)
import Dexie.Table as Table
import Effect.Aff (Aff, bracket)
import Foreign (unsafeFromForeign)
import Test.Unit (Test)

cleanUp :: Aff Unit
cleanUp = Dexie.getDatabaseNames >>= traverse_ Dexie.delete

withCleanDB :: String -> (DB -> Test) -> Test
withCleanDB dbName fn = cleanUp *> withDB dbName fn

withDB :: String -> (DB -> Test) -> Test
withDB dbName = bracket (Dexie.new dbName) DB.close

unsafeGet :: forall key item. key -> Table -> Aff (Maybe item)
unsafeGet key table = Table.get key table # map (map unsafeFromForeign)
