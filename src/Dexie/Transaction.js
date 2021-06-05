exports.abortImpl = function (transaction) {
  return function () {
    return transaction.abort()
  }
}

exports.tableImpl = function (storeName) {
  return function (transaction) {
    return function () {
      return transaction.table(storeName)
    }
  }
}
