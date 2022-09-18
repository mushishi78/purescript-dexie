export function _stores(storesObject) {
  return function (version) {
    return function () {
      return version.stores(storesObject)
    }
  }
}

export function _upgrade(callback) {
  return function (version) {
    return function () {
      return version.upgrade(function (trnx) {
        return callback(trnx)()
      })
    }
  }
}
