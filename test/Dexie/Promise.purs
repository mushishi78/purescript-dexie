module Test.Dexie.Promise where


import Prelude

import Dexie.Promise (_then, launchPromise, reject, resolve, toAff)
import Effect.Class (liftEffect)
import Effect.Exception (error)
import Effect.Ref as Ref
import Test.Helpers (assertEqual, delay)
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

  test "does not flatten promises with resolve" $ toAff do
    promise <- resolve (resolve 5)
    value <- promise
    assertEqual 5 value

  test "can launch concurrent promise" $ toAff do
    ref <- liftEffect $ Ref.new 0

    -- After 1ms modify ref to be 1
    launchPromise $ delay 1.0 *> (liftEffect (Ref.write 1 ref))

    -- Check that it's still 0
    assertEqual 0 =<< liftEffect (Ref.read ref)

    -- After 1ms, check that it's now 1
    delay 1.0
    assertEqual 1 =<< liftEffect (Ref.read ref)
