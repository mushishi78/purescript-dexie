module Dexie.Version (
    Version,
    stores,
    upgrade
) where

import Prelude

import Control.Promise (Promise, fromAff)
import Dexie.Transaction (Transaction)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign.Object (Object)

foreign import data Version :: Type

foreign import storesImpl :: Object String -> Version -> Effect Version
foreign import upgradeImpl :: (Transaction -> Effect (Promise Unit)) -> Version -> Effect Version

stores :: forall m. MonadEffect m => Object String -> Version -> m Version
stores schemaDefinition versionInstance = liftEffect $ storesImpl schemaDefinition versionInstance

upgrade :: forall m. MonadEffect m => (Transaction -> Aff Unit) -> Version -> m Version
upgrade onUpgrade versionInstance = liftEffect $ upgradeImpl (onUpgrade >>> fromAff) versionInstance
