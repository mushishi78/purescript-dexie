module Dexie.IndexedValue where

import Prelude

import Data.Tuple (Tuple(..))
import Foreign (Foreign, unsafeToForeign)

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
