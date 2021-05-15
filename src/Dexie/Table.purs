module Dexie.Table where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign (Foreign)

foreign import data Table :: Type

foreign import addImpl :: Foreign -> Table -> Effect (Promise Foreign)
foreign import addWithKeyImpl :: Foreign -> Foreign -> Table -> Effect (Promise Foreign)

add :: Foreign -> Table -> Aff Foreign
add item table = toAffE $ addImpl item table

addWithKey :: Foreign -> Foreign -> Table -> Aff Foreign
addWithKey item key table = toAffE $ addWithKeyImpl item key table
