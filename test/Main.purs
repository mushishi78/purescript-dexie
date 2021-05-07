module Test.Main where

import Prelude

import Data.String as String
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay)
import Effect.Class (liftEffect)
import Node.Process (cwd)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Toppokki as T

main :: Effect Unit
main = do
  dir <- liftEffect cwd
  tests dir

tests :: String -> Effect Unit
tests dir = runTest do
  suite "Dexie" do
    let testUrl = T.URL $ "file://" <> dir <> "/test/test.html"

    test "can load page" do
      browser <- T.launch { headless: false }
      page <- T.newPage browser
      T.goto testUrl page
      content <- T.content page
      Assert.assert "content is non-empty string" (String.length content > 0)
      delay (Milliseconds 10000.0)
      T.close browser
