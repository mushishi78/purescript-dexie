import Dexie from 'dexie';

export function _new(dbName) {
  return function () {
    return new Dexie(dbName)
  }
}

export function _delete(dbName) {
  return function () {
    return Dexie.delete(dbName)
  }
}

export function _getDatabaseNames() {
  return Dexie.getDatabaseNames()
}

export function _exists(dbName) {
  return function () {
    return Dexie.exists(dbName)
  }
}

export function _getDebug() {
  return Dexie.debug
}

export function _setDebug(isDebug) {
  return function () {
    Dexie.debug = isDebug
  }
}
