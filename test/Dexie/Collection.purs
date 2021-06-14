module Test.Dexie.Collection where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as String
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Dexie.WhereClause as WhereClause
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Foreign (unsafeFromForeign)
import Foreign.Object as Object
import Test.Helpers (assertEqual, withCleanDB)
import Test.Unit (TestSuite, suite, test)

collectionTests :: TestSuite
collectionTests = suite "collection" do

  test "can Collection.and" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Use Collection.and as a filter
    result <- Table.toCollection foo
        >>= Collection.and (unsafeFromForeign >>> String.length >>> (_ > 5))
        >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Aticus", "Helena"] $ map unsafeFromForeign result

  test "can Collection.clone" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Create a collection and a clone
    originalCollection <- Table.reverse foo
    cloneCollection <- Collection.clone originalCollection

    -- Mutate the cloneCollection by using it
    result1 <- Collection.filter (unsafeFromForeign >>> String.length >>> (_ > 5)) cloneCollection
      >>= Collection.toArray

    -- Use the mutated collection
    result2 <- Collection.offset 1 cloneCollection >>= Collection.toArray

    -- Use the original collection
    result3 <- Collection.offset 1 originalCollection >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Helena", "Aticus"] $ map unsafeFromForeign result1
    assertEqual ["Aticus"] $ map unsafeFromForeign result2
    assertEqual ["Aticus", "Jason"] $ map unsafeFromForeign result3

  test "can Collection.count" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    count <- Table.toCollection foo >>= Collection.count

    assertEqual 3 count

  test "can Collection.delete" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    count <- Table.limit 2 foo >>= Collection.delete

    assertEqual 2 count
    assertEqual 1 =<< Table.count foo
    assertEqual ["Helena"] =<< map (map unsafeFromForeign) (Table.toArray foo)

  test "can Collection.distinct" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++id, *emails")
    foo <- DB.table "foo" db

    Table.add_ { name: "Jason", emails: ["jason99@example.com", "jason_experience@example.com"] } Nothing foo
    Table.add_ { name: "Aticus", emails: ["atic8@example.com"] } Nothing foo
    Table.add_ { name: "Helena", emails: ["hell_angel@example.com"] } Nothing foo

    -- Create a collection with duplicates
    collection <- Table.whereClause "emails" foo >>= WhereClause.startsWith "jason"

    -- Get the result with duplicates
    result1 <- Collection.primaryKeys collection

    -- Get the result with only distinct members
    result2 <- Collection.distinct collection >>= Collection.primaryKeys

    -- Check it equals what we'd expect
    assertEqual [1, 1] $ map unsafeFromForeign result1
    assertEqual [1] $ map unsafeFromForeign result2

  test "can Collection.each" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add some rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] Nothing foo

    -- Iterate over rows and add first character to ref
    Table.toCollection foo
      >>= Collection.each (\s -> Ref.modify_ (_ <> (String.take 1 (unsafeFromForeign s))) ref)

    -- Check it equals what we'd expect
    assertEqual "JHJCE" =<< liftEffect (Ref.read ref)

