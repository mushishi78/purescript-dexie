module Test.Helpers where

import Prelude

import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Data.Maybe (Maybe)
import Dexie as Dexie
import Dexie.DB (DB)
import Dexie.DB as DB
import Dexie.Promise (Promise)
import Dexie.Promise as Promise
import Dexie.Table (Table)
import Dexie.Table as Table
import Effect.Aff (Aff, Milliseconds(..), bracket, runAff_)
import Effect.Aff as Aff
import Foreign (unsafeFromForeign)
import Test.Unit (Test)
import Test.Unit.Assert as Assert

cleanUp :: Aff Unit
cleanUp = Dexie.getDatabaseNames >>= traverse_ Dexie.delete

withCleanDB :: String -> (DB -> Test) -> Test
withCleanDB dbName fn = cleanUp *> withDB dbName fn

withDB :: String -> (DB -> Test) -> Test
withDB dbName = bracket (Dexie.new dbName) DB.close

unsafeGet :: forall key item. key -> Table -> Promise (Maybe item)
unsafeGet key table = Table.get key table # map (map unsafeFromForeign)

unsafeUseAff :: forall a. Aff a -> Promise a
unsafeUseAff aff = Promise.new $ \resolve reject -> (flip $ runAff_) aff $ case _ of
    (Left error) -> reject error
    (Right value) -> resolve value

assert :: String -> Boolean -> Promise Unit
assert reason b = unsafeUseAff $ Assert.assert reason b

assertEqual :: forall a. Eq a => Show a => a -> a -> Promise Unit
assertEqual a b = unsafeUseAff $ Assert.equal a b

delay :: Number -> Promise Unit
delay milliseconds = unsafeUseAff $ Aff.delay (Milliseconds milliseconds)
