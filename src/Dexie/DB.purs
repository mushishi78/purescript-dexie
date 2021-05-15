module Dexie.DB where

import Dexie.Table (Table)
import Dexie.Version (Version)
import Effect (Effect)

foreign import data DB :: Type

foreign import version :: Int -> DB -> Effect Version
foreign import table :: String -> DB -> Effect Table
