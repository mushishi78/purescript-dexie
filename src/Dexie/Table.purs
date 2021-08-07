module Dexie.Table
  ( OnCreatingArgs
  , OnDeletingArgs
  , OnUpdatingArgs
  , add
  , bulkAdd
  , bulkDelete
  , bulkGet
  , bulkPut
  , clear
  , count
  , delete
  , each
  , filter
  , get
  , onCreating
  , onDeleting
  , onReading
  , onUpdating
  , limit
  , name
  , offset
  , orderBy
  , put
  , reverse
  , toArray
  , toCollection
  , update
  , whereClause
  , whereValues
  , add_
  , put_
  , update_
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Data.Nullable as Nullable
import Dexie.IndexName (class IndexName)
import Dexie.IndexName as IndexName
import Dexie.IndexedValue (class IndexedValue)
import Dexie.IndexedValue as IndexedValue
import Dexie.Data (Collection, Table, Transaction, WhereClause)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Exception (Error)
import Foreign (Foreign, unsafeToForeign)

-- | First argument given to callback with [onCreating](#v:onCreating).
type OnCreatingArgs =
  { primaryKey :: Nullable Foreign
  , item :: Foreign
  , transaction :: Transaction
  , setOnSuccess :: (Foreign -> Effect Unit) -> Effect Unit
  , setOnError :: (Error -> Effect Unit) -> Effect Unit
  }

-- | First argument given to callback with [onDeleting](#v:onDeleting).
type OnDeletingArgs =
  { primaryKey :: Foreign
  , item :: Foreign
  , transaction :: Transaction
  , setOnSuccess :: Effect Unit -> Effect Unit
  , setOnError :: (Error -> Effect Unit) -> Effect Unit
  }

-- | First argument given to callback with [onUpdating](#v:onUpdating).
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

-- | Documentation: [dexie.org/docs/Table/Table.add()](https://dexie.org/docs/Table/Table.add())
add :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Foreign
add item maybeKey table = _add foreignItem foreignKey table
  where
  foreignItem = unsafeToForeign item
  foreignKey = toNullable $ map IndexedValue.toForeign maybeKey

-- | Documentation: [dexie.org/docs/Table/Table.bulkAdd()](https://dexie.org/docs/Table/Table.bulkAdd())
bulkAdd :: forall item key. IndexedValue key => Array item -> Maybe (Array key) -> Table -> Promise (Array Foreign)
bulkAdd items maybeKeys table = _bulkAdd foreignItems foreignKeys table
  where
  foreignItems = map unsafeToForeign items
  foreignKeys = toNullable $ map (map IndexedValue.toForeign) maybeKeys

-- | Documentation: [dexie.org/docs/Table/Table.bulkDelete()](https://dexie.org/docs/Table/Table.bulkDelete())
bulkDelete :: forall key. IndexedValue key => Array key -> Table -> Promise Unit
bulkDelete keys table = _bulkDelete (map IndexedValue.toForeign keys) table

-- | Documentation: [dexie.org/docs/Table/Table.bulkGet()](https://dexie.org/docs/Table/Table.bulkGet())
bulkGet :: forall key. IndexedValue key => Array key -> Table -> Promise (Array (Maybe Foreign))
bulkGet keys table = map (map Nullable.toMaybe) $ _bulkGet foreignKeys table
  where
  foreignKeys = map IndexedValue.toForeign keys

-- | Documentation: [dexie.org/docs/Table/Table.bulkPut()](https://dexie.org/docs/Table/Table.bulkPut())
bulkPut :: forall item key. IndexedValue key => Array item -> Maybe (Array key) -> Table -> Promise (Array Foreign)
bulkPut items maybeKeys table = _bulkPut foreignItems foreignKeys table
  where
  foreignItems = map unsafeToForeign items
  foreignKeys = toNullable $ map (map IndexedValue.toForeign) maybeKeys

-- | Documentation: [dexie.org/docs/Table/Table.clear()](https://dexie.org/docs/Table/Table.clear())
clear :: Table -> Promise Unit
clear table = _clear table

-- | Documentation: [dexie.org/docs/Table/Table.count()](https://dexie.org/docs/Table/Table.count())
count :: Table -> Promise Int
count table = _count table

-- | Documentation: [dexie.org/docs/Table/Table.delete()](https://dexie.org/docs/Table/Table.delete())
delete :: forall key. IndexedValue key => key -> Table -> Promise Unit
delete key table = _delete (IndexedValue.toForeign key) table

-- | Documentation: [dexie.org/docs/Table/Table.each()](https://dexie.org/docs/Table/Table.each())
each :: (Foreign -> Effect Unit) -> Table -> Promise Unit
each onEach table = _each onEach table

-- | Documentation: [dexie.org/docs/Table/Table.filter()](https://dexie.org/docs/Table/Table.filter())
filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Table -> me Collection
filter filterFn table = liftEffect $ _filter filterFn table

-- | Documentation: [dexie.org/docs/Table/Table.get()](https://dexie.org/docs/Table/Table.get())
get :: forall key. IndexedValue key => key -> Table -> Promise (Maybe Foreign)
get key table = map Nullable.toMaybe $ _get (IndexedValue.toForeign key) table

-- | Documentation: [dexie.org/docs/Table/Table.hook('creating')](https://dexie.org/docs/Table/Table.hook('creating'))
onCreating :: forall me key. IndexedValue key => MonadEffect me => (OnCreatingArgs -> Effect (Maybe key)) -> Table -> me (Effect Unit)
onCreating callback table = liftEffect $ _onCreating nullableForeignCallback table
  where
  nullableForeignCallback args = map toNullable $ map (map IndexedValue.toForeign) $ callback args

-- | Documentation: [dexie.org/docs/Table/Table.hook('deleting')](https://dexie.org/docs/Table/Table.hook('deleting'))
onDeleting :: forall me. MonadEffect me => (OnDeletingArgs -> Effect Unit) -> Table -> me (Effect Unit)
onDeleting callback table = liftEffect $ _onDeleting callback table

-- | Documentation: [dexie.org/docs/Table/Table.hook('reading')](https://dexie.org/docs/Table/Table.hook('reading'))
onReading :: forall me item. MonadEffect me => (Foreign -> Effect item) -> Table -> me (Effect Unit)
onReading callback table = liftEffect $ _onReading foreignCallback table
  where
  foreignCallback args = map unsafeToForeign $ callback args

-- | Documentation: [dexie.org/docs/Table/Table.hook('updating')](https://dexie.org/docs/Table/Table.hook('updating'))
onUpdating :: forall me item. MonadEffect me => (OnUpdatingArgs -> Effect (Maybe item)) -> Table -> me (Effect Unit)
onUpdating callback table = liftEffect $ _onUpdating nullableForeignCallback table
  where
  nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

-- | Documentation: [dexie.org/docs/Table/Table.limit()](https://dexie.org/docs/Table/Table.limit())
limit :: forall me. MonadEffect me => Int -> Table -> me Collection
limit n table = liftEffect $ _limit n table

-- | Documentation: [dexie.org/docs/Table/Table.name](https://dexie.org/docs/Table/Table.name)
name :: forall me. MonadEffect me => Table -> me String
name table = liftEffect $ _name table

-- | Documentation: [dexie.org/docs/Table/Table.offset()](https://dexie.org/docs/Table/Table.offset())
offset :: forall me. MonadEffect me => Int -> Table -> me Collection
offset n table = liftEffect $ _offset n table

-- | Documentation: [dexie.org/docs/Table/Table.orderBy()](https://dexie.org/docs/Table/Table.orderBy())
orderBy :: forall me. MonadEffect me => String -> Table -> me Collection
orderBy index table = liftEffect $ _orderBy index table

-- | Documentation: [dexie.org/docs/Table/Table.put()](https://dexie.org/docs/Table/Table.put())
put :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Foreign
put item maybeKey table = _put foreignItem foreignKey table
  where
  foreignItem = unsafeToForeign item
  foreignKey = toNullable $ map IndexedValue.toForeign maybeKey

-- | Documentation: [dexie.org/docs/Table/Table.reverse()](https://dexie.org/docs/Table/Table.reverse())
reverse :: forall me. MonadEffect me => Table -> me Collection
reverse table = liftEffect $ _reverse table

-- | Documentation: [dexie.org/docs/Table/Table.toArray()](https://dexie.org/docs/Table/Table.toArray())
toArray :: Table -> Promise (Array Foreign)
toArray table = _toArray table

-- | Documentation: [dexie.org/docs/Table/Table.toCollection()](https://dexie.org/docs/Table/Table.toCollection())
toCollection :: forall me. MonadEffect me => Table -> me Collection
toCollection table = liftEffect $ _toCollection table

-- | Documentation: [dexie.org/docs/Table/Table.update()](https://dexie.org/docs/Table/Table.update())
update :: forall key changes. IndexedValue key => key -> changes -> Table -> Promise Int
update key changes table = _update (IndexedValue.toForeign key) (unsafeToForeign changes) table

-- | Intended for chanined where clauses. eg.
-- |
-- | ```
-- | result <- Table.whereClause "age" foo >>= WhereClause.above 18 >>= Collection.toArray
-- | ```
-- |
-- | Documentation: [dexie.org/docs/Table/Table.where()](https://dexie.org/docs/Table/Table.where())
whereClause :: forall me indexName. IndexName indexName => MonadEffect me => indexName -> Table -> me WhereClause
whereClause indexName table = liftEffect $ _whereClause (IndexName.toForeign indexName) table

-- | Intended to be used with an object of key valuess. e.g.
-- |
-- | ```
-- | result <- Table.whereValues { title: "Sir", age: 18 } foo >>= Collection.toArray
-- | ```
-- |
-- | Documentation: [dexie.org/docs/Table/Table.where()](https://dexie.org/docs/Table/Table.where())
whereValues :: forall me values. MonadEffect me => values -> Table -> me Collection
whereValues values table = liftEffect $ _whereValues (unsafeToForeign values) table

-- Helpers

-- | Version of [add](#v:add) that does not return the id of the item added
add_ :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Unit
add_ item maybeKey table = void $ add item maybeKey table

-- | Version of [put](#v:put) that does not return the id of the item updated
put_ :: forall item key. IndexedValue key => item -> Maybe key -> Table -> Promise Unit
put_ item maybeKey table = void $ put item maybeKey table

-- | Version of [put](#v:put) that does not return the id of the item updated
update_ :: forall key changes. IndexedValue key => key -> changes -> Table -> Promise Unit
update_ key changes table = void $ update key changes table
