module Test.Dexie.WhereClause where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Dexie.WhereClause as WhereClause
import Foreign (unsafeFromForeign)
import Foreign.Object (fromHomogeneous)
import Test.Helpers (assertEqual, withCleanDB)
import Test.Unit (TestSuite, suite, test)

whereClauseTests :: TestSuite
whereClauseTests = suite "whereClause" do
  let
    nothingString :: Maybe String
    nothingString = Nothing

  test "can WhereClause.above" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows above 18
    result <- Table.whereClause "age" foo >>= WhereClause.above 18 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "John", "Janus" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.aboveOrEqual" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows aboveOrEqual 18
    result <- Table.whereClause "age" foo >>= WhereClause.aboveOrEqual 18 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Bing", "John", "Janus" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.anyOf" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Use WhereClause.anyOf
    result <- Table.whereClause "age" foo >>= WhereClause.anyOf [ 15, 16, 17, 18 ] >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Juliet", "Charity", "Bing" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.anyOfIgnoreCase" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Use WhereClause.anyOf
    result <- Table.whereClause "name" foo
      >>= WhereClause.anyOfIgnoreCase [ "john", "jAnUs", "juLIET" ]
      >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Janus", "John", "Juliet" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.below" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows below 18
    result <- Table.whereClause "age" foo >>= WhereClause.below 18 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Juliet", "Charity" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.belowOrEqual" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 55 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows belowOrEqual 18
    result <- Table.whereClause "age" foo >>= WhereClause.belowOrEqual 18 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Juliet", "Charity", "Bing" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.between" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows between 18 and 65 exclusive
    result1 <- Table.whereClause "age" foo
      >>= WhereClause.between 18 65 false false
      >>= Collection.toArray

    -- Get the rows between 18 and 65 including lower
    result2 <- Table.whereClause "age" foo
      >>= WhereClause.between 18 65 true false
      >>= Collection.toArray

    -- Get the rows between 18 and 65 including lower and upper
    result3 <- Table.whereClause "age" foo
      >>= WhereClause.between 18 65 true true
      >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "John" ] $ map (unsafeFromForeign >>> getName) result1
    assertEqual [ "Bing", "John" ] $ map (unsafeFromForeign >>> getName) result2
    assertEqual [ "Bing", "John", "Janus" ] $ map (unsafeFromForeign >>> getName) result3

  test "can WhereClause.equals" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 18 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 18 } nothingString foo

    -- Get the rows equal to 18
    result <- Table.whereClause "age" foo >>= WhereClause.equals 18 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Bing", "Charity", "Juliet" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.equalsIgnoreCase" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows equal ignoring case to jAnuS
    result <- Table.whereClause "name" foo >>= WhereClause.equalsIgnoreCase "jAnuS" >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Janus" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.inAnyRange" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    let
      ranges =
        [ Tuple 15 18
        , Tuple 40 65
        ]

    -- Get the rows between ranges exclusive
    result1 <- Table.whereClause "age" foo
      >>= WhereClause.inAnyRange ranges false false
      >>= Collection.toArray

    -- Get the rows between ranges including lower
    result2 <- Table.whereClause "age" foo
      >>= WhereClause.inAnyRange ranges true false
      >>= Collection.toArray

    -- Get the rows between ranges including lower and upper
    result3 <- Table.whereClause "age" foo
      >>= WhereClause.inAnyRange ranges true true
      >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Charity" ] $ map (unsafeFromForeign >>> getName) result1
    assertEqual [ "Juliet", "Charity" ] $ map (unsafeFromForeign >>> getName) result2
    assertEqual [ "Juliet", "Charity", "Bing", "Janus" ] $ map (unsafeFromForeign >>> getName) result3

  test "can WhereClause.noneOf" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows age is not any of 15 25 35 45 55 65
    result <- Table.whereClause "age" foo >>= WhereClause.noneOf [ 15, 25, 35, 45, 55, 65 ] >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Charity", "Bing", "John" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.notEqual" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows age is not equal to 15
    result <- Table.whereClause "age" foo >>= WhereClause.notEqual 15 >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Charity", "Bing", "John", "Janus" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.startsWith" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows where name starts with J
    result <- Table.whereClause "name" foo >>= WhereClause.startsWith "J" >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Janus", "John", "Juliet" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.startsWithAnyOf" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows where name starts with B or C
    result <- Table.whereClause "name" foo >>= WhereClause.startsWithAnyOf [ "B", "C" ] >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Bing", "Charity" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.startsWithIgnoreCase" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows where name starts with j
    result <- Table.whereClause "name" foo >>= WhereClause.startsWithIgnoreCase "j" >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Janus", "John", "Juliet" ] $ map (unsafeFromForeign >>> getName) result

  test "can WhereClause.startsWithAnyOfIgnoreCase" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (fromHomogeneous { foo: Just "name, age" })
    foo <- DB.table "foo" db

    -- Add some data
    Table.add_ { name: "John", age: 23 } nothingString foo
    Table.add_ { name: "Janus", age: 65 } nothingString foo
    Table.add_ { name: "Charity", age: 16 } nothingString foo
    Table.add_ { name: "Bing", age: 18 } nothingString foo
    Table.add_ { name: "Juliet", age: 15 } nothingString foo

    -- Get the rows where name starts with b or c
    result <- Table.whereClause "name" foo >>= WhereClause.startsWithAnyOfIgnoreCase [ "b", "c" ] >>= Collection.toArray

    let getName r = r.name

    -- Check it equals what we'd expect
    assertEqual [ "Bing", "Charity" ] $ map (unsafeFromForeign >>> getName) result