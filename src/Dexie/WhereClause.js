exports._above = function (lowerBound) {
  return function (whereClause) {
    return function () {
      return whereClause.above(lowerBound)
    }
  }
}

exports._aboveOrEqual = function (lowerBound) {
  return function (whereClause) {
    return function () {
      return whereClause.aboveOrEqual(lowerBound)
    }
  }
}

exports._anyOf = function (keys) {
  return function (whereClause) {
    return function () {
      return whereClause.anyOf(keys)
    }
  }
}

exports._anyOfIgnoreCase = function (keys) {
  return function (whereClause) {
    return function () {
      return whereClause.anyOfIgnoreCase(keys)
    }
  }
}

exports._below = function (upperBound) {
  return function (whereClause) {
    return function () {
      return whereClause.below(upperBound)
    }
  }
}

exports._belowOrEqual = function (upperBound) {
  return function (whereClause) {
    return function () {
      return whereClause.belowOrEqual(upperBound)
    }
  }
}

exports._between = function (lowerBound) {
  return function (upperBound) {
    return function (includeLower) {
      return function (includeUpper) {
        return function (whereClause) {
          return function () {
            return whereClause.between(lowerBound, upperBound, includeLower, includeUpper)
          }
        }
      }
    }
  }
}

exports._equals = function (key) {
  return function (whereClause) {
    return function () {
      return whereClause.equals(key)
    }
  }
}

exports._equalsIgnoreCase = function (key) {
  return function (whereClause) {
    return function () {
      return whereClause.equalsIgnoreCase(key)
    }
  }
}

exports._inAnyRange = function (ranges) {
  return function (includeLowers) {
    return function (includeUppers) {
      return function (whereClause) {
        return function () {
          return whereClause.inAnyRange(ranges, { includeLowers: includeLowers, includeUppers: includeUppers })
        }
      }
    }
  }
}

exports._noneOf = function (keys) {
  return function (whereClause) {
    return function () {
      return whereClause.noneOf(keys)
    }
  }
}

exports._notEqual = function (key) {
  return function (whereClause) {
    return function () {
      return whereClause.notEqual(key)
    }
  }
}

exports._startsWith = function (prefix) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWith(prefix)
    }
  }
}

exports._startsWithAnyOf = function (prefixes) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithAnyOf(prefixes)
    }
  }
}

exports._startsWithIgnoreCase = function (prefix) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithIgnoreCase(prefix)
    }
  }
}

exports._startsWithAnyOfIgnoreCase = function (prefixes) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithAnyOfIgnoreCase(prefixes)
    }
  }
}
