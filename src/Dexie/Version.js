exports.storesImpl = function (storesObject) {
  return function (version) {
    return function () {
      return version.stores(storesObject)
    }
  }
}

exports.upgradeImpl = function (callback) {
  return function (version) {
    return function () {
      return version.upgrade(function (trnx) {
        callback(trnx)()
      })
    }
  }
}
