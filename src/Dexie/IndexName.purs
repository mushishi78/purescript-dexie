module Dexie.IndexName where

import Data.Tuple (Tuple(..))
import Foreign (Foreign, unsafeToForeign)

-- | IndexName represents either the string key of an index,
-- | or an array of index keys for compound indexes.
-- |
-- | Documentation: [dexie.org/docs/Table/Table.where()](https://dexie.org/docs/Table/Table.where())
class IndexName a where
  toForeign :: a -> Foreign

instance indexNameString :: IndexName String where
  toForeign = unsafeToForeign

instance indexNameArray :: IndexName (Array String) where
  toForeign = unsafeToForeign

instance indexNameTuple :: IndexName (Tuple String String) where
  toForeign (Tuple a b) = unsafeToForeign [ a, b ]
