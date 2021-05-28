module Dexie.Table where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Data.Nullable as Nullable
import Dexie.Collection (Collection)
import Dexie.Transaction (Transaction)
import Dexie.WhereClause (WhereClause)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign, unsafeToForeign)

type OnCreatingArgs =
    { primaryKey :: Nullable Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: (Foreign -> Effect Unit) -> Effect Unit
    , setOnError :: Effect Unit -> Effect Unit
    }

type OnDeletingArgs =
    { primaryKey :: Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: Effect Unit -> Effect Unit
    , setOnError :: Effect Unit -> Effect Unit
    }

type OnUpdatingArgs =
    { primaryKey :: Foreign
    , item :: Foreign
    , transaction :: Transaction
    , setOnSuccess :: Effect Unit -> Effect Unit
    , setOnError :: Effect Unit -> Effect Unit
    }

foreign import data Table :: Type

foreign import addImpl :: Foreign -> Nullable Foreign -> Table -> Effect (Promise Foreign)
foreign import bulkAddImpl :: Array Foreign -> Nullable (Array Foreign) -> Table -> Effect (Promise (Array Foreign))
foreign import bulkDeleteImpl :: Array Foreign -> Table -> Effect (Promise Unit)
foreign import bulkGetImpl :: Array Foreign -> Table -> Effect (Promise (Array (Nullable Foreign)))
foreign import bulkPutImpl :: Array Foreign -> Nullable (Array Foreign) -> Table -> Effect (Promise (Array Foreign))
foreign import clearImpl :: Table -> Effect (Promise Unit)
foreign import countImpl :: Table -> Effect (Promise Int)
foreign import deleteImpl :: Foreign -> Table -> Effect (Promise Unit)
foreign import eachImpl :: (Foreign -> Effect Unit) -> Table -> Effect (Promise Unit)
foreign import filterImpl :: (Foreign -> Boolean) -> Table -> Effect Collection
foreign import getImpl :: Foreign -> Table -> Effect (Promise (Nullable Foreign))
foreign import onCreatingImpl :: (OnCreatingArgs -> Effect (Nullable Foreign)) -> Table -> Effect (Effect Unit)
foreign import onDeletingImpl :: (OnDeletingArgs -> Effect Unit) -> Table -> Effect (Effect Unit)
foreign import onReadingImpl :: (Foreign -> Effect Foreign) -> Table -> Effect (Effect Unit)
foreign import onUpdatingImpl :: (OnUpdatingArgs -> Effect (Nullable Foreign)) -> Table -> Effect (Effect Unit)
foreign import limitImpl :: Int -> Table -> Effect Collection
foreign import nameImpl :: Table -> Effect String
foreign import offsetImpl :: Int -> Table -> Effect Collection
foreign import orderByImpl :: String -> Table -> Effect Collection
foreign import putImpl :: Foreign -> Nullable Foreign -> Table -> Effect (Promise Foreign)
foreign import reverseImpl :: Table -> Effect Collection
foreign import toArrayImpl :: Table -> Effect (Promise (Array Foreign))
foreign import toCollectionImpl :: Table -> Effect Collection
foreign import updateImpl :: Foreign -> Foreign -> Table -> Effect (Promise Int)
foreign import whereClauseImpl :: Foreign -> Effect WhereClause
foreign import whereValuesImpl :: Foreign -> Effect Collection


add :: forall ma item key. MonadAff ma => item -> Maybe key -> Table -> ma Foreign
add item maybeKey table = liftAff $ toAffE $ addImpl foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey


bulkAdd :: forall ma item key. MonadAff ma => Array item -> Maybe (Array key) -> Table -> ma (Array Foreign)
bulkAdd items maybeKeys table = liftAff $ toAffE $ bulkAddImpl foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map unsafeToForeign) maybeKeys

bulkDelete :: forall ma key. MonadAff ma => Array key -> Table -> ma Unit
bulkDelete keys table = liftAff $ toAffE $ bulkDeleteImpl (map unsafeToForeign keys) table

bulkGet :: forall ma key. MonadAff ma => Array key -> Table -> ma (Array (Maybe Foreign))
bulkGet keys table = liftAff $ map (map Nullable.toMaybe) $ toAffE $ bulkGetImpl foreignKeys table
  where
    foreignKeys = map unsafeToForeign keys

bulkPut :: forall ma. MonadAff ma => Array Foreign -> Maybe (Array Foreign) -> Table -> ma (Array Foreign)
bulkPut items maybeKeys table = liftAff $ toAffE $ bulkPutImpl foreignItems foreignKeys table
  where
    foreignItems = map unsafeToForeign items
    foreignKeys = toNullable $ map (map unsafeToForeign) maybeKeys

clear :: forall ma. MonadAff ma => Table -> ma Unit
clear table = liftAff $ toAffE $ clearImpl table

count :: forall ma. MonadAff ma => Table -> ma Int
count table = liftAff $ toAffE $ countImpl table

delete :: forall ma key. MonadAff ma => key -> Table -> ma Unit
delete key table = liftAff $ toAffE $ deleteImpl (unsafeToForeign key) table

each :: forall ma. MonadAff ma => (Foreign -> Effect Unit) -> Table -> ma Unit
each onEach table = liftAff $ toAffE $ eachImpl onEach table

filter :: forall me. MonadEffect me => (Foreign -> Boolean) -> Table -> me Collection
filter filterFn table = liftEffect $ filterImpl filterFn table

get :: forall ma key. MonadAff ma => key -> Table -> ma (Maybe Foreign)
get key table = liftAff $ map Nullable.toMaybe $ toAffE $ getImpl (unsafeToForeign key) table

onCreating :: forall me key. MonadEffect me => (OnCreatingArgs -> Effect (Maybe key)) -> Table -> me (Effect Unit)
onCreating callback table = liftEffect $ onCreatingImpl nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

onDeleting :: forall me. MonadEffect me => (OnDeletingArgs -> Effect Unit) -> Table -> me (Effect Unit)
onDeleting callback table = liftEffect $ onDeletingImpl callback table

onReading :: forall me item. MonadEffect me => (Foreign -> Effect item) -> Table -> me (Effect Unit)
onReading callback table = liftEffect $ onReadingImpl foreignCallback table
  where
    foreignCallback args = map unsafeToForeign $ callback args

onUpdating :: forall me item. MonadEffect me => (OnUpdatingArgs -> Effect (Maybe item)) -> Table -> me (Effect Unit)
onUpdating callback table = liftEffect $ onUpdatingImpl nullableForeignCallback table
  where
    nullableForeignCallback args = map toNullable $ map (map unsafeToForeign) $ callback args

limit :: forall me. MonadEffect me => Int -> Table -> me Collection
limit n table = liftEffect $ limitImpl n table

name :: forall me. MonadEffect me => Table -> me String
name table = liftEffect $ nameImpl table

offset :: forall me. MonadEffect me => Int -> Table -> me Collection
offset n table = liftEffect $ offsetImpl n table

orderBy :: forall me. MonadEffect me => String -> Table -> me Collection
orderBy index table = liftEffect $ orderByImpl index table

put :: forall ma item key. MonadAff ma => item -> Maybe key -> Table -> ma Foreign
put item maybeKey table = liftAff $ toAffE $ putImpl foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey

reverse :: forall me. MonadEffect me => Table -> me Collection
reverse table = liftEffect $ reverseImpl table

toArray :: forall ma. MonadAff ma => Table -> ma (Array Foreign)
toArray table = liftAff $ toAffE $ toArrayImpl table

toCollection :: forall me. MonadEffect me => Table -> me Collection
toCollection table = liftEffect $ toCollectionImpl table

update :: forall ma key changes. MonadAff ma => key -> changes -> Table -> ma Int
update key changes table = liftAff $ toAffE $ updateImpl (unsafeToForeign key) (unsafeToForeign changes) table

whereClause :: forall me key. MonadEffect me => key -> me WhereClause
whereClause key = liftEffect $ whereClauseImpl (unsafeToForeign key)

whereValues :: forall me values. MonadEffect me => values -> me Collection
whereValues values = liftEffect $ whereValuesImpl (unsafeToForeign values)
