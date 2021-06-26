module Dexie.Transaction (module Dexie.Internal.Data, abort, table) where

import Prelude

import Dexie.Internal.Data (Transaction)
import Dexie.Table (Table)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)

foreign import _abort :: Transaction -> Effect Unit
foreign import _table :: String -> Transaction -> Effect Table

-- | Discards all the previous changes and fails all future calls in the transaction
-- |
-- | Documentation: [dexie.org/docs/Transaction/Transaction.abort()](https://dexie.org/docs/Transaction/Transaction.abort())
abort :: forall me. MonadEffect me => Transaction -> me Unit
abort transaction = liftEffect $ _abort transaction

-- | Get a transaction-bound `Table` instance representing one of the object stores.
-- |
-- | Documentation: [dexie.org/docs/Transaction/Transaction.table()](https://dexie.org/docs/Transaction/Transaction.table())
table :: forall me. MonadEffect me => String -> Transaction -> me Table
table storeName transaction = liftEffect $ _table storeName transaction
