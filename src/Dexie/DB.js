export function _version(versionNumber) {
  return function (db) {
    return function () {
      return db.version(versionNumber)
    }
  }
}

export function _table(storeName) {
  return function (db) {
    return function () {
      return db.table(storeName)
    }
  }
}

export function _tables(db) {
  return function () {
    return db.tables
  }
}

export function _transaction(db) {
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

export function _open(db) {
  return function () {
    return db.open()
  }
}

export function _close(db) {
  return function () {
    return db.close()
  }
}

export function _onBlocked(callback) {
  return function (db) {
    return function () {
      return db.on('blocked', callback)
    }
  }
}

export function _onReady(callback) {
  return function (db) {
    return function () {
      return db.on('ready', callback)
    }
  }
}

export function _onVersionChange(callback) {
  return function (db) {
    return function () {
      return db.on('versionchange', callback)
    }
  }
}
