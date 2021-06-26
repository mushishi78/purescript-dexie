module Dexie.WhereClause (
    above,
    aboveOrEqual,
    anyOf,
    anyOfIgnoreCase,
    below,
    belowOrEqual,
    between,
    equals,
    equalsIgnoreCase,
    inAnyRange,
    noneOf,
    notEqual,
    startsWith,
    startsWithAnyOf,
    startsWithIgnoreCase,
    startsWithAnyOfIgnoreCase
) where

import Prelude

import Data.Tuple (Tuple(..))
import Dexie.IndexedValue (class IndexedValue)
import Dexie.IndexedValue as IndexedValue
import Dexie.Data (Collection, WhereClause)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Foreign (Foreign)

foreign import _above :: Foreign -> WhereClause -> Effect Collection
foreign import _aboveOrEqual :: Foreign -> WhereClause -> Effect Collection
foreign import _anyOf :: Array Foreign -> WhereClause -> Effect Collection
foreign import _anyOfIgnoreCase :: Array String -> WhereClause -> Effect Collection
foreign import _below :: Foreign -> WhereClause -> Effect Collection
foreign import _belowOrEqual :: Foreign -> WhereClause -> Effect Collection
foreign import _between :: Foreign -> Foreign -> Boolean -> Boolean -> WhereClause -> Effect Collection
foreign import _equals :: Foreign -> WhereClause -> Effect Collection
foreign import _equalsIgnoreCase :: String -> WhereClause -> Effect Collection
foreign import _inAnyRange :: Array (Array Foreign) -> Boolean -> Boolean -> WhereClause -> Effect Collection
foreign import _noneOf :: Array Foreign -> WhereClause -> Effect Collection
foreign import _notEqual :: Foreign -> WhereClause -> Effect Collection
foreign import _startsWith :: String -> WhereClause -> Effect Collection
foreign import _startsWithAnyOf :: Array String -> WhereClause -> Effect Collection
foreign import _startsWithIgnoreCase :: String -> WhereClause -> Effect Collection
foreign import _startsWithAnyOfIgnoreCase :: Array String -> WhereClause -> Effect Collection

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.above()](https://dexie.org/docs/WhereClause/WhereClause.above())
above :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
above lowerBound whereClause = liftEffect $ _above (IndexedValue.toForeign lowerBound) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.aboveOrEqual()](https://dexie.org/docs/WhereClause/WhereClause.aboveOrEqual())
aboveOrEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
aboveOrEqual lowerBound whereClause = liftEffect $ _aboveOrEqual (IndexedValue.toForeign lowerBound) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.anyOf()](https://dexie.org/docs/WhereClause/WhereClause.anyOf())
anyOf :: forall v me. MonadEffect me => IndexedValue v => Array v -> WhereClause -> me Collection
anyOf values whereClause = liftEffect $ _anyOf (map IndexedValue.toForeign values) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.anyOfIgnoreCase()](https://dexie.org/docs/WhereClause/WhereClause.anyOfIgnoreCase())
anyOfIgnoreCase :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
anyOfIgnoreCase stringValues whereClause = liftEffect $ _anyOfIgnoreCase stringValues whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.below()](https://dexie.org/docs/WhereClause/WhereClause.below())
below :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
below upperBound whereClause = liftEffect $ _below (IndexedValue.toForeign upperBound) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.belowOrEqual()](https://dexie.org/docs/WhereClause/WhereClause.belowOrEqual())
belowOrEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
belowOrEqual upperBound whereClause = liftEffect $ _belowOrEqual (IndexedValue.toForeign upperBound) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.between()](https://dexie.org/docs/WhereClause/WhereClause.between())
between :: forall v me. MonadEffect me => IndexedValue v => v -> v -> Boolean -> Boolean -> WhereClause -> me Collection
between lowerBound upperBound includeLower includeUpper whereClause =
    liftEffect $ _between (IndexedValue.toForeign lowerBound) (IndexedValue.toForeign upperBound) includeLower includeUpper whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.equals()](https://dexie.org/docs/WhereClause/WhereClause.equals())
equals :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
equals value whereClause = liftEffect $ _equals (IndexedValue.toForeign value) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.equalsIgnoreCase()](https://dexie.org/docs/WhereClause/WhereClause.equalsIgnoreCase())
equalsIgnoreCase :: forall me. MonadEffect me => String -> WhereClause -> me Collection
equalsIgnoreCase value whereClause = liftEffect $ _equalsIgnoreCase value whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.inAnyRange()](https://dexie.org/docs/WhereClause/WhereClause.inAnyRange())
inAnyRange :: forall v me. MonadEffect me => IndexedValue v => Array (Tuple v v) -> Boolean -> Boolean -> WhereClause -> me Collection
inAnyRange ranges includeLowers includeUppers whereClause =
    liftEffect $ _inAnyRange (map fn ranges) includeLowers includeUppers whereClause
  where
    fn (Tuple f s) = map IndexedValue.toForeign [f, s]

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.noneOf()](https://dexie.org/docs/WhereClause/WhereClause.noneOf())
noneOf :: forall v me. MonadEffect me => IndexedValue v => Array v -> WhereClause -> me Collection
noneOf values whereClause = liftEffect $ _noneOf (map IndexedValue.toForeign values) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.notEqual()](https://dexie.org/docs/WhereClause/WhereClause.notEqual())
notEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
notEqual value whereClause = liftEffect $ _notEqual (IndexedValue.toForeign value) whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.startsWith()](https://dexie.org/docs/WhereClause/WhereClause.startsWith())
startsWith :: forall me. MonadEffect me => String -> WhereClause -> me Collection
startsWith prefix whereClause = liftEffect $ _startsWith prefix whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.startsWithAnyOf()](https://dexie.org/docs/WhereClause/WhereClause.startsWithAnyOf())
startsWithAnyOf :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
startsWithAnyOf prefixes whereClause = liftEffect $ _startsWithAnyOf prefixes whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.startsWithIgnoreCase()](https://dexie.org/docs/WhereClause/WhereClause.startsWithIgnoreCase())
startsWithIgnoreCase :: forall me. MonadEffect me => String -> WhereClause -> me Collection
startsWithIgnoreCase prefix whereClause = liftEffect $ _startsWithIgnoreCase prefix whereClause

-- | Documentation: [dexie.org/docs/WhereClause/WhereClause.startsWithAnyOfIgnoreCase()](https://dexie.org/docs/WhereClause/WhereClause.startsWithAnyOfIgnoreCase())
startsWithAnyOfIgnoreCase :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
startsWithAnyOfIgnoreCase prefixes whereClause = liftEffect $ _startsWithAnyOfIgnoreCase prefixes whereClause

