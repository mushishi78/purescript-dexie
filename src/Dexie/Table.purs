module Dexie.Table where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Foreign (Foreign)

foreign import data Table :: Type

foreign import addImpl :: Foreign -> Table -> Effect (Promise Foreign)
foreign import addWithKeyImpl :: Foreign -> Foreign -> Table -> Effect (Promise Foreign)

add :: forall m. MonadAff m => Foreign -> Table -> m Foreign
add item table = liftAff $ toAffE $ addImpl item table

addWithKey :: forall m. MonadAff m => Foreign -> Foreign -> Table -> m Foreign
addWithKey item key table = liftAff $ toAffE $ addWithKeyImpl item key table
