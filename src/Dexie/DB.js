exports.versionImpl = function (versionNumber) {
  return function (db) {
    return function () {
      return db.version(versionNumber)
    }
  }
}

exports.tableImpl = function (storeName) {
  return function (db) {
    return function () {
      return db.table(storeName)
    }
  }
}

exports.transactionImpl = function (db) {
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

exports.openImpl = function (db) {
  return function () {
    return db.open()
  }
}

exports.closeImpl = function (db) {
  return function () {
    return db.close()
  }
}

exports.onBlockedImpl = function (callback) {
  return function (db) {
    return function () {
      return db.on('blocked', callback)
    }
  }
}

exports.onReadyImpl = function (callback) {
  return function (db) {
    return function () {
      return db.on('ready', callback)
    }
  }
}

exports.onVersionChangeImpl = function (callback) {
  return function (db) {
    return function () {
      return db.on('versionchange', callback)
    }
  }
}
