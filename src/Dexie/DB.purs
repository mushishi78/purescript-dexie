module Dexie.DB (
    DB,
    version,
    table,
    open,
    close,
    onBlocked,
    onReady,
    onVersionChange,
    waitUntilReady
) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Either (Either(..))
import Dexie.Table (Table)
import Dexie.Version (Version)
import Effect (Effect)
import Effect.Aff (makeAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)

foreign import data DB :: Type

foreign import versionImpl :: Int -> DB -> Effect Version
foreign import tableImpl :: String -> DB -> Effect Table
foreign import openImpl :: DB -> Effect (Promise Unit)
foreign import closeImpl :: DB -> Effect Unit
foreign import onBlockedImpl :: Effect Unit -> DB -> Effect Unit
foreign import onReadyImpl :: Effect Unit -> DB -> Effect Unit
foreign import onVersionChangeImpl :: Effect Unit -> DB -> Effect Unit

version :: forall me. MonadEffect me => Int -> DB -> me Version
version versionNumber db = liftEffect $ versionImpl versionNumber db

table :: forall me. MonadEffect me => String -> DB -> me Table
table storeName db = liftEffect $ tableImpl storeName db

open :: forall ma. MonadAff ma => DB -> ma Unit
open db = liftAff $ toAffE $ openImpl db

close :: forall me. MonadEffect me => DB -> me Unit
close db = liftEffect $ closeImpl db

onBlocked :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onBlocked callback db = liftEffect $ onBlockedImpl callback db

onReady :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onReady callback db = liftEffect $ onReadyImpl callback db

onVersionChange :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onVersionChange callback db = liftEffect $ onVersionChangeImpl callback db

-- Helpers

waitUntilReady :: forall ma. MonadAff ma => DB -> ma Unit
waitUntilReady db = liftAff $ makeAff \callback -> do
  onReady (callback (Right unit)) db
  pure mempty

