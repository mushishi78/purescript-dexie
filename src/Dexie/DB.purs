module Dexie.DB (
    DB,
    version,
    table,
    transaction,
    open,
    close,
    onBlocked,
    onReady,
    onVersionChange,
    waitUntilReady
) where

import Prelude

import Data.Either (Either(..))
import Dexie.Promise (Promise)
import Dexie.Table (Table)
import Dexie.Transaction (Transaction)
import Dexie.Version (Version)
import Effect (Effect)
import Effect.Aff (makeAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign)

foreign import data DB :: Type

foreign import _version :: Int -> DB -> Effect Version
foreign import _table :: String -> DB -> Effect Table
foreign import _transaction :: DB -> String -> Array String -> (Transaction -> Promise Foreign) -> Promise Foreign
foreign import _open :: DB -> Promise Unit
foreign import _close :: DB -> Effect Unit
foreign import _onBlocked :: Effect Unit -> DB -> Effect Unit
foreign import _onReady :: Effect Unit -> DB -> Effect Unit
foreign import _onVersionChange :: Effect Unit -> DB -> Effect Unit

version :: forall me. MonadEffect me => Int -> DB -> me Version
version versionNumber db = liftEffect $ _version versionNumber db

table :: forall me. MonadEffect me => String -> DB -> me Table
table storeName db = liftEffect $ _table storeName db

transaction :: forall a. DB -> String -> Array String -> (Transaction -> Promise a) -> Promise a
transaction db mode tables callback = map unsafeFromForeign $ _transaction db mode tables cb
  where
    cb trnx = map unsafeToForeign $ callback trnx

open :: DB -> Promise Unit
open db = _open db

close :: forall me. MonadEffect me => DB -> me Unit
close db = liftEffect $ _close db

onBlocked :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onBlocked callback db = liftEffect $ _onBlocked callback db

onReady :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onReady callback db = liftEffect $ _onReady callback db

onVersionChange :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onVersionChange callback db = liftEffect $ _onVersionChange callback db

-- Helpers

waitUntilReady :: forall ma. MonadAff ma => DB -> ma Unit
waitUntilReady db = liftAff $ makeAff \callback -> do
  onReady (callback (Right unit)) db
  pure mempty

