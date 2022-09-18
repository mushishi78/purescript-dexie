export function _above(lowerBound) {
  return function (whereClause) {
    return function () {
      return whereClause.above(lowerBound)
    }
  }
}

export function _aboveOrEqual(lowerBound) {
  return function (whereClause) {
    return function () {
      return whereClause.aboveOrEqual(lowerBound)
    }
  }
}

export function _anyOf(keys) {
  return function (whereClause) {
    return function () {
      return whereClause.anyOf(keys)
    }
  }
}

export function _anyOfIgnoreCase(keys) {
  return function (whereClause) {
    return function () {
      return whereClause.anyOfIgnoreCase(keys)
    }
  }
}

export function _below(upperBound) {
  return function (whereClause) {
    return function () {
      return whereClause.below(upperBound)
    }
  }
}

export function _belowOrEqual(upperBound) {
  return function (whereClause) {
    return function () {
      return whereClause.belowOrEqual(upperBound)
    }
  }
}

export function _between(lowerBound) {
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

export function _equals(key) {
  return function (whereClause) {
    return function () {
      return whereClause.equals(key)
    }
  }
}

export function _equalsIgnoreCase(key) {
  return function (whereClause) {
    return function () {
      return whereClause.equalsIgnoreCase(key)
    }
  }
}

export function _inAnyRange(ranges) {
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

export function _noneOf(keys) {
  return function (whereClause) {
    return function () {
      return whereClause.noneOf(keys)
    }
  }
}

export function _notEqual(key) {
  return function (whereClause) {
    return function () {
      return whereClause.notEqual(key)
    }
  }
}

export function _startsWith(prefix) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWith(prefix)
    }
  }
}

export function _startsWithAnyOf(prefixes) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithAnyOf(prefixes)
    }
  }
}

export function _startsWithIgnoreCase(prefix) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithIgnoreCase(prefix)
    }
  }
}

export function _startsWithAnyOfIgnoreCase(prefixes) {
  return function (whereClause) {
    return function () {
      return whereClause.startsWithAnyOfIgnoreCase(prefixes)
    }
  }
}
