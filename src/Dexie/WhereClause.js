exports._startsWith = function (prefix) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWith(prefix)
    }
  }
}
