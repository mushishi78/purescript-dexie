module Dexie.Version (
    Version,
    stores,
    upgrade
) where

import Prelude

import Dexie.Promise (Promise)
import Dexie.Transaction (Transaction)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign.Object (Object)

foreign import data Version :: Type

foreign import _stores :: Object String -> Version -> Effect Version
foreign import _upgrade :: (Transaction -> Promise Unit) -> Version -> Effect Version

stores :: forall m. MonadEffect m => Object String -> Version -> m Version
stores schemaDefinition versionInstance = liftEffect $ _stores schemaDefinition versionInstance

upgrade :: forall m. MonadEffect m => (Transaction -> Promise Unit) -> Version -> m Version
upgrade onUpgrade versionInstance = liftEffect $ _upgrade onUpgrade versionInstance
