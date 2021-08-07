module Dexie.DB
  ( version
  , table
  , tables
  , transaction
  , open
  , close
  , onBlocked
  , onReady
  , onVersionChange
  , waitUntilReady
  ) where

import Prelude

import Data.Either (Either(..))
import Dexie.Data (DB, Table, Transaction, Version)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Aff (makeAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign)

foreign import _version :: Int -> DB -> Effect Version
foreign import _table :: String -> DB -> Effect Table
foreign import _tables :: DB -> Effect (Array Table)
foreign import _transaction :: DB -> String -> Array String -> (Transaction -> Promise Foreign) -> Promise Foreign
foreign import _open :: DB -> Promise Unit
foreign import _close :: DB -> Effect Unit
foreign import _onBlocked :: Effect Unit -> DB -> Effect Unit
foreign import _onReady :: Effect Unit -> DB -> Effect Unit
foreign import _onVersionChange :: Effect Unit -> DB -> Effect Unit

-- | Create a version definition for migrating the database schema.
-- | See [Dexie.Version](Dexie.Version#m:Version)
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.version()](https://dexie.org/docs/Dexie/Dexie.version())
version :: forall me. MonadEffect me => Int -> DB -> me Version
version versionNumber db = liftEffect $ _version versionNumber db

-- | Retrieve the `Table` for an object store. See [Dexie.Table](Dexie.Table#m:Table)
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.table()](https://dexie.org/docs/Dexie/Dexie.table())
table :: forall me. MonadEffect me => String -> DB -> me Table
table storeName db = liftEffect $ _table storeName db

-- | Retrieve all the `Table` instances for all the object stores. See [Dexie.Table](Dexie.Table#m:Table)
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.tables](https://dexie.org/docs/Dexie/Dexie.table)
tables :: forall me. MonadEffect me => DB -> me (Array Table)
tables db = liftEffect $ _tables db

-- | Creates a database transaction. See [Dexie.Transaction](Dexie.Transaction#m:Transaction)
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.transaction()](https://dexie.org/docs/Dexie/Dexie.transaction())
transaction :: forall a. DB -> String -> Array String -> (Transaction -> Promise a) -> Promise a
transaction db mode ts callback = map unsafeFromForeign $ _transaction db mode ts cb
  where
  cb trnx = map unsafeToForeign $ callback trnx

-- | Opens the database connection. By default, db.open() will be called
-- | automatically on first query to the db.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.open()](https://dexie.org/docs/Dexie/Dexie.open())
open :: DB -> Promise Unit
open db = _open db

-- | Closes the database. This operation completes immediately.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.close()](https://dexie.org/docs/Dexie/Dexie.close())
close :: forall me. MonadEffect me => DB -> me Unit
close db = liftEffect $ _close db

-- | The “blocked” event occurs if database upgrade is blocked by another tab or
-- | browser window keeping a connection open towards the database
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.on.blocked](https://dexie.org/docs/Dexie/Dexie.on.blocked)
onBlocked :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onBlocked callback db = liftEffect $ _onBlocked callback db

-- | Callback executed when database has successfully opened.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.on.ready](https://dexie.org/docs/Dexie/Dexie.on.ready)
onReady :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onReady callback db = liftEffect $ _onReady callback db

-- | The “versionchange” event occurs if another indexedDB database instance
-- | needs to upgrade or delete the database.
-- |
-- | Documentation: [dexie.org/docs/Dexie/Dexie.on.versionchange](https://dexie.org/docs/Dexie/Dexie.on.versionchange)
onVersionChange :: forall me. MonadEffect me => Effect Unit -> DB -> me Unit
onVersionChange callback db = liftEffect $ _onVersionChange callback db

-- Helpers

-- | Helper to wait for [onReady](#v:onReady) in `MonadAff`
waitUntilReady :: forall ma. MonadAff ma => DB -> ma Unit
waitUntilReady db = liftAff $ makeAff \callback -> do
  onReady (callback (Right unit)) db
  pure mempty

