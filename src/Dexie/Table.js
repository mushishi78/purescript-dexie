exports.addImpl = function (item) {
  return function (nullableKey) {
    return function (table) {
      return function () {
        return table.add(item, nullableKey)
      }
    }
  }
}
