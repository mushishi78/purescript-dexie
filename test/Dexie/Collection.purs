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
