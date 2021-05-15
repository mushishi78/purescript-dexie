module Dexie.Version where

import Effect (Effect)
import Foreign.Object (Object)

foreign import data Version :: Type

foreign import stores :: Object String -> Version -> Effect Version
