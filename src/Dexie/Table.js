exports.addImpl = function (item) {
  return function (table) {
    return function () {
      return table.add(item)
    }
  }
}

exports.addWithKeyImpl = function (item) {
  return function (key) {
    return function (table) {
      return function () {
        return table.add(item, key)
      }
    }
  }
}
