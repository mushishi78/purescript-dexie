module Test.Dexie.WhereClause where

import Prelude

import Data.Maybe (Maybe(..))
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Dexie.WhereClause as WhereClause
import Foreign (unsafeFromForeign)
import Foreign.Object as Object
import Test.Helpers (assertEqual, withCleanDB)
import Test.Unit (TestSuite, suite, test)

whereClauseTests :: TestSuite
whereClauseTests = suite "whereClause" do
  test "can WhereClause.above" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "name, age")
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } Nothing foo
    Table.add_ { name: "Janus", age: 55 } Nothing foo
    Table.add_ { name: "Charity", age: 16 } Nothing foo
    Table.add_ { name: "Bing", age: 18 } Nothing foo
    Table.add_ { name: "Juliet", age: 15 } Nothing foo

    -- Get the rows above 18
    result <- Table.whereClause "age" foo >>= WhereClause.above 17 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual ["Bing", "John", "Janus"] $ map (unsafeFromForeign >>> getName) result
