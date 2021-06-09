module Test.Dexie.Promise where


import Prelude

import Dexie.Promise (reject, resolve)
import Dexie.Promise as Promise
import Effect.Class (liftEffect)
import Effect.Exception (error)
import Effect.Ref as Ref
import Test.Helpers (assertEqual, unsafeDelay)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

promiseTests :: TestSuite
promiseTests = suite "promise" do
  let tooSmallError = error "Not big enough"

  test "can sequence two promises with _then" $
    resolve 5
      # Promise._then (\n -> if n > 3 then resolve 15 else reject tooSmallError)
      # Promise.toAff
      >>= Assert.equal 15

  test "can reject with _then" $
    resolve 2
      # Promise._then (\n -> if n > 3 then resolve 15 else reject tooSmallError)
      # Promise.toAff
      # void
      # Assert.expectFailure "should have rejected promise"

  test "does not flatten promises with resolve" $ Promise.toAff do
    promise <- resolve (resolve 5)
    value <- promise
    assertEqual 5 value

  test "can launch concurrent promise" $ Promise.toAff do
    ref <- liftEffect $ Ref.new 0

    -- After 1ms modify ref to be 1
    p <- Promise.launch $ unsafeDelay 1.0 *> (liftEffect (Ref.write 1 ref))

    -- Check that it's still 0
    assertEqual 0 =<< liftEffect (Ref.read ref)

    -- After 1ms, check that it's now 1
    Promise.join p
    assertEqual 1 =<< liftEffect (Ref.read ref)
