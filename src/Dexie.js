var Dexie = require('dexie')

exports.new = function (dbName) {
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

exports.getDebug = function () {
  return Dexie.debug
}

exports.setDebug = function (isDebug) {
  return function () {
    Dexie.debug = isDebug
  }
}
