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

exports.onVersionChangeImpl = function (callback) {
  return function (db) {
    return function () {
      return db.on('versionchange', callback)
    }
  }
}
