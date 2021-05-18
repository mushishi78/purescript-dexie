module Dexie where

import Prelude

import Control.Promise (Promise, toAffE)
import Dexie.DB (DB)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)

foreign import newImpl :: String -> Effect DB
foreign import deleteImpl :: String -> Effect (Promise Unit)
foreign import getDatabaseNamesImpl :: Effect (Promise (Array String))
foreign import existsImpl :: String -> Effect (Promise Boolean)
foreign import getDebugImpl :: Effect (Boolean)
foreign import setDebugImpl :: Boolean -> Effect Unit

new :: forall m. MonadEffect m => String -> m DB
new dbName = liftEffect $ newImpl dbName

delete :: forall m. MonadAff m => String -> m Unit
delete dbName = liftAff $ toAffE $ deleteImpl dbName

getDatabaseNames :: forall m. MonadAff m => m (Array String)
getDatabaseNames = liftAff $ toAffE getDatabaseNamesImpl

exists :: forall m. MonadAff m => String -> m Boolean
exists dbName = liftAff $ toAffE $ existsImpl dbName

getDebug :: forall m. MonadEffect m => m (Boolean)
getDebug = liftEffect getDebugImpl

setDebug :: forall m. MonadEffect m => Boolean -> m Unit
setDebug isDebugging = liftEffect $ setDebugImpl isDebugging