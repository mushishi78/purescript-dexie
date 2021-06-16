module Test.Dexie.Collection where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as String
import Dexie.Collection (ModifyEffect(..))
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.Promise (toAff)
import Dexie.Table as Table
import Dexie.Version as Version
import Dexie.WhereClause as WhereClause
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Foreign (unsafeFromForeign, unsafeToForeign)
import Foreign.Object as Object
import Test.Helpers (assertEqual, withCleanDB)
import Test.Unit (TestSuite, suite, test)

collectionTests :: TestSuite
collectionTests = suite "collection" do
  let
    addFirstCharToRef ref str = do
      let char = String.take 1 str
      Ref.modify_ (_ <> char) ref

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
    Table.toCollection foo >>= Collection.each (unsafeFromForeign >>> addFirstCharToRef ref)

    -- Check it equals what we'd expect
    assertEqual "JHJCE" =<< liftEffect (Ref.read ref)

  test "can Collection.eachKey" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add some empty rows with keys
    Table.add_ {} (Just "Jason") foo
    Table.add_ {} (Just "Aticus") foo
    Table.add_ {} (Just "Helena") foo

    -- Iterate over rows and add first character to ref
    Table.toCollection foo >>= Collection.eachKey (unsafeFromForeign >>> addFirstCharToRef ref)

    -- Check it equals what we'd expect
    assertEqual "AHJ" =<< liftEffect (Ref.read ref)

  test "can Collection.eachPrimaryKey" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" ",age")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add some empty rows with keys
    Table.add_ { age: 28 } (Just "Jason") foo
    Table.add_ { age: 32 } (Just "Aticus") foo
    Table.add_ { age: 17 } (Just "Helena") foo

    -- Iterate over rows and add first character to ref
    Table.orderBy "age" foo >>= Collection.eachPrimaryKey (unsafeFromForeign >>> addFirstCharToRef ref)

    -- Check it equals what we'd expect
    assertEqual "HJA" =<< liftEffect (Ref.read ref)

  test "can Collection.eachUniqueKey" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++, firstName")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add some empty rows with keys
    Table.add_ { firstName: "Jason", lastName: "Herron" } Nothing foo
    Table.add_ { firstName: "Aticus", lastName: "Street" } Nothing foo
    Table.add_ { firstName: "Helena", lastName: "Barrow" } Nothing foo
    Table.add_ { firstName: "Jason", lastName: "Stathem" } Nothing foo
    Table.add_ { firstName: "Helena", lastName: "Troy" } Nothing foo

    -- Iterate over rows and add first character to ref
    Table.orderBy "firstName" foo >>= Collection.eachUniqueKey (unsafeFromForeign >>> addFirstCharToRef ref)

    -- Check it equals what we'd expect
    assertEqual "AHJ" =<< liftEffect (Ref.read ref)

  test "can Collection.filter" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Use Collection.filter
    result <- Table.toCollection foo
        >>= Collection.filter (unsafeFromForeign >>> String.length >>> (_ > 5))
        >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Aticus", "Helena"] $ map unsafeFromForeign result

  test "can Collection.first" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Use Collection.first
    result <- Table.toCollection foo >>= Collection.first

    -- Check it equals what we'd expect
    assertEqual "Jason" $ unsafeFromForeign result

  test "can Collection.keys" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++, firstName, lastName")
    foo <- DB.table "foo" db

    -- Add some empty rows with keys
    Table.add_ { firstName: "Jason", lastName: "Herron" } Nothing foo
    Table.add_ { firstName: "Aticus", lastName: "Street" } Nothing foo
    Table.add_ { firstName: "Helena", lastName: "Barrow" } Nothing foo
    Table.add_ { firstName: "Jason", lastName: "Stathem" } Nothing foo
    Table.add_ { firstName: "Helena", lastName: "Troy" } Nothing foo

    -- Get the keys
    result <- Table.orderBy "lastName" foo >>= Collection.keys

    -- Check it equals what we'd expect
    assertEqual [ "Barrow", "Herron", "Stathem", "Street", "Troy"] $ map unsafeFromForeign result

  test "can Collection.last" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Use Collection.last
    result <- Table.toCollection foo >>= Collection.last

    -- Check it equals what we'd expect
    assertEqual "Helena" $ unsafeFromForeign result

  test "can Collection.limit" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd ["Jason", "Aticus", "Helena"] Nothing foo

    -- Use Collection.limit
    result <- Table.toCollection foo >>= Collection.limit 2 >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Jason", "Aticus"] $ map unsafeFromForeign result

  test "can Collection.modify with record" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++id")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd [{}, {}] Nothing foo

    -- Use Collection.modify to add boolean flag
    _ <- Table.toCollection foo >>= Collection.modify (unsafeToForeign { old: true })

    -- Check it equals what we'd expect
    assertEqual [{ id: 1, old: true }, { id: 2, old: true }] =<< map (map unsafeFromForeign) (Table.toArray foo)

  test "can Collection.modifyFn" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++id")
    foo <- DB.table "foo" db

    _ <- Table.bulkAdd [{ old: false }, { old: false }, { old: false }] Nothing foo

    -- Use Collection.modifyFn
    _ <- Table.toCollection foo >>= Collection.modifyFn (unsafeFromForeign >>> \item ->
        case item.id of
          1 -> ModifyDelete
          2 -> ModifyReplace $ item { old = true }
          _ -> ModifyIgnore
      )

    -- Check it equals what we'd expect
    assertEqual [{ id: 2, old: true }, { id: 3, old: false }] =<< map (map unsafeFromForeign) (Table.toArray foo)