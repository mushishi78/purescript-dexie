module Dexie.Collection (
    Collection,
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
import Dexie.Internal.Data (WhereClause)
import Dexie.Promise (Promise)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign)

foreign import data Collection :: Type

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

and :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
and filterFn collection = liftEffect $ _and filterFn collection

clone :: forall me. MonadEffect me => Collection -> me Collection
clone collection = liftEffect $ _clone collection

count :: Collection -> Promise Int
count collection = _count collection

delete :: Collection -> Promise Int
delete collection = _delete collection

distinct :: forall me. MonadEffect me => Collection -> me Collection
distinct collection = liftEffect $ _distinct collection

each :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
each onEach collection = _each onEach collection

eachKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachKey onEach collection = _eachKey onEach collection

eachPrimaryKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachPrimaryKey onEach collection = _eachPrimaryKey onEach collection

eachUniqueKey :: (Foreign -> Effect Unit) -> Collection -> Promise Unit
eachUniqueKey onEach collection = _eachUniqueKey onEach collection

filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
filter filterFn collection = liftEffect $ _filter filterFn collection

first :: Collection -> Promise Foreign
first collection = _first collection

keys :: Collection -> Promise (Array Foreign)
keys collection = _keys collection

last :: Collection -> Promise Foreign
last collection = _last collection

limit :: forall me. MonadEffect me => Int -> Collection -> me Collection
limit n collection = liftEffect $ _limit n collection

modify :: forall me. MonadEffect me => Foreign -> Collection -> me Collection
modify fnOrObject collection = liftEffect $ _modify fnOrObject collection

offset :: forall me. MonadEffect me => Int -> Collection -> me Collection
offset n collection = liftEffect $ _offset n collection

or :: forall me. MonadEffect me => String -> Collection -> me WhereClause
or index collection = liftEffect $ _or index collection

primaryKeys :: Collection -> Promise (Array Foreign)
primaryKeys collection = _primaryKeys collection

raw :: forall me. MonadEffect me => Collection -> me Collection
raw collection = liftEffect $ _raw collection

reverse :: forall me. MonadEffect me => Collection -> me Collection
reverse collection = liftEffect $ _reverse collection

sortBy :: String -> Collection -> Promise (Array Foreign)
sortBy index collection = _sortBy index collection

toArray :: Collection -> Promise (Array Foreign)
toArray collection = _toArray collection

uniqueKeys :: Collection -> Promise (Array Foreign)
uniqueKeys collection = _uniqueKeys collection

until :: forall me. MonadEffect me => (Foreign -> Boolean) -> Boolean -> Collection -> me Collection
until filterFn includeStopEntry collection = liftEffect $ _until filterFn includeStopEntry collection

--- Helpers


modifyFn :: forall v me. MonadEffect me => (Foreign -> ModifyEffect v) -> Collection -> me Collection
modifyFn fn collection = modify (createModifyMapper fn) collection

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
