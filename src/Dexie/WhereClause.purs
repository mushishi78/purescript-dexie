module Dexie.WhereClause (
    module DataRexports,
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
import Dexie.Collection (Collection)
import Dexie.IndexedValue (class IndexedValue)
import Dexie.IndexedValue as IndexedValue
import Dexie.Internal.Data (WhereClause)
import Dexie.Internal.Data (WhereClause) as DataRexports
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

above :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
above lowerBound whereClause = liftEffect $ _above (IndexedValue.toForeign lowerBound) whereClause

aboveOrEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
aboveOrEqual lowerBound whereClause = liftEffect $ _aboveOrEqual (IndexedValue.toForeign lowerBound) whereClause

anyOf :: forall v me. MonadEffect me => IndexedValue v => Array v -> WhereClause -> me Collection
anyOf values whereClause = liftEffect $ _anyOf (map IndexedValue.toForeign values) whereClause

anyOfIgnoreCase :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
anyOfIgnoreCase stringValues whereClause = liftEffect $ _anyOfIgnoreCase stringValues whereClause

below :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
below upperBound whereClause = liftEffect $ _below (IndexedValue.toForeign upperBound) whereClause

belowOrEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
belowOrEqual upperBound whereClause = liftEffect $ _belowOrEqual (IndexedValue.toForeign upperBound) whereClause

between :: forall v me. MonadEffect me => IndexedValue v => v -> v -> Boolean -> Boolean -> WhereClause -> me Collection
between lowerBound upperBound includeLower includeUpper whereClause =
    liftEffect $ _between (IndexedValue.toForeign lowerBound) (IndexedValue.toForeign upperBound) includeLower includeUpper whereClause

equals :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
equals value whereClause = liftEffect $ _equals (IndexedValue.toForeign value) whereClause

equalsIgnoreCase :: forall me. MonadEffect me => String -> WhereClause -> me Collection
equalsIgnoreCase value whereClause = liftEffect $ _equalsIgnoreCase value whereClause

inAnyRange :: forall v me. MonadEffect me => IndexedValue v => Array (Tuple v v) -> Boolean -> Boolean -> WhereClause -> me Collection
inAnyRange ranges includeLowers includeUppers whereClause =
    liftEffect $ _inAnyRange (map fn ranges) includeLowers includeUppers whereClause
  where
    fn (Tuple f s) = map IndexedValue.toForeign [f, s]

noneOf :: forall v me. MonadEffect me => IndexedValue v => Array v -> WhereClause -> me Collection
noneOf values whereClause = liftEffect $ _noneOf (map IndexedValue.toForeign values) whereClause

notEqual :: forall v me. MonadEffect me => IndexedValue v => v -> WhereClause -> me Collection
notEqual value whereClause = liftEffect $ _notEqual (IndexedValue.toForeign value) whereClause

startsWith :: forall me. MonadEffect me => String -> WhereClause -> me Collection
startsWith prefix whereClause = liftEffect $ _startsWith prefix whereClause

startsWithAnyOf :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
startsWithAnyOf prefixes whereClause = liftEffect $ _startsWithAnyOf prefixes whereClause

startsWithIgnoreCase :: forall me. MonadEffect me => String -> WhereClause -> me Collection
startsWithIgnoreCase prefix whereClause = liftEffect $ _startsWithIgnoreCase prefix whereClause

startsWithAnyOfIgnoreCase :: forall me. MonadEffect me => Array String -> WhereClause -> me Collection
startsWithAnyOfIgnoreCase prefixes whereClause = liftEffect $ _startsWithAnyOfIgnoreCase prefixes whereClause

