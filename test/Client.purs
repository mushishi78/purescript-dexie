module Test.Client where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

migration1 :: Effect Unit
migration1 = do
  log "Hello"