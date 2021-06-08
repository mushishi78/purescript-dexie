var Dexie = require('dexie')

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

exports.new = function (callback) {
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

exports.all = function (promiseThunks) {
  return function () {
    return Dexie.Promise.all(triggerThunks(promiseThunks))
  }
}

exports.allSettled = function (promiseThunks) {
  return function () {
    return Dexie.Promise.allSettled(triggerThunks(promiseThunks))
  }
}

exports.any = function (promiseThunks) {
  return function () {
    return Dexie.Promise.any(triggerThunks(promiseThunks))
  }
}

exports.catch = function (fn) {
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

exports.finally = function (fn) {
  return function (promiseThunk) {
    return function () {
      return promiseThunk().finally(fn)
    }
  }
}

exports.race = function (promiseThunks) {
  return function () {
    return Dexie.Promise.race(triggerThunks(promiseThunks))
  }
}

exports.reject = function (error) {
  return function () {
    return Dexie.Promise.reject(error)
  }
}

exports.resolve = function (value) {
  return function () {
    return Dexie.Promise.resolve(wrapIfPromise(value))
  }
}

exports._then = function (fn) {
  return function (promiseThunk) {
    return function () {
      return promiseThunk().then(function (value) {
        return fn(unwrap(value))()
      })
    }
  }
}

exports._liftEffect = function (thunk) {
  return function () {
    return Dexie.Promise.resolve(wrapIfPromise(thunk()))
  }
}

exports._launchPromise = function (thunk) {
  return thunk
}
