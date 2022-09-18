export function _abort(transaction) {
  return function () {
    return transaction.abort()
  }
}

export function _table(storeName) {
  return function (transaction) {
    return function () {
      return transaction.table(storeName)
    }
  }
}
