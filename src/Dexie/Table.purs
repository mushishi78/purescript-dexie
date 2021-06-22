module Dexie.Table (
    module DataRexports,
    add,
    bulkAdd,
    bulkDelete,
    bulkGet,
    bulkPut,
    clear,
    count,
    delete,
    each,
    filter,
    get,
    onCreating,
    onDeleting,
    onReading,
    onUpdating,
    limit,
    name,
    offset,
    orderBy,
    put,
    reverse,
    toArray,
    toCollection,
    update,
    whereClause,
    whereValues,
    add_,
    put_,
    update_
) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Data.Nullable as Nullable
import Dexie.Collection (Collection)
import Dexie.IndexName (class IndexName)
import Dexie.IndexName as IndexName
import Dexie.IndexedValue (class IndexedValue)
import Dexie.IndexedValue as IndexedValue
import Dexie.Internal.Data (Table) as DataRexports
import Dexie.Internal.Data (Table, Transaction, WhereClause)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Exception (Error)
import Foreign (Foreign, unsafeToForeign)

type OnCreatingArgs =
    { primaryKey :: Nullable Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: (Foreign -> Effect Unit) -> Effect Unit
    , setOnError :: (Error -> Effect Unit) -> Effect Unit
    }

type OnDeletingArgs =
    { primaryKey :: Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: Effect Unit -> Effect Unit
    , setOnError :: (Error -> Effect Unit)-> Effect Unit
    }

type OnUpdatingArgs =
    { modifications :: Foreign
    , primaryKey :: Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: (Foreign -> Effect Unit) -> Effect Unit
    , setOnError :: (Error -> Effect Unit) -> Effect Unit
    }

foreign import _add :: Foreign -> Nullable Foreign -> Table -> Promise Foreign
foreign import _bulkAdd :: Array Foreign -> Nullable (Array Foreign) -> Table -> Promise (Array Foreign)
foreign import _bulkDelete :: Array Foreign -> Table -> Promise Unit
foreign import _bulkGet :: Array Foreign -> Table -> Promise (Array (Nullable Foreign))
foreign import _bulkPut :: Array Foreign -> Nullable (Array Foreign) -> Table -> Promise (Array Foreign)
foreign import _clear :: Table -> Promise Unit
foreign import _count :: Table -> Promise Int
foreign import _delete :: Foreign -> Table -> Promise Unit
foreign import _each :: (Foreign -> Effect Unit) -> Table -> Promise Unit
foreign import _filter :: (Foreign -> Boolean) -> Table -> Effect Collection
foreign import _get :: Foreign -> Table -> Promise (Nullable Foreign)
foreign import _onCreating :: (OnCreatingArgs -> Effect (Nullable Foreign)) -> Table -> Effect (Effect Unit)
foreign import _onDeleting :: (OnDeletingArgs -> Effect Unit) -> Table -> Effect (Effect Unit)
foreign import _onReading :: (Foreign -> Effect Foreign) -> Table -> Effect (Effect Unit)
foreign import _onUpdating :: (OnUpdatingArgs -> Effect (Nullable Foreign)) -> Table -> Effect (Effect Unit)
foreign import _limit :: Int -> Table -> Effect Collection
foreign import _name :: Table -> Effect String
foreign import _offset :: Int -> Table -> Effect Collection
foreign import _orderBy :: String -> Table -> Effect Collection
foreign import _put :: Foreign -> Nullable Foreign -> Table -> Promise Foreign
foreign import _reverse :: Table -> Effect Collection
foreign import _toArray :: Table -> Promise (Array Foreign)
foreign import _toCollection :: Table -> Effect Collection
foreign import _update :: Foreign -> Foreign -> Table -> Promise Int
foreign import _whereClause :: Foreign -> Table -> Effect WhereClause
foreign import _whereValues :: Foreign -> Table -> Effect Collection

add :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Foreign
add item maybeKey table = _add foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map IndexedValue.toForeign maybeKey


bulkAdd :: forall item key. IndexedValue key => Array item -> Maybe (Array key) -> Table -> Promise (Array Foreign)
bulkAdd items maybeKeys table = _bulkAdd foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map IndexedValue.toForeign) maybeKeys

bulkDelete :: forall key. IndexedValue key => Array key -> Table -> Promise Unit
bulkDelete keys table = _bulkDelete (map IndexedValue.toForeign keys) table

bulkGet :: forall key. IndexedValue key => Array key -> Table -> Promise (Array (Maybe Foreign))
bulkGet keys table = map (map Nullable.toMaybe) $ _bulkGet foreignKeys table
  where
    foreignKeys = map IndexedValue.toForeign keys

bulkPut :: forall item key. IndexedValue key => Array item -> Maybe (Array key) -> Table -> Promise (Array Foreign)
bulkPut items maybeKeys table = _bulkPut foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map IndexedValue.toForeign) maybeKeys

clear :: Table -> Promise Unit
clear table = _clear table

count :: Table -> Promise Int
count table = _count table

delete :: forall key. IndexedValue key => key -> Table -> Promise Unit
delete key table = _delete (IndexedValue.toForeign key) table

each :: (Foreign -> Effect Unit) -> Table -> Promise Unit
each onEach table = _each onEach table

filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Table -> me Collection
filter filterFn table = liftEffect $ _filter filterFn table

get :: forall key. IndexedValue key => key -> Table -> Promise (Maybe Foreign)
get key table = map Nullable.toMaybe $ _get (IndexedValue.toForeign key) table

onCreating :: forall me key. IndexedValue key => MonadEffect me => (OnCreatingArgs -> Effect (Maybe key)) -> Table -> me (Effect Unit)
onCreating callback table = liftEffect $ _onCreating nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map IndexedValue.toForeign) $ callback args

onDeleting :: forall me. MonadEffect me => (OnDeletingArgs -> Effect Unit) -> Table -> me (Effect Unit)
onDeleting callback table = liftEffect $ _onDeleting callback table

onReading :: forall me item. MonadEffect me => (Foreign -> Effect item) -> Table -> me (Effect Unit)
onReading callback table = liftEffect $ _onReading foreignCallback table
  where
    foreignCallback args = map unsafeToForeign $ callback args

onUpdating :: forall me item. MonadEffect me => (OnUpdatingArgs -> Effect (Maybe item)) -> Table -> me (Effect Unit)
onUpdating callback table = liftEffect $ _onUpdating nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

limit :: forall me. MonadEffect me => Int -> Table -> me Collection
limit n table = liftEffect $ _limit n table

name :: forall me. MonadEffect me => Table -> me String
name table = liftEffect $ _name table

offset :: forall me. MonadEffect me => Int -> Table -> me Collection
offset n table = liftEffect $ _offset n table

orderBy :: forall me. MonadEffect me => String -> Table -> me Collection
orderBy index table = liftEffect $ _orderBy index table

put :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Foreign
put item maybeKey table = _put foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map IndexedValue.toForeign maybeKey

reverse :: forall me. MonadEffect me => Table -> me Collection
reverse table = liftEffect $ _reverse table

toArray :: Table -> Promise (Array Foreign)
toArray table = _toArray table

toCollection :: forall me. MonadEffect me => Table -> me Collection
toCollection table = liftEffect $ _toCollection table

update :: forall key changes. IndexedValue key => key -> changes -> Table -> Promise Int
update key changes table = _update (IndexedValue.toForeign key) (unsafeToForeign changes) table

whereClause :: forall me indexName. IndexName indexName => MonadEffect me => indexName -> Table -> me WhereClause
whereClause indexName table = liftEffect $ _whereClause (IndexName.toForeign indexName) table

whereValues :: forall me values. MonadEffect me => values -> Table -> me Collection
whereValues values table = liftEffect $ _whereValues (unsafeToForeign values) table

-- Helpers

add_ :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Unit
add_ item maybeKey table = void $ add item maybeKey table

put_ :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Unit
put_ item maybeKey table = void $ put item maybeKey table

update_ :: forall key changes. IndexedValue key => key -> changes -> Table -> Promise Unit
update_ key changes table = void $ update key changes table
