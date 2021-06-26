module Dexie (
    new,
    delete,
    getDatabaseNames,
    exists,
    getDebug,
    setDebug
) where

import Prelude

import Dexie.Data (DB)
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

-- | Equivalent of calling `new Dexie(dbName)`.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie](https://dexie.org/docs/Dexie/Dexie)
new :: forall me. MonadEffect me => String -> me DB
new dbName = liftEffect $ _new dbName

-- | Deletes the database called `dbName`.
-- | If the database does not exist this method will still succeed.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.delete()](https://dexie.org/docs/Dexie/Dexie.delete())
delete :: forall ma. MonadAff ma => String -> ma Unit
delete dbName = liftAff $ toAff $ _delete dbName

-- | Returns an array of database names at current host.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.getDatabaseNames()](https://dexie.org/docs/Dexie/Dexie.getDatabaseNames())
getDatabaseNames :: forall ma. MonadAff ma => ma (Array String)
getDatabaseNames = liftAff $ toAff _getDatabaseNames

-- | Checks whether a database with the given name exists or not.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.exists()](https://dexie.org/docs/Dexie/Dexie.exists())
exists :: forall ma. MonadAff ma => String -> ma Boolean
exists dbName = liftAff $ toAff $ _exists dbName

-- | Gets whether exception’s stacks will have long-stack support
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.debug](https://dexie.org/docs/Dexie/Dexie.debug)
getDebug :: forall me. MonadEffect me => me (Boolean)
getDebug = liftEffect _getDebug

-- | Sets whether exception’s stacks will have long-stack support
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.debug](https://dexie.org/docs/Dexie/Dexie.debug)
setDebug :: forall me. MonadEffect me => Boolean -> me Unit
setDebug isDebugging = liftEffect $ _setDebug isDebugging
