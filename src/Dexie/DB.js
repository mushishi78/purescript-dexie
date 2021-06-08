exports._version = function (versionNumber) {
  return function (db) {
    return function () {
      return db.version(versionNumber)
    }
  }
}

exports._table = function (storeName) {
  return function (db) {
    return function () {
      return db.table(storeName)
    }
  }
}

exports._transaction = function (db) {
  return function (mode) {
    return function (tables) {
      return function (callback) {
        return function () {
          return db.transaction(mode, tables, function (transaction) {
            return callback(transaction)()
          })
        }
      }
    }
  }
}

exports._open = function (db) {
  return function () {
    return db.open()
  }
}

exports._close = function (db) {
  return function () {
    return db.close()
  }
}

exports._onBlocked = function (callback) {
  return function (db) {
    return function () {
      return db.on('blocked', callback)
    }
  }
}

exports._onReady = function (callback) {
  return function (db) {
    return function () {
      return db.on('ready', callback)
    }
  }
}

exports._onVersionChange = function (callback) {
  return function (db) {
    return function () {
      return db.on('versionchange', callback)
    }
  }
}
