module Test.Dexie.Table where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String.Utils (startsWith)
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (Promise, toAff)
import Dexie.Table (Table)
import Dexie.Table as Table
import Dexie.Version as Version
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Foreign (unsafeFromForeign)
import Foreign.Object as Object
import Test.Helpers (withCleanDB, assertEqual)
import Test.Unit (TestSuite, suiteOnly, test)

tableTests :: TestSuite
tableTests = suiteOnly "table" do
  let
    unsafeGet :: forall key item. key -> Table -> Promise (Maybe item)
    unsafeGet key table = Table.get key table # map (map unsafeFromForeign)

    unsafeToArray :: forall item. Table -> Promise (Array item)
    unsafeToArray table = Table.toArray table # map (map unsafeFromForeign)

  test "can add with an inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Add one row
    key <- Table.add { id: 1, name: "John" } Nothing foo

    -- Check it equals what we'd expect
    assertEqual 1 (unsafeFromForeign key)
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet key foo

  test "can add with a non-inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db

    -- Add one row
    key <- Table.add { name: "John" } (Just 1) foo

    -- Check it equals what we'd expect
    assertEqual 1 (unsafeFromForeign key)
    assertEqual (Just { name: "John" }) =<< unsafeGet key foo

  test "can add with an auto-incrementing inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++id")
    foo <- DB.table "foo" db

    -- Add one row
    key <- Table.add { name: "John" } Nothing foo

    -- Check it equals what we'd expect
    assertEqual 1 (unsafeFromForeign key)
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet key foo

  test "can add with an auto-incrementing non-inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add one row
    key <- Table.add { name: "John" } Nothing foo

    -- Check it equals what we'd expect
    assertEqual 1 (unsafeFromForeign key)
    assertEqual (Just { name: "John" }) =<< unsafeGet key foo

  test "can bulkAdd" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    keys <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- Check it equals what we'd expect
    assertEqual [1, 2, 3] (map unsafeFromForeign keys)
    assertEqual ["John", "Harry", "Jane"] =<< unsafeToArray foo

  test "can bulkDelete" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- And delete some of them
    Table.bulkDelete [1, 3] foo

    -- Check it equals what we'd expect
    assertEqual ["Harry"] =<< unsafeToArray foo

  test "can bulkGet" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- And read specific ones
    values <- Table.bulkGet [1, 3, 25] foo

    -- Check it equals what we'd expect
    assertEqual [Just "John", Just "Jane", Nothing] $ map (map unsafeFromForeign) values

  test "can bulkPut" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- And put specific ones
    _ <- Table.bulkPut ["Lizzie", "Chelsea", "Eve"] (Just [1, 3, 25]) foo

    -- Check it equals what we'd expect
    assertEqual ["Lizzie", "Harry", "Chelsea", "Eve"] =<< unsafeToArray foo

  test "can clear" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- Check that they're there
    assertEqual 3 =<< Table.count foo

    -- And the delete them all
    Table.clear foo

    -- Check that they've gone
    assertEqual 0 =<< Table.count foo

  test "can delete" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- And delete some of them
    Table.delete 1 foo

    -- Check it equals what we'd expect
    assertEqual ["Harry", "Jane"] =<< unsafeToArray foo

  test "can each" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    -- And iterate over them
    (flip Table.each) foo $ \item -> do
      -- Concatenate the items together in the ref
      liftEffect $ (flip Ref.modify_) ref $ \s -> s <> unsafeFromForeign item

    -- Check it equals what we'd expect
    assertEqual "JohnHarryJane" =<< liftEffect (Ref.read ref)

  test "can filter" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] Nothing foo

    values <- Table.filter (\item -> startsWith "J" (unsafeFromForeign item)) foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["John", "Jane"] $ map unsafeFromForeign values


