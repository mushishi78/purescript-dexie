module Dexie.Promise
  ( Promise
  , LaunchedPromise
  , new
  , all
  , allSettled
  , any
  , catch
  , finally
  , race
  , reject
  , resolve
  , _then
  , launch
  , join
  , toAff
  ) where

import Prelude

import Control.Alt (class Alt)
import Control.Apply (lift2)
import Control.Monad.Error.Class (class MonadError, class MonadThrow)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (makeAff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Exception (Error)

-- | Represents a thunk to create a Dexie Promise.
-- |
-- | Ideally no async operations that are unrelated to indexed db should be modelled with these promises
-- | as they will automatically close an open transaction. So if you do not manually make a Promise,
-- | then the compiler can ensure you're not closing transactions.
-- |
-- | See [Transaction Scope](https://dexie.org/docs/Dexie/Dexie.transaction()#transaction-scope) for more details
-- | about closing transactions.
-- |
-- | Documentation: [dexie.org/docs/Promise/Promise](https://dexie.org/docs/Promise/Promise)
-- | Methods: [Dexie.Promise](Dexie.Promise#m:Promise)
foreign import data Promise :: Type -> Type

-- | Represents a previously triggered Dexie Promise
-- | See [Dexie.Promise](Dexie.Promise#m:Promise)
foreign import data LaunchedPromise :: Type -> Type

-- | Equivalent of `new Dexie.Promise((resolve, reject) => ...)`.
-- | Use with caution with non-indexed db related async operations if you do no want to close transactions early.
foreign import new :: forall v. ((v -> Effect Unit) -> (Error -> Effect Unit) -> Effect Unit) -> Promise v

-- | Documentation: [Promise.all()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
foreign import all :: forall v. Array (Promise v) -> Promise (Array v)

-- | Documentation: [Promise.allSettled()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled)
foreign import allSettled :: forall v. Array (Promise v) -> Promise (Array v)

-- | Documentation: [Promise.any()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/any)
foreign import any :: forall v. Array (Promise v) -> Promise (Array v)

-- | Documentation: [Promise.prototype.catch()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/catch)
foreign import catch :: forall v. (Error -> Promise v) -> Promise v -> Promise v

-- | Documentation: [Promise.prototype.finally()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/finally)
foreign import finally :: forall v. Effect Unit -> Promise v -> Promise v

-- | Documentation: [Promise.race()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/race)
foreign import race :: forall v. Array (Promise v) -> Promise v

-- | Documentation: [Promise.reject()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/reject)
foreign import reject :: forall v. Error -> Promise v

-- | Documentation: [Promise.resolve()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve)
foreign import resolve :: forall v. v -> Promise v

-- | Documentation: [Promise.prototype.then()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then)
foreign import _then :: forall v1 v2. (v1 -> Promise v2) -> Promise v1 -> Promise v2

foreign import _liftEffect :: forall v. Effect v -> Promise v
foreign import _launch :: forall v. Promise v -> Effect (LaunchedPromise v)
foreign import _join :: forall v. LaunchedPromise v -> Promise v

instance functorPromise :: Functor Promise where
  map fn = _then (fn >>> pure)

instance applyPromise :: Apply Promise where
  apply = ap

instance applicativePromise :: Applicative Promise where
  pure = resolve

instance bindPromise :: Bind Promise where
  bind = flip _then

instance monadPromise :: Monad Promise

instance semigroupPromise :: Semigroup a ⇒ Semigroup (Promise a) where
  append = lift2 append

instance monoidPromise :: Monoid a ⇒ Monoid (Promise a) where
  mempty = pure mempty

instance altPromise :: Alt Promise where
  alt a1 a2 = catch (const a2) a1

instance monadThrowPromise :: MonadThrow Error Promise where
  throwError = reject

instance monadErrorPromise :: MonadError Error Promise where
  catchError = flip catch

instance monadEffectPromise :: MonadEffect Promise where
  liftEffect = _liftEffect

-- | Triggers a promise but does not wait for it to resolve.
launch :: forall v me. MonadEffect me => Promise v -> me (LaunchedPromise v)
launch promise = liftEffect $ _launch promise

-- | Can be used to wait on a previously triggered promise.
join :: forall v. LaunchedPromise v -> Promise v
join = _join

toAff :: forall a ma. MonadAff ma => Promise a -> ma a
toAff promise = liftAff $ makeAff $ \cb -> do
  promise
    # _then (\v -> pure unit <* _liftEffect (cb (Right v)))
    # catch (\e -> mempty <$ _liftEffect (cb (Left e)))
    # launch
    # void

  mempty
