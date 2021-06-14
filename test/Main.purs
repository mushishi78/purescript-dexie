module Test.Main where

import Prelude

import Effect (Effect)
import Test.Dexie.Collection (collectionTests)
import Test.Dexie.Promise (promiseTests)
import Test.Dexie.Table (tableTests)
import Test.Dexie.Transaction (transactionTests)
import Test.Dexie.Version (versionTests)
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  collectionTests
  promiseTests
  tableTests
  transactionTests
  versionTests
