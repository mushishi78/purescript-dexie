module Dexie.Internal.Table where

import Prelude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Dexie.Collection (Collection)
import Dexie.Internal.Data (Transaction, Table)
import Dexie.WhereClause (WhereClause)
import Effect (Effect)
import Foreign (Foreign)

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
