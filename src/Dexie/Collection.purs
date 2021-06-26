module Dexie.Collection (
    and,
    clone,
    count,
    delete,
    distinct,
    each,
    eachKey,
    eachPrimaryKey,
    eachUniqueKey,
    filter,
    first,
    keys,
    last,
    limit,
    modify,
    offset,
    or,
    primaryKeys,
    raw,
    reverse,
    sortBy,
    toArray,
    uniqueKeys,
    until,
    modifyFn,
    ModifyEffect(..)
) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toNullable)
import Dexie.Data (Collection, WhereClause)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign)

foreign import _and :: (Foreign -> Boolean) -> Collection -> Effect Collection
foreign import _clone :: Collection -> Effect Collection
foreign import _count :: Collection -> Promise Int
foreign import _delete :: Collection -> Promise Int
foreign import _distinct :: Collection -> Effect Collection
foreign import _each :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
foreign import _eachKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
foreign import _eachPrimaryKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
foreign import _eachUniqueKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
foreign import _filter :: (Foreign -> Boolean) -> Collection -> Effect Collection
foreign import _first :: Collection -> Promise Foreign
foreign import _keys :: Collection -> Promise (Array Foreign)
foreign import _last :: Collection -> Promise Foreign
foreign import _limit :: Int -> Collection -> Effect Collection
foreign import _modify :: Foreign -> Collection -> Effect Collection
foreign import _offset :: Int -> Collection -> Effect Collection
foreign import _or :: String -> Collection -> Effect WhereClause
foreign import _primaryKeys :: Collection -> Promise (Array Foreign)
foreign import _raw :: Collection -> Effect Collection
foreign import _reverse :: Collection -> Effect Collection
foreign import _sortBy :: String -> Collection -> Promise (Array Foreign)
foreign import _toArray :: Collection -> Promise (Array Foreign)
foreign import _uniqueKeys :: Collection -> Promise (Array Foreign)
foreign import _until :: (Foreign -> Boolean) -> Boolean -> Collection -> Effect Collection

-- | Same as `filter`.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.and()](https://dexie.org/docs/Collection/Collection.and())
and :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
and filterFn collection = liftEffect $ _and filterFn collection

-- | Manipulations on the returned Collection wont affect the original query.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.clone()](https://dexie.org/docs/Collection/Collection.clone())
clone :: forall me. MonadEffect me => Collection -> me Collection
clone collection = liftEffect $ _clone collection

-- | Number of items in the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.count()](https://dexie.org/docs/Collection/Collection.count())
count :: Collection -> Promise Int
count collection = _count collection

-- | Deletes all objects in the query.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.delete()](https://dexie.org/docs/Collection/Collection.delete())
delete :: Collection -> Promise Int
delete collection = _delete collection

-- | Removes any duplicates of primary keys in the collection.
-- | Useful only when working with multi valued indexes.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.distinct()](https://dexie.org/docs/Collection/Collection.distinct())
distinct :: forall me. MonadEffect me => Collection -> me Collection
distinct collection = liftEffect $ _distinct collection

-- | Iterate over all objects in the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.each()](https://dexie.org/docs/Collection/Collection.each())
each :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
each onEach collection = _each onEach collection

-- | Iterate over the keys in the collection on the index used to create the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.eachKey()](https://dexie.org/docs/Collection/Collection.eachKey())
eachKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachKey onEach collection = _eachKey onEach collection

-- | Iterate over all primary keys of the objects in the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.eachPrimaryKey()](https://dexie.org/docs/Collection/Collection.eachPrimaryKey())
eachPrimaryKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachPrimaryKey onEach collection = _eachPrimaryKey onEach collection

-- | Iterate over the unique keys in the collection on the index used to create the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.eachUniqueKey()](https://dexie.org/docs/Collection/Collection.eachUniqueKey())
eachUniqueKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachUniqueKey onEach collection = _eachUniqueKey onEach collection

-- | Documentation: [dexie.org/docs/Collection/Collection.filter()](https://dexie.org/docs/Collection/Collection.filter())
filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
filter filterFn collection = liftEffect $ _filter filterFn collection

-- | First item in the collection if any.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.first()](https://dexie.org/docs/Collection/Collection.first())
first :: Collection -> Promise Foreign
first collection = _first collection

-- | The keys in the collection on the index used to create the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.keys()](https://dexie.org/docs/Collection/Collection.keys())
keys :: Collection -> Promise (Array Foreign)
keys collection = _keys collection

-- | Last item in the collection if any.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.last()](https://dexie.org/docs/Collection/Collection.last())
last :: Collection -> Promise Foreign
last collection = _last collection

-- | Number of items to limit the results with.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.limit()](https://dexie.org/docs/Collection/Collection.limit())
limit :: forall me. MonadEffect me => Int -> Collection -> me Collection
limit n collection = liftEffect $ _limit n collection

-- | Modifies all objects in the collection.
-- | Can use an object to set fields to a constant value.
-- | Can also use the [modifyFn](#v:modifyFn) helper to map over the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.modify()](https://dexie.org/docs/Collection/Collection.modify())
modify :: forall me. MonadEffect me => Foreign -> Collection -> me Collection
modify fnOrObject collection = liftEffect $ _modify fnOrObject collection

-- | Skips the first N entries from the resulting Collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.offset()](https://dexie.org/docs/Collection/Collection.offset())
offset :: forall me. MonadEffect me => Int -> Collection -> me Collection
offset n collection = liftEffect $ _offset n collection

-- | Documentation: [dexie.org/docs/Collection/Collection.or()](https://dexie.org/docs/Collection/Collection.or())
or :: forall me. MonadEffect me => String -> Collection -> me WhereClause
or index collection = liftEffect $ _or index collection

-- | Returns the primary keys for the objects in the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.primaryKeys()](https://dexie.org/docs/Collection/Collection.primaryKeys())
primaryKeys :: Collection -> Promise (Array Foreign)
primaryKeys collection = _primaryKeys collection

-- | Makes the resulting operation ignore any subscriber to [onReading](Dexie.Table.html#v:onReading).
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.raw()](https://dexie.org/docs/Collection/Collection.raw())
raw :: forall me. MonadEffect me => Collection -> me Collection
raw collection = liftEffect $ _raw collection

-- | Reverse the sort order of the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.reverse()](https://dexie.org/docs/Collection/Collection.reverse())
reverse :: forall me. MonadEffect me => Collection -> me Collection
reverse collection = liftEffect $ _reverse collection

-- | Same as [toArray](#v:toArray) but with manual sorting applied to the array.
-- | Similar to [orderBy](Dexie.Table.html#v:orderBy) but does sorting
-- | on the resulting array rather than letting the backend implementation
-- | do the sorting.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.sortBy()](https://dexie.org/docs/Collection/Collection.sortBy())
sortBy :: String -> Collection -> Promise (Array Foreign)
sortBy index collection = _sortBy index collection

-- | Returns array containing the found objects.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.toArray()](https://dexie.org/docs/Collection/Collection.toArray())
toArray :: Collection -> Promise (Array Foreign)
toArray collection = _toArray collection

-- | The unique keys in the collection on the index used to create the collection.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.uniqueKeys()](https://dexie.org/docs/Collection/Collection.uniqueKeys())
uniqueKeys :: Collection -> Promise (Array Foreign)
uniqueKeys collection = _uniqueKeys collection

-- | Stop iterating the collection once given predicate returns true
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.until()](https://dexie.org/docs/Collection/Collection.until())
until :: forall me. MonadEffect me => (Foreign -> Boolean) -> Boolean -> Collection -> me Collection
until filterFn includeStopEntry collection = liftEffect $ _until filterFn includeStopEntry collection

--- Helpers

-- | Helper to use [modify](#v:modify) with a mapping function
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection.modify()](https://dexie.org/docs/Collection/Collection.modify())
modifyFn :: forall v me. MonadEffect me => (Foreign -> ModifyEffect v) -> Collection -> me Collection
modifyFn fn collection = modify (createModifyMapper fn) collection

-- | Return type for [modifyFn](#v:modifyFn) to specify if you'd like to replace, ignore or delete the object
data ModifyEffect a = ModifyReplace a | ModifyIgnore | ModifyDelete

foreign import _createModifyMapper :: forall v.
    (forall a. ModifyEffect a -> Nullable a)
    -> (forall a. ModifyEffect a -> Boolean)
    -> (forall a. ModifyEffect a -> Boolean)
    -> (Foreign -> ModifyEffect v)
    -> Foreign

createModifyMapper :: forall v. (Foreign -> ModifyEffect v) -> Foreign
createModifyMapper fn = _createModifyMapper getModifyReplaceValue isModifyIgnore isModifyDelete fn

getModifyReplaceValue :: forall a. ModifyEffect a -> Nullable a
getModifyReplaceValue = toNullable <<< case _ of
    ModifyReplace value -> Just value
    _ -> Nothing

isModifyIgnore :: forall a. ModifyEffect a -> Boolean
isModifyIgnore = case _ of
    ModifyIgnore -> true
    _ -> false

isModifyDelete :: forall a. ModifyEffect a -> Boolean
isModifyDelete = case _ of
    ModifyDelete -> true
    _ -> false
