var Dexie = require('dexie')

exports._new = function (dbName) {
  return function () {
    return new Dexie(dbName)
  }
}

exports._delete = function (dbName) {
  return function () {
    return Dexie.delete(dbName)
  }
}

exports._getDatabaseNames = function () {
  return Dexie.getDatabaseNames()
}

exports._exists = function (dbName) {
  return function () {
    return Dexie.exists(dbName)
  }
}

exports._getDebug = function () {
  return Dexie.debug
}

exports._setDebug = function (isDebug) {
  return function () {
    Dexie.debug = isDebug
  }
}
