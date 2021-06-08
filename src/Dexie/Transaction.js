exports._abort = function (transaction) {
  return function () {
    return transaction.abort()
  }
}

exports._table = function (storeName) {
  return function (transaction) {
    return function () {
      return transaction.table(storeName)
    }
  }
}
