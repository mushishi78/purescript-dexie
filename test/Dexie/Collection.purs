module Test.Dexie.Collection where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as String
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
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

    -- Use the and as a filter
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

