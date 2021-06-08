module Dexie.Promise where

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

-- | Represents a thunk to create a Dexie Promise
foreign import data Promise :: Type -> Type

foreign import new :: forall v. ((v -> Effect Unit) -> (Error -> Effect Unit) -> Effect Unit) -> Promise v
foreign import all :: forall v. Array (Promise v) -> Promise (Array v)
foreign import allSettled :: forall v. Array (Promise v) -> Promise (Array v)
foreign import any :: forall v. Array (Promise v) -> Promise (Array v)
foreign import catch :: forall v. (Error -> Promise v) -> Promise v -> Promise v
foreign import finally :: forall v. Effect Unit -> Promise v -> Promise v
foreign import race :: forall v. Array (Promise v) -> Promise v
foreign import reject :: forall v. Error -> Promise v
foreign import resolve :: forall v. v -> Promise v
foreign import _then :: forall v1 v2. (v1 -> Promise v2) -> Promise v1 -> Promise v2
foreign import _liftEffect :: forall v. Effect v -> Promise v
foreign import _launchPromise :: Promise Unit -> Effect Unit

instance functorPromise :: Functor Promise where
  map fn = _then (fn >>> pure)

instance applyPromise ∷ Apply Promise where
  apply = ap

instance applicativePromise ∷ Applicative Promise where
  pure = resolve

instance bindPromise ∷ Bind Promise where
  bind = flip _then

instance monadPromise ∷ Monad Promise

instance semigroupPromise ∷ Semigroup a ⇒ Semigroup (Promise a) where
  append = lift2 append

instance monoidPromise ∷ Monoid a ⇒ Monoid (Promise a) where
  mempty = pure mempty

instance altPromise ∷ Alt Promise where
  alt a1 a2 = catch (const a2) a1

instance monadThrowPromise ∷ MonadThrow Error Promise where
  throwError = reject

instance monadErrorPromise ∷ MonadError Error Promise where
  catchError = flip catch

instance monadEffectPromise ∷ MonadEffect Promise where
  liftEffect = _liftEffect

launchPromise :: forall me. MonadEffect me => Promise Unit -> me Unit
launchPromise promise = liftEffect $ _launchPromise promise

toAff :: forall a ma. MonadAff ma => Promise a -> ma a
toAff promise = liftAff $ makeAff $ \cb -> do
  promise
    # _then (\v -> mempty <$ _liftEffect (cb (Right v)))
    # catch (\e -> mempty <$ _liftEffect (cb (Left e)))
    # _launchPromise

  mempty
