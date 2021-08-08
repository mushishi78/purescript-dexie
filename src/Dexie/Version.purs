module Dexie.Version
  ( stores
  , stores_
  , upgrade
  , upgrade_
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Dexie.Data (Transaction, Version)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign.Object (Object)

foreign import _stores :: Object (Nullable String) -> Version -> Effect Version
foreign import _upgrade :: (Transaction -> Promise Unit) -> Version -> Effect Version

-- | Specify the database schema (object stores and indexes) for a certain version.
-- |
-- | Documentation: [dexie.org/docs/Version/Version.stores()](https://dexie.org/docs/Version/Version.stores())
stores :: forall m. MonadEffect m => Object (Maybe String) -> Version -> m Version
stores schemaDefinition versionInstance = liftEffect $ _stores nullableSchemaDefinition versionInstance
  where
  nullableSchemaDefinition = map toNullable schemaDefinition

-- | Version of [stores](#v:stores) without a return value.
stores_ :: forall m. MonadEffect m => Object (Maybe String) -> Version -> m Unit
stores_ schemaDefinition versionInstance = void $ stores schemaDefinition versionInstance

-- | Specify an upgrade function for upgrading between previous version to this one.
-- |
-- | Documentation: [dexie.org/docs/Version/Version.upgrade()](https://dexie.org/docs/Version/Version.upgrade())
upgrade :: forall m. MonadEffect m => (Transaction -> Promise Unit) -> Version -> m Version
upgrade onUpgrade versionInstance = liftEffect $ _upgrade onUpgrade versionInstance

-- | Version of [upgrade](#v:upgrade) without a return value.
upgrade_ :: forall m. MonadEffect m => (Transaction -> Promise Unit) -> Version -> m Unit
upgrade_ onUpgrade versionInstance = void $ upgrade onUpgrade versionInstance
