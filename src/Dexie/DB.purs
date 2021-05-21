module Dexie.DB where

import Prelude

import Control.Promise (Promise, toAffE)
import Dexie.Table (Table)
import Dexie.Version (Version)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)

foreign import data DB :: Type

foreign import versionImpl :: Int -> DB -> Effect Version
foreign import tableImpl :: String -> DB -> Effect Table
foreign import openImpl :: DB -> Effect (Promise Unit)
foreign import closeImpl :: DB -> Effect Unit
foreign import onBlockedImpl :: Effect Unit -> DB -> Effect Unit
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

onVersionChange :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onVersionChange callback db = liftEffect $ onVersionChangeImpl callback db
