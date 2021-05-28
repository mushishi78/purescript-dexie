module Dexie.Collection where

import Prelude

import Control.Promise (Promise, toAffE)
import Dexie.WhereClause (WhereClause)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign)

foreign import data Collection :: Type

foreign import andImpl :: (Foreign -> Boolean) -> Collection -> Effect Collection
foreign import cloneImpl :: Collection -> Effect Collection
foreign import countImpl :: Collection -> Effect (Promise Int)
foreign import deleteImpl :: Collection -> Effect (Promise Int)
foreign import distinctImpl :: Collection -> Effect Collection
foreign import eachImpl :: (Foreign -> Effect Unit) -> Collection -> Effect (Promise Unit)
foreign import eachKeyImpl :: (Foreign -> Effect Unit) -> Collection -> Effect (Promise Unit)
foreign import eachPrimaryKeyImpl :: (Foreign -> Effect Unit) -> Collection -> Effect (Promise Unit)
foreign import eachUniqueKeyImpl :: (Foreign -> Effect Unit) -> Collection -> Effect (Promise Unit)
foreign import filterImpl :: (Foreign -> Boolean) -> Collection -> Effect Collection
foreign import firstImpl :: Collection -> Effect (Promise Foreign)
foreign import keysImpl :: Collection -> Effect (Promise (Array Foreign))
foreign import lastImpl :: Collection -> Effect (Promise Foreign)
foreign import limitImpl :: Collection -> Effect Collection
foreign import modifyImpl :: Foreign -> Collection -> Effect Collection
foreign import offsetImpl :: Collection -> Effect Collection
foreign import orImpl :: String -> Collection -> Effect WhereClause
foreign import primaryKeysImpl :: Collection -> Effect (Promise (Array Foreign))
foreign import rawImpl :: Collection -> Effect Collection
foreign import reverseImpl :: Collection -> Effect Collection
foreign import sortByImpl :: String -> Collection -> Effect (Promise (Array Foreign))
foreign import toArrayImpl :: Collection -> Effect (Promise (Array Foreign))
foreign import uniqueKeysImpl :: Collection -> Effect (Promise (Array Foreign))
foreign import untilImpl :: (Foreign -> Boolean) -> Boolean -> Collection -> Effect Collection

and :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
and filterFn collection = liftEffect $ andImpl filterFn collection

clone :: forall me. MonadEffect me => Collection -> me Collection
clone collection = liftEffect $ cloneImpl collection

count :: forall ma. MonadAff ma => Collection -> ma Int
count collection = liftAff $ toAffE $ countImpl collection

delete :: forall ma. MonadAff ma => Collection -> ma Int
delete collection = liftAff $ toAffE $ deleteImpl collection

distinct :: forall me. MonadEffect me => Collection -> me Collection
distinct collection = liftEffect $ distinctImpl collection

each :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Collection -> ma Unit
each onEach collection = liftAff $ toAffE $ eachImpl onEach collection

eachKey :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Collection -> ma Unit
eachKey onEach collection = liftAff $ toAffE $ eachKeyImpl onEach collection

eachPrimaryKey :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Collection -> ma Unit
eachPrimaryKey onEach collection = liftAff $ toAffE $ eachPrimaryKeyImpl onEach collection

eachUniqueKey :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Collection -> ma Unit
eachUniqueKey onEach collection = liftAff $ toAffE $ eachUniqueKeyImpl onEach collection

filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Collection -> me Collection
filter filterFn collection = liftEffect $ filterImpl filterFn collection

first :: forall ma. MonadAff ma => Collection -> ma Foreign
first collection = liftAff $ toAffE $ firstImpl collection

keys :: forall ma. MonadAff ma => Collection -> ma (Array Foreign)
keys collection = liftAff $ toAffE $ keysImpl collection

last :: forall ma. MonadAff ma => Collection -> ma Foreign
last collection = liftAff $ toAffE $ lastImpl collection

limit :: forall me. MonadEffect me => Collection -> me Collection
limit collection = liftEffect $ limitImpl collection

modify :: forall me. MonadEffect me => Foreign -> Collection -> me Collection
modify fnOrObject collection = liftEffect $ modifyImpl fnOrObject collection

offset :: forall me. MonadEffect me => Collection -> me Collection
offset collection = liftEffect $ offsetImpl collection

or :: forall me. MonadEffect me => String -> Collection -> me WhereClause
or index collection = liftEffect $ orImpl index collection

primaryKeys :: forall ma. MonadAff ma => Collection -> ma (Array Foreign)
primaryKeys collection = liftAff $ toAffE $ primaryKeysImpl collection

raw :: forall me. MonadEffect me => Collection -> me Collection
raw collection = liftEffect $ rawImpl collection

reverse :: forall me. MonadEffect me => Collection -> me Collection
reverse collection = liftEffect $ reverseImpl collection

sortBy :: forall ma. MonadAff ma => String -> Collection -> ma (Array Foreign)
sortBy index collection = liftAff $ toAffE $ sortByImpl index collection

toArray :: forall ma. MonadAff ma => Collection -> ma (Array Foreign)
toArray collection = liftAff $ toAffE $ toArrayImpl collection

uniqueKeys :: forall ma. MonadAff ma => Collection -> ma (Array Foreign)
uniqueKeys collection = liftAff $ toAffE $ uniqueKeysImpl collection

until :: forall me. MonadEffect me => (Foreign -> Boolean) -> Boolean -> Collection -> me Collection
until filterFn includeStopEntry collection = liftEffect $ untilImpl filterFn includeStopEntry collection

