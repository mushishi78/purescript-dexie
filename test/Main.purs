module Test.Main where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "Hello" do
    test "can do test" do
      Assert.assert "five is big" (5 > 0)
