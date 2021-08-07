module Test.Helpers where

import Prelude

import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Dexie as Dexie
import Dexie.Data (DB)
import Dexie.DB as DB
import Dexie.Promise (Promise)
import Dexie.Promise as Promise
import Effect.Aff (Aff, Milliseconds(..), bracket, runAff_)
import Effect.Aff as Aff
import Test.Unit (Test)
import Test.Unit.Assert as Assert

cleanUp :: Aff Unit
cleanUp = Dexie.getDatabaseNames >>= traverse_ Dexie.delete

withCleanDB :: String -> (DB -> Test) -> Test
withCleanDB dbName fn = cleanUp *> withDB dbName fn

withDB :: String -> (DB -> Test) -> Test
withDB dbName = bracket (Dexie.new dbName) DB.close

unsafeUseAff :: forall a. Aff a -> Promise a
unsafeUseAff aff = Promise.new $ \resolve reject -> (flip $ runAff_) aff $ case _ of
  (Left error) -> reject error
  (Right value) -> resolve value

assert :: String -> Boolean -> Promise Unit
assert reason b = unsafeUseAff $ Assert.assert reason b

assertEqual :: forall a. Eq a => Show a => a -> a -> Promise Unit
assertEqual a b = unsafeUseAff $ Assert.equal a b

unsafeDelay :: Number -> Promise Unit
unsafeDelay milliseconds = unsafeUseAff $ Aff.delay (Milliseconds milliseconds)
