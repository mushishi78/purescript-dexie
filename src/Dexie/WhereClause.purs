module Dexie.WhereClause (module DataRexports, startsWith) where

import Prelude

import Dexie.Collection (Collection)
import Dexie.Internal.Data (WhereClause) as DataRexports
import Dexie.Internal.Data (WhereClause)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)

foreign import _startsWith :: String -> WhereClause -> Effect Collection

startsWith :: forall me. MonadEffect me => String -> WhereClause -> me Collection
startsWith prefix whereClause = liftEffect $ _startsWith prefix whereClause

