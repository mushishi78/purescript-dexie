import Dexie from 'dexie';

function ensureError(error) {
  error = error != null ? error : new Error('Undefined error')
  error = typeof error !== 'string' ? error : new Error(error)
  error = error instanceof Error ? error : new Error('Non-error thrown')
  return error
}

function triggerThunks(promiseThunks) {
  return promiseThunks.map(promiseThunk => promiseThunk())
}

function WrappedPromise(promise) {
  this.promise = promise
}

// Avoid flattening promises by wrapping them first
function wrapIfPromise(value) {
  if (value == null) return value
  if (value instanceof Dexie.Promise || typeof value.then === 'function') {
    return new WrappedPromise(value)
  }
  return value
}

function unwrap(value) {
  if (value == null) return value
  if (value instanceof WrappedPromise) return value.promise
  return value
}

export function new_(callback) {
  return function () {
    return new Dexie.Promise(function (resolve, reject) {
      callback(function (value) {
        return function () {
          resolve(wrapIfPromise(value))
        }
      })(function (error) {
        return function () {
          reject(error)
        }
      })()
    })
  }
}

export function all(promiseThunks) {
  return function () {
    return Dexie.Promise.all(triggerThunks(promiseThunks))
  }
}

export function allSettled(promiseThunks) {
  return function () {
    return Dexie.Promise.allSettled(triggerThunks(promiseThunks))
  }
}

export function any(promiseThunks) {
  return function () {
    return Dexie.Promise.any(triggerThunks(promiseThunks))
  }
}

export function catch_(fn) {
  return function (promiseThunk) {
    return function () {
      try {
        return promiseThunk().catch(function (error) {
          return fn(ensureError(error))()
        })
      } catch (error) {
        return fn(ensureError(error))()
      }
    }
  }
}

export function finally_(fn) {
  return function (promiseThunk) {
    return function () {
      return promiseThunk().finally(fn)
    }
  }
}

export function race(promiseThunks) {
  return function () {
    return Dexie.Promise.race(triggerThunks(promiseThunks))
  }
}

export function reject(error) {
  return function () {
    return Dexie.Promise.reject(error)
  }
}

export function resolve(value) {
  return function () {
    return Dexie.Promise.resolve(wrapIfPromise(value))
  }
}

export function _then(fn) {
  return function (promiseThunk) {
    return function () {
      return promiseThunk().then(function (value) {
        return fn(unwrap(value))()
      })
    }
  }
}

export function _liftEffect(thunk) {
  return function () {
    return Dexie.Promise.resolve(wrapIfPromise(thunk()))
  }
}

export function _launch(thunk) {
  return thunk
}

export function _join(launchedPromise) {
  return function () {
    return launchedPromise
  }
}
