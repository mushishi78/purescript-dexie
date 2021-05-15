module Dexie where

import Prelude

import Control.Promise (Promise, toAffE)
import Dexie.DB (DB)
import Effect (Effect)
import Effect.Aff (Aff)

foreign import new :: String -> Effect DB
foreign import deleteImpl :: String -> Effect (Promise Unit)
foreign import getDatabaseNamesImpl :: Effect (Promise (Array String))
foreign import existsImpl :: String -> Effect (Promise Boolean)
foreign import getDebug :: Effect (Boolean)
foreign import setDebug :: Boolean -> Effect Unit

delete :: String -> Aff Unit
delete dbName = toAffE $ deleteImpl dbName

getDatabaseNames :: Aff (Array String)
getDatabaseNames = toAffE getDatabaseNamesImpl

exists :: String -> Aff Boolean
exists dbName = toAffE $ existsImpl dbName
