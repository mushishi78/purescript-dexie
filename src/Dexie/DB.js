exports.version = function (versionNumber) {
  return function (db) {
    return function () {
      return db.version(versionNumber)
    }
  }
}

exports.table = function (storeName) {
  return function (db) {
    return function () {
      return db.table(storeName)
    }
  }
}
