module Dexie.Transaction (module Dexie.Internal.Data, abort, table, add_) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (toNullable)
import Dexie.Internal.Data (Transaction)
import Dexie.Internal.Table as InternalTable
import Dexie.Table (Table)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (unsafeToForeign)

foreign import abortImpl :: Transaction -> Effect Unit
foreign import tableImpl :: String -> Transaction -> Effect Table

abort :: forall me. MonadEffect me => Transaction -> me Unit
abort transaction = liftEffect $ abortImpl transaction

table :: forall me. MonadEffect me => String -> Transaction -> me Table
table storeName transaction = liftEffect $ tableImpl storeName transaction

add_ :: forall a b me. MonadEffect me => a -> Maybe b -> Table -> me Unit
add_ item maybeKey tbl = void $ liftEffect $ InternalTable.addImpl foreignItem foreignKey tbl
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey
