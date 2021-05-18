var Dexie = require('dexie')

exports.newImpl = function (dbName) {
  return function () {
    return new Dexie(dbName)
  }
}

exports.deleteImpl = function (dbName) {
  return function () {
    return Dexie.delete(dbName)
  }
}

exports.getDatabaseNamesImpl = function () {
  return Dexie.getDatabaseNames()
}

exports.existsImpl = function (dbName) {
  return function () {
    return Dexie.exists(dbName)
  }
}

exports.getDebugImpl = function () {
  return Dexie.debug
}

exports.setDebugImpl = function (isDebug) {
  return function () {
    Dexie.debug = isDebug
  }
}
