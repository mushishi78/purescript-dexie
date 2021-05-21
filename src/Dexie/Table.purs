module Dexie.Table where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign)

foreign import data Table :: Type

foreign import addImpl :: Foreign -> Nullable Foreign -> Table -> Effect (Promise Foreign)

add :: forall ma item key. MonadAff ma => item -> Maybe key -> Table -> ma key
add item maybeKey table = liftAff $ map unsafeFromForeign $ toAffE $ addImpl foreignItem foreignKey table
  where
    foreignItem = unsafeToForeign item
    foreignKey = toNullable $ map unsafeToForeign maybeKey
