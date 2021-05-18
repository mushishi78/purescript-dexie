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

version :: forall m. MonadEffect m => Int -> DB -> m Version
version versionNumber db = liftEffect $ versionImpl versionNumber db

table :: forall m. MonadEffect m => String -> DB -> m Table
table storeName db = liftEffect $ tableImpl storeName db

open :: forall m. MonadAff m => DB -> m Unit
open db = liftAff $ toAffE $ openImpl db

close :: forall m. MonadEffect m => DB -> m Unit
close db = liftEffect $ closeImpl db
