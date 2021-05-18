module Dexie.Version where

import Prelude

import Dexie.Transaction (Transaction)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign.Object (Object)

foreign import data Version :: Type

foreign import storesImpl :: Object String -> Version -> Effect Version
foreign import upgradeImpl :: (Transaction -> Effect Unit) -> Version -> Effect Version

stores :: forall m. MonadEffect m => Object String -> Version -> m Version
stores schemaDefinition versionInstance = liftEffect $ storesImpl schemaDefinition versionInstance

upgrade :: forall m. MonadEffect m => (Transaction -> Effect Unit) -> Version -> m Version
upgrade onUpgrade versionInstance = liftEffect $ upgradeImpl onUpgrade versionInstance
