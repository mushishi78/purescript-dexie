module Dexie.Table (
    module TableRexports,
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
    add_
) where

import Prelude

import Control.Promise (toAffE)
import Data.Maybe (Maybe)
import Data.Nullable (toNullable)
import Data.Nullable as Nullable
import Dexie.Collection (Collection)
import Dexie.Internal.Data (Table) as DataRexports
import Dexie.Internal.Data (Table)
import Dexie.Internal.Table (OnCreatingArgs, OnDeletingArgs, OnUpdatingArgs) as TableRexports
import Dexie.Internal.Table as InternalTable
import Dexie.WhereClause (WhereClause)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign, unsafeToForeign)

add :: forall ma item key. MonadAff ma => item -> Maybe key -> Table -> ma Foreign
add item maybeKey table = liftAff $ toAffE $ InternalTable.addImpl foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey


bulkAdd :: forall ma item key. MonadAff ma => Array item -> Maybe (Array key) -> Table -> ma (Array Foreign)
bulkAdd items maybeKeys table = liftAff $ toAffE $ InternalTable.bulkAddImpl foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map unsafeToForeign) maybeKeys

bulkDelete :: forall ma key. MonadAff ma => Array key -> Table -> ma Unit
bulkDelete keys table = liftAff $ toAffE $ InternalTable.bulkDeleteImpl (map unsafeToForeign keys) table

bulkGet :: forall ma key. MonadAff ma => Array key -> Table -> ma (Array (Maybe Foreign))
bulkGet keys table = liftAff $ map (map Nullable.toMaybe) $ toAffE $ InternalTable.bulkGetImpl foreignKeys table
  where
    foreignKeys = map unsafeToForeign keys

bulkPut :: forall ma. MonadAff ma => Array Foreign -> Maybe (Array Foreign) -> Table -> ma (Array Foreign)
bulkPut items maybeKeys table = liftAff $ toAffE $ InternalTable.bulkPutImpl foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map unsafeToForeign) maybeKeys

clear :: forall ma. MonadAff ma => Table -> ma Unit
clear table = liftAff $ toAffE $ InternalTable.clearImpl table

count :: forall ma. MonadAff ma => Table -> ma Int
count table = liftAff $ toAffE $ InternalTable.countImpl table

delete :: forall ma key. MonadAff ma => key -> Table -> ma Unit
delete key table = liftAff $ toAffE $ InternalTable.deleteImpl (unsafeToForeign key) table

each :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Table -> ma Unit
each onEach table = liftAff $ toAffE $ InternalTable.eachImpl onEach table

filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Table -> me Collection
filter filterFn table = liftEffect $ InternalTable.filterImpl filterFn table

get :: forall ma key. MonadAff ma => key -> Table -> ma (Maybe Foreign)
get key table = liftAff $ map Nullable.toMaybe $ toAffE $ InternalTable.getImpl (unsafeToForeign key) table

onCreating :: forall me key. MonadEffect me => (InternalTable.OnCreatingArgs -> Effect (Maybe key)) -> Table -> me (Effect Unit)
onCreating callback table = liftEffect $ InternalTable.onCreatingImpl nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

onDeleting :: forall me. MonadEffect me => (InternalTable.OnDeletingArgs -> Effect Unit) -> Table -> me (Effect Unit)
onDeleting callback table = liftEffect $ InternalTable.onDeletingImpl callback table

onReading :: forall me item. MonadEffect me => (Foreign -> Effect item) -> Table -> me (Effect Unit)
onReading callback table = liftEffect $ InternalTable.onReadingImpl foreignCallback table
  where
    foreignCallback args = map unsafeToForeign $ callback args

onUpdating :: forall me item. MonadEffect me => (InternalTable.OnUpdatingArgs -> Effect (Maybe item)) -> Table -> me (Effect Unit)
onUpdating callback table = liftEffect $ InternalTable.onUpdatingImpl nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

limit :: forall me. MonadEffect me => Int -> Table -> me Collection
limit n table = liftEffect $ InternalTable.limitImpl n table

name :: forall me. MonadEffect me => Table -> me String
name table = liftEffect $ InternalTable.nameImpl table

offset :: forall me. MonadEffect me => Int -> Table -> me Collection
offset n table = liftEffect $ InternalTable.offsetImpl n table

orderBy :: forall me. MonadEffect me => String -> Table -> me Collection
orderBy index table = liftEffect $ InternalTable.orderByImpl index table

put :: forall ma item key. MonadAff ma => item -> Maybe key -> Table -> ma Foreign
put item maybeKey table = liftAff $ toAffE $ InternalTable.putImpl foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey

reverse :: forall me. MonadEffect me => Table -> me Collection
reverse table = liftEffect $ InternalTable.reverseImpl table

toArray :: forall ma. MonadAff ma => Table -> ma (Array Foreign)
toArray table = liftAff $ toAffE $ InternalTable.toArrayImpl table

toCollection :: forall me. MonadEffect me => Table -> me Collection
toCollection table = liftEffect $ InternalTable.toCollectionImpl table

update :: forall ma key changes. MonadAff ma => key -> changes -> Table -> ma Int
update key changes table = liftAff $ toAffE $ InternalTable.updateImpl (unsafeToForeign key) (unsafeToForeign changes) table

whereClause :: forall me key. MonadEffect me => key -> me WhereClause
whereClause key = liftEffect $ InternalTable.whereClauseImpl (unsafeToForeign key)

whereValues :: forall me values. MonadEffect me => values -> me Collection
whereValues values = liftEffect $ InternalTable.whereValuesImpl (unsafeToForeign values)

-- Helpers

add_ :: forall ma a b. MonadAff ma => a -> Maybe b -> Table -> ma Unit
add_ item maybeKey table = add item maybeKey table # void
