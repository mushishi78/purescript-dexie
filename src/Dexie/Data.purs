module Dexie.Data where

-- | Represents a collection of database objects.
-- | Note that it will not contain any objects by itself.
-- | Instead, it yields a preparation for how to execute a DB query.
-- |
-- | Documentation: [dexie.org/docs/Collection/Collection](https://dexie.org/docs/Collection/Collection) \
-- | Methods: [Dexie.Collection](Dexie.Collection#m:Collection)
foreign import data Collection :: Type

-- | An instance represents an indexedDB database connection. \
-- | Methods: [Dexie.DB](Dexie.DB#m:DB)
foreign import data DB :: Type

-- | Represents an IDBObjectStore.
-- |
-- | Documentation: [dexie.org/docs/Table/Table](https://dexie.org/docs/Table/Table) \
-- | Methods: [Dexie.Table](Dexie.Table#m:Table)
foreign import data Table :: Type

-- | Represents a database transaction.
-- |
-- | Documentation: [dexie.org/docs/Transaction/Transaction](https://dexie.org/docs/Transaction/Transaction) \
-- | Methods: [Dexie.Transaction](Dexie.Transaction#m:Transaction)
foreign import data Transaction :: Type

-- | Used to define a migration to be run against a database
-- |
-- | Documentation: [dexie.org/docs/Version/Version](https://dexie.org/docs/Version/Version) \
-- | Methods: [Dexie.Version](Dexie.Version#m:Version)
foreign import data Version :: Type

-- | Represents a filter on an index or primary key.
-- |
-- | Documentation: [dexie.org/docs/WhereClause/WhereClause](https://dexie.org/docs/WhereClause/WhereClause) \
-- | Methods: [Dexie.WhereClause](Dexie.WhereClause#m:WhereClause)
foreign import data WhereClause :: Type
