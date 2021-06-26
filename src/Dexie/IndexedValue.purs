module Dexie.IndexedValue where

import Prelude

import Data.Tuple (Tuple(..))
import Foreign (Foreign, unsafeToForeign)

-- | Indexed DB can only index certain types. Specifically:
-- |
-- | * string
-- | * number
-- | * Date
-- | * ArrayBuffer
-- | * Typed arrays (Uint8Array, Float32Array, …, etc)
-- | * Arrays of (strings, numbers, Dates, ArrayBuffer, Typed array) or a mix of those.
-- |
-- | And it cannot index:
-- |
-- | * boolean
-- | * undefined
-- | * Object
-- | * null
-- |
-- | IndexedValue is attempt to represent this, but only covers strings and numbers at the moment.
-- | As a typeclasss it can be extended to handle newtypes and other custom types.
-- |
-- | Documentation: [dexie.org/docs/Indexable-Type](https://dexie.org/docs/Indexable-Type)
class IndexedValue a where
  toForeign :: a -> Foreign

instance indexedValueInt :: IndexedValue Int where
  toForeign = unsafeToForeign

instance indexedValueString :: IndexedValue String where
  toForeign = unsafeToForeign

instance indexedValueNumber :: IndexedValue Number where
  toForeign = unsafeToForeign

instance indexedValueArray :: IndexedValue v => IndexedValue (Array v) where
  toForeign = map toForeign >>> unsafeToForeign

instance indexedValueIntTuple :: IndexedValue v => IndexedValue (Tuple Int v) where
  toForeign (Tuple a b) = unsafeToForeign [toForeign a, toForeign b]

instance indexedValueStringTuple :: IndexedValue v => IndexedValue (Tuple String v) where
  toForeign (Tuple a b) = unsafeToForeign [toForeign a, toForeign b]

instance indexedValueNumberTuple :: IndexedValue v => IndexedValue (Tuple Number v) where
  toForeign (Tuple a b) = unsafeToForeign [toForeign a, toForeign b]
