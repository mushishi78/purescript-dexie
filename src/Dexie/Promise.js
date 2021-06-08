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

exports.new = function (callback) {
  return function () {
    return new Promise(function (resolve, reject) {
      callback(function (value) {
        return function () {
          resolve(value)
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
    return Dexie.Promise.resolve(value)
  }
}

exports._then = function (fn) {
  return function (promiseThunk) {
    return function () {
      return promiseThunk().then(function (value) {
        return fn(value)()
      })
    }
  }
}

exports._liftEffect = function (thunk) {
  return function () {
    return Dexie.Promise.resolve(thunk())
  }
}

exports._launchPromise = function (thunk) {
  return thunk
}
