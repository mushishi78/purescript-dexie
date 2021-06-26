module Dexie.Internal.Data where

-- | Represents a database transaction.
-- |
-- | Documentation: [dexie.org/docs/Transaction/Transaction](https://dexie.org/docs/Transaction/Transaction)
foreign import data Transaction :: Type

-- | Represents an IDBObjectStore.
-- |
-- | Documentation: [dexie.org/docs/Table/Table](https://dexie.org/docs/Table/Table)
foreign import data Table :: Type

-- | Represents a filter on an index or primary key.
-- |
-- | Documentation: [dexie.org/docs/WhereClause/WhereClause](https://dexie.org/docs/WhereClause/WhereClause)
foreign import data WhereClause :: Type
