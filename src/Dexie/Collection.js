exports.andImpl = function (filter) {
  return function (collection) {
    return function () {
      return collection.and(filter)
    }
  }
}

exports.cloneImpl = function (collection) {
  return function () {
    return collection.clone()
  }
}

exports.countImpl = function (collection) {
  return function () {
    return collection.count()
  }
}

exports.deleteImpl = function (collection) {
  return function () {
    return collection.delete()
  }
}

exports.distinctImpl = function (collection) {
  return function () {
    return collection.distinct()
  }
}

exports.eachImpl = function (callback) {
  return function (collection) {
    return function () {
      return collection.each(function (item) {
        callback(item)()
      })
    }
  }
}

exports.eachKeyImpl = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachKey(function (key) {
        callback(key)()
      })
    }
  }
}

exports.eachPrimaryKeyImpl = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachPrimaryKey(function (primaryKey) {
        callback(primaryKey)()
      })
    }
  }
}

exports.eachUniqueKeyImpl = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachUniqueKey(function (uniqueKey) {
        callback(uniqueKey)()
      })
    }
  }
}

exports.filterImpl = function (filter) {
  return function (collection) {
    return function () {
      return collection.filter(filter)
    }
  }
}

exports.firstImpl = function (collection) {
  return function () {
    return collection.first()
  }
}

exports.keysImpl = function (collection) {
  return function () {
    return collection.keys()
  }
}

exports.lastImpl = function (collection) {
  return function () {
    return collection.last()
  }
}

exports.limitImpl = function (count) {
  return function (collection) {
    return function () {
      return collection.limit(count)
    }
  }
}

exports.modifyImpl = function (changes) {
  return function (collection) {
    return function () {
      return collection.modify(changes)
    }
  }
}

exports.offsetImpl = function (count) {
  return function (collection) {
    return function () {
      return collection.offset(count)
    }
  }
}

exports.orImpl = function (indexName) {
  return function (collection) {
    return function () {
      return collection.or(indexName)
    }
  }
}

exports.primaryKeysImpl = function (collection) {
  return function () {
    return collection.primaryKeys()
  }
}

exports.rawImpl = function (collection) {
  return function () {
    return collection.raw()
  }
}

exports.reverseImpl = function (collection) {
  return function () {
    return collection.reverse()
  }
}

exports.sortByImpl = function (keyPath) {
  return function (collection) {
    return function () {
      return collection.sortBy(keyPath)
    }
  }
}

exports.toArrayImpl = function (collection) {
  return function () {
    return collection.toArray()
  }
}

exports.uniqueKeysImpl = function (collection) {
  return function () {
    return collection.uniqueKeys()
  }
}

exports.untilImpl = function (filterFn) {
  return function (includeStopEntry) {
    return function (collection) {
      return function () {
        return collection.until(filterFn, includeStopEntry)
      }
    }
  }
}
