module Test.Dexie.Table where

import Prelude

import Control.Monad.Error.Class (try)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String.Utils (startsWith)
import Dexie.Collection as Collection
import Dexie.DB as DB
import Dexie.IndexedValue (class IndexedValue)
import Dexie.Promise (Promise, toAff)
import Dexie.Data (Table)
import Dexie.Table as Table
import Dexie.Version as Version
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (error, throwException)
import Effect.Exception as Error
import Effect.Ref as Ref
import Foreign (unsafeFromForeign)
import Foreign.Object as Object
import Test.Helpers (assertEqual, withCleanDB)
import Test.Unit (TestSuite, suite, test)

tableTests :: TestSuite
tableTests = suite "table" do
  let
    unsafeGet :: forall key item. IndexedValue key => key -> Table -> Promise (Maybe item)
    unsafeGet key table = Table.get key table # map (map unsafeFromForeign)

    unsafeToArray :: forall item. Table -> Promise (Array item)
    unsafeToArray table = Table.toArray table # map (map unsafeFromForeign)

    nothingInt :: Maybe Int
    nothingInt = Nothing

    nothingIntArray :: Maybe (Array Int)
    nothingIntArray = Nothing

  test "can Table.add with an inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Add one row
    foreignKey <- Table.add { id: 1, name: "John" } nothingInt foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet key foo

  test "can Table.add with a non-inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db

    -- Add one row
    foreignKey <- Table.add { name: "John" } (Just 1) foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { name: "John" }) =<< unsafeGet key foo

  test "can Table.add with an auto-incrementing inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++id")
    foo <- DB.table "foo" db

    -- Add one row
    foreignKey <- Table.add { name: "John" } nothingInt foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet key foo

  test "can Table.add with an auto-incrementing non-inbound key" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add one row
    foreignKey <- Table.add { name: "John" } nothingInt foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { name: "John" }) =<< unsafeGet key foo

  test "can Table.bulkAdd" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    keys <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- Check it equals what we'd expect
    assertEqual [1, 2, 3] (map unsafeFromForeign keys)
    assertEqual ["John", "Harry", "Jane"] =<< unsafeToArray foo

  test "can Table.bulkDelete" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- And delete some of them
    Table.bulkDelete [1, 3] foo

    -- Check it equals what we'd expect
    assertEqual ["Harry"] =<< unsafeToArray foo

  test "can Table.bulkGet" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- And read specific ones
    values <- Table.bulkGet [1, 3, 25] foo

    -- Check it equals what we'd expect
    assertEqual [Just "John", Just "Jane", Nothing] $ map (map unsafeFromForeign) values

  test "can Table.bulkPut" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- And put specific ones
    _ <- Table.bulkPut ["Lizzie", "Chelsea", "Eve"] (Just [1, 3, 25]) foo

    -- Check it equals what we'd expect
    assertEqual ["Lizzie", "Harry", "Chelsea", "Eve"] =<< unsafeToArray foo

  test "can Table.clear" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- Check that they're there
    assertEqual 3 =<< Table.count foo

    -- And the delete them all
    Table.clear foo

    -- Check that they've gone
    assertEqual 0 =<< Table.count foo

  test "can Table.delete" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- And delete some of them
    Table.delete 1 foo

    -- Check it equals what we'd expect
    assertEqual ["Harry", "Jane"] =<< unsafeToArray foo

  test "can Table.each" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- And iterate over them
    (flip Table.each) foo $ \item -> do
      -- Concatenate the items together in the ref
      liftEffect $ (flip Ref.modify_) ref $ \s -> s <> unsafeFromForeign item

    -- Check it equals what we'd expect
    assertEqual "JohnHarryJane" =<< liftEffect (Ref.read ref)

  test "can Table.filter" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane"] nothingIntArray foo

    -- Filter the table with a predicate
    values <- Table.filter (\item -> startsWith "J" (unsafeFromForeign item)) foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["John", "Jane"] $ map unsafeFromForeign values

  test "can set onCreating callback" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new false

    -- Make the callback set the ref to true
    void $ (flip Table.onCreating) foo $ \_ -> do
      Ref.write true ref
      pure nothingInt

    -- Check that the ref is currently false
    assertEqual false =<< liftEffect (Ref.read ref)

    -- Add to the table, causing the callback to be called
    Table.add_ "John" nothingInt foo

    -- Check that the ref is now true
    assertEqual true =<< liftEffect (Ref.read ref)

  test "can make primary key with onCreating" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db

    -- Make the callback return a primary key for the row
    void $ (flip Table.onCreating) foo $ \_ -> do
      pure (Just "key")

    -- Add to the table, causing the callback to be called
    Table.add_ "John" nothingInt foo

    -- Check that the row has the new key
    assertEqual (Just "John") =<< unsafeGet "key" foo

  test "can get the primary key with onCreating's onSuccess" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new 28

    -- Make the callback set the onSuccess
    void $ (flip Table.onCreating) foo $ \args -> do

      -- Make the onSuccess set the ref
      args.setOnSuccess $ \primaryKey -> do
        Ref.write (unsafeFromForeign primaryKey) ref

      pure nothingInt

    -- Check that the ref is currently 28
    assertEqual 28 =<< liftEffect (Ref.read ref)

    -- Add to the table, causing the callback to be called
    Table.add_ "John" nothingInt foo

    -- Check that the ref is now 1
    assertEqual 1 =<< liftEffect (Ref.read ref)

  test "can set onCreating's onError" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new (error "Noop")

    -- Make the callback set the onError
    void $ (flip Table.onCreating) foo $ \args -> do

      -- Make the onError set the ref
      args.setOnError $ \err -> do
        Ref.write err ref

      pure nothingInt

    -- Check that the ref is currently original error
    assertEqual "Noop" =<< map Error.message (liftEffect (Ref.read ref))

    -- Try to add to the same row twice causing an error
    Table.add_ "John" (Just 1) foo
    void $ try $ Table.add_ "Mike" (Just 1) foo

    -- Check that the ref is new error
    assertEqual "Key already exists in the object store." =<< map Error.message (liftEffect (Ref.read ref))

  test "can fail an add by throwing in onCreating" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Make the callback throw an error
    void $ (flip Table.onCreating) foo $ \_ -> do
      throwException (error "dont like this") :: Effect (Maybe Int)

    -- Try to add to a row
    maybeError <- try $ Table.add_ "John" nothingInt foo

    -- Check that the result of the add is an error
    assertEqual (Left "dont like this") $ lmap Error.message maybeError

  test "can unsubscribe from onCreating" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new 0

    -- Make the callback increment the ref
    unsubscribe <- (flip Table.onCreating) foo $ \_ -> do
      liftEffect $ Ref.modify_ (_ + 1) ref
      pure nothingInt

    -- Increment the counter a few times
    Table.add_ "John" nothingInt foo
    Table.add_ "Sara" nothingInt foo
    Table.add_ "Pauline" nothingInt foo

    -- Unsubscribe the callback
    liftEffect $ unsubscribe

    -- Add a few times to show it's no longer counting
    Table.add_ "Harriet" nothingInt foo
    Table.add_ "Jessica" nothingInt foo
    Table.add_ "Eve" nothingInt foo

    -- Check that the counter is what we expect
    assertEqual 3 =<< liftEffect (Ref.read ref)

  test "can set onDeleting callback" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new false

    -- Make the callback set the ref to true
    void $ (flip Table.onDeleting) foo $ \_ -> do
      Ref.write true ref

    -- Add a row to the table
    Table.add_ "John" nothingInt foo

    -- Check that the ref is currently false
    assertEqual false =<< liftEffect (Ref.read ref)

    -- Now delete the row causing the callback to be called
    Table.delete 1 foo

    -- Check that the ref is now true
    assertEqual true =<< liftEffect (Ref.read ref)

  test "can fail a delete by throwing in onDeleting" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Make the callback throw an error
    void $ (flip Table.onDeleting) foo $ \_ -> do
      throwException (error "dont like this")

    -- Try to add to a row
    Table.add_ "John" nothingInt foo
    maybeError <- try $ Table.delete  1 foo

    -- Check that the result of the add is an error
    assertEqual (Left "dont like this") $ lmap Error.message maybeError

  test "can get value from onReading" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new ""

    -- Make the callback set the ref to the row value
    void $ (flip Table.onReading) foo $ \value -> do
      Ref.write (unsafeFromForeign value) ref
      pure value

    -- Add a row to the table
    Table.add_ "John" nothingInt foo

    -- Check that the ref is currently empty
    assertEqual "" =<< liftEffect (Ref.read ref)

    -- Call get to trigger the callback
    _ <- Table.get 1 foo

    -- Check that the ref is now "John"
    assertEqual "John" =<< liftEffect (Ref.read ref)

  test "can modify value with onReading" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Make the callback set the ref to the row value
    void $ (flip Table.onReading) foo $ \value -> do
      pure ("Sir " <> unsafeFromForeign value)

    -- Add a row to the table
    Table.add_ "John" nothingInt foo

    -- Check that get now prefixes the value
    assertEqual (Just "Sir John") =<< unsafeGet 1 foo

  test "can set onUpdating callback" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new false

    -- Make the callback set the ref to true
    void $ (flip Table.onUpdating) foo $ \_ -> do
      Ref.write true ref
      pure Nothing

    -- Add a row to the table
    Table.add_ "John" nothingInt foo

    -- Check that the ref is currently false
    assertEqual false =<< liftEffect (Ref.read ref)

    -- Update the row, causing the callback to be called
    Table.put_ "Harry" (Just 1) foo

    -- Check that the ref is now true
    assertEqual true =<< liftEffect (Ref.read ref)

  test "can modify the modifications with onUpdating" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Make the callback modify ther modifications
    void $ (flip Table.onUpdating) foo $ \args -> do
      let { name } = unsafeFromForeign args.modifications
      pure $ Just $ { name, title: "Prince" }

    -- Add a row to the table
    Table.add_ { name: "John" } nothingInt foo

    -- Update the row, causing the callback to be called
    Table.update_ 1 { name: "Harry" } foo

    -- Check that the row has the modified value
    assertEqual (Just { name: "Harry", title: "Prince" }) =<< unsafeGet 1 foo

  test "can get the updated item with onUpdating's onSuccess" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db
    ref <- liftEffect $ Ref.new { name: "", title: "" }

    -- Make the callback set the onSuccess
    void $ (flip Table.onUpdating) foo $ \args -> do

      -- Make the onSuccess set the ref
      args.setOnSuccess $ \updatedItem -> do
        Ref.write (unsafeFromForeign updatedItem) ref

      pure Nothing

    -- Add a row to the table
    Table.add_ { name: "John" } nothingInt foo

    -- Check that the ref is currently empty
    assertEqual { name: "", title: "" } =<< liftEffect (Ref.read ref)

    -- Update the row, causing the callback to be called
    Table.update_ 1 { title: "Sir" } foo

    -- Check that the ref is now updated
    assertEqual { name: "John", title: "Sir" } =<< liftEffect (Ref.read ref)

  test "can Table.limit" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] nothingIntArray foo

    -- Can read a limited number of rows
    result <- Table.limit 3 foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["John", "Harry", "Jane"] $ map unsafeFromForeign result

  test "can Table.name" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Check it equals what we'd expect
    assertEqual "foo" =<< Table.name foo

  test "can Table.offset" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] nothingIntArray foo

    -- Can skip a number of rows
    result <- Table.offset 2 foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Jane", "Chelsea", "Emily"] $ map unsafeFromForeign result

  test "can Table.orderBy" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++, name")
    foo <- DB.table "foo" db

    -- Add multiple rows
    Table.add_ { name: "John" } nothingInt foo
    Table.add_ { name: "Harry" } nothingInt foo
    Table.add_ { name: "Jane" } nothingInt foo
    Table.add_ { name: "Chelsea" } nothingInt foo

    -- Read in the order of their name
    result <- Table.orderBy "name" foo >>= Collection.toArray

    let getName record = record.name

    -- Check it equals what we'd expect
    assertEqual ["Chelsea", "Harry", "Jane", "John"] $ map (unsafeFromForeign >>> getName) result

  test "can Table.put to a new row" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Put one row
    foreignKey <- Table.put { id: 1, name: "John" } nothingInt foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { id: 1, name: "John" }) =<< unsafeGet key foo

  test "can Table.put over an existing row" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Add one row
    Table.add_ { id: 1, name: "John" } nothingInt foo

    -- Put the same row
    foreignKey <- Table.put { id: 1, name: "Sally" } nothingInt foo
    let key = unsafeFromForeign foreignKey :: Int

    -- Check it equals what we'd expect
    assertEqual 1 key
    assertEqual (Just { id: 1, name: "Sally" }) =<< unsafeGet key foo
    assertEqual 1 =<< Table.count foo

  test "can Table.reverse" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] nothingIntArray foo

    -- Can read in reverse order
    result <- Table.reverse foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["Emily", "Chelsea", "Jane", "Harry", "John"] $ map unsafeFromForeign result

  test "can Table.toArray" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] nothingIntArray foo

    -- Can read in all the rows
    result <- Table.toArray foo

    -- Check it equals what we'd expect
    assertEqual ["John", "Harry", "Jane", "Chelsea", "Emily"] $ map unsafeFromForeign result

  test "can Table.toCollection" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++")
    foo <- DB.table "foo" db

    -- Add multiple rows
    _ <- Table.bulkAdd ["John", "Harry", "Jane", "Chelsea", "Emily"] nothingIntArray foo

    -- Can convert to a collection
    result <- Table.toCollection foo >>= Collection.toArray

    -- Check it equals what we'd expect
    assertEqual ["John", "Harry", "Jane", "Chelsea", "Emily"] $ map unsafeFromForeign result

  test "can Table.update an existing row" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Add one row
    Table.add_ { id: 10, name: "John" } nothingInt foo

    -- Can update
    count <- Table.update 10 { name: "Sally" } foo

    -- Check it equals what we'd expect
    assertEqual 1 count
    assertEqual (Just { id: 10, name: "Sally" }) =<< unsafeGet 10 foo

  test "Table.update returns 0 if not successful" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "id")
    foo <- DB.table "foo" db

    -- Put one row
    count <- Table.update 10 { name: "Sally" } foo

    -- Check it equals what we'd expect
    assertEqual 0 count
    assertEqual (Nothing :: Maybe { id :: Int, name :: String }) =<< unsafeGet 10 foo

  test "can Table.whereValues" $ withCleanDB "db" $ \db -> toAff do
    DB.version 1 db >>= Version.stores_ (Object.singleton "foo" "++, [title+age]")
    foo <- DB.table "foo" db

    -- Add multiple rows
    Table.add_ { title: "Sir", name: "John", age: 18 } nothingInt foo
    Table.add_ { title: "Prince", name: "Harry", age: 34 } nothingInt foo
    Table.add_ { title: "Sir", name: "Jane", age: 18 } nothingInt foo
    Table.add_ { title: "Queen", name: "Chelsea", age: 78 } nothingInt foo

    -- Query the table based on two values, using compound index
    result <- Table.whereValues { title: "Sir", age: 18 } foo >>= Collection.toArray

    let getName record = record.name

    -- Check it equals what we'd expect
    assertEqual ["John", "Jane"] $ map (unsafeFromForeign >>> getName) result
