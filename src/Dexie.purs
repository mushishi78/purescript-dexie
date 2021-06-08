module Dexie (
    new,
    delete,
    getDatabaseNames,
    exists,
    getDebug,
    setDebug
) where

import Prelude

import Dexie.DB (DB)
import Dexie.Promise (Promise, toAff)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)

foreign import _new :: String -> Effect DB
foreign import _delete :: String -> Promise Unit
foreign import _getDatabaseNames :: Promise (Array String)
foreign import _exists :: String -> Promise Boolean
foreign import _getDebug :: Effect Boolean
foreign import _setDebug :: Boolean -> Effect Unit

new :: forall me. MonadEffect me => String -> me DB
new dbName = liftEffect $ _new dbName

delete :: forall ma. MonadAff ma => String -> ma Unit
delete dbName = liftAff $ toAff $ _delete dbName

getDatabaseNames :: forall ma. MonadAff ma => ma (Array String)
getDatabaseNames = liftAff $ toAff _getDatabaseNames

exists :: forall ma. MonadAff ma => String -> ma Boolean
exists dbName = liftAff $ toAff $ _exists dbName

getDebug :: forall me. MonadEffect me => me (Boolean)
getDebug = liftEffect _getDebug

setDebug :: forall me. MonadEffect me => Boolean -> me Unit
setDebug isDebugging = liftEffect $ _setDebug isDebugging
