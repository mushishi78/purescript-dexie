exports.stores = function (storesObject) {
  return function (version) {
    return function () {
      return version.stores(storesObject)
    }
  }
}
