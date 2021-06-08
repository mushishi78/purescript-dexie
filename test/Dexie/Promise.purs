module Test.Dexie.Promise where


import Prelude

import Dexie.Promise (_then, reject, resolve, toAff)
import Effect.Exception (error)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

promiseTests :: TestSuite
promiseTests = suite "promise" do
  test "can sequence two promises with _then" $
    resolve 5
      # _then (\n -> if n > 3 then resolve 15 else reject (error "Not big enough"))
      # toAff
      >>= Assert.equal 15

  test "can reject with _then" $
    resolve 2
      # _then (\n -> if n > 3 then resolve 15 else reject (error "Not big enough"))
      # toAff
      # void
      # Assert.expectFailure "should have rejected promise"
