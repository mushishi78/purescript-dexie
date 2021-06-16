exports._and = function (filter) {
  return function (collection) {
    return function () {
      return collection.and(filter)
    }
  }
}

exports._clone = function (collection) {
  return function () {
    return collection.clone()
  }
}

exports._count = function (collection) {
  return function () {
    return collection.count()
  }
}

exports._delete = function (collection) {
  return function () {
    return collection.delete()
  }
}

exports._distinct = function (collection) {
  return function () {
    return collection.distinct()
  }
}

exports._each = function (callback) {
  return function (collection) {
    return function () {
      return collection.each(function (item) {
        callback(item)()
      })
    }
  }
}

exports._eachKey = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachKey(function (key) {
        callback(key)()
      })
    }
  }
}

exports._eachPrimaryKey = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachPrimaryKey(function (primaryKey) {
        callback(primaryKey)()
      })
    }
  }
}

exports._eachUniqueKey = function (callback) {
  return function (collection) {
    return function () {
      return collection.eachUniqueKey(function (uniqueKey) {
        callback(uniqueKey)()
      })
    }
  }
}

exports._filter = function (filter) {
  return function (collection) {
    return function () {
      return collection.filter(filter)
    }
  }
}

exports._first = function (collection) {
  return function () {
    return collection.first()
  }
}

exports._keys = function (collection) {
  return function () {
    return collection.keys()
  }
}

exports._last = function (collection) {
  return function () {
    return collection.last()
  }
}

exports._limit = function (count) {
  return function (collection) {
    return function () {
      return collection.limit(count)
    }
  }
}

exports._modify = function (changes) {
  return function (collection) {
    return function () {
      return collection.modify(changes)
    }
  }
}

exports._offset = function (count) {
  return function (collection) {
    return function () {
      return collection.offset(count)
    }
  }
}

exports._or = function (indexName) {
  return function (collection) {
    return function () {
      return collection.or(indexName)
    }
  }
}

exports._primaryKeys = function (collection) {
  return function () {
    return collection.primaryKeys()
  }
}

exports._raw = function (collection) {
  return function () {
    return collection.raw()
  }
}

exports._reverse = function (collection) {
  return function () {
    return collection.reverse()
  }
}

exports._sortBy = function (keyPath) {
  return function (collection) {
    return function () {
      return collection.sortBy(keyPath)
    }
  }
}

exports._toArray = function (collection) {
  return function () {
    return collection.toArray()
  }
}

exports._uniqueKeys = function (collection) {
  return function () {
    return collection.uniqueKeys()
  }
}

exports._until = function (filterFn) {
  return function (includeStopEntry) {
    return function (collection) {
      return function () {
        return collection.until(filterFn, includeStopEntry)
      }
    }
  }
}

//
// Helpers

exports._createModifyMapper = function (getModifyReplaceValue) {
  return function (isModifyIgnore) {
    return function (isModifyDelete) {
      return function (fn) {
        return function (value) {
          var modifyEffect = fn(value)
          if (isModifyIgnore(modifyEffect)) return
          if (isModifyDelete(modifyEffect)) {
            delete this.value
            return
          }
          this.value = getModifyReplaceValue(modifyEffect)
        }
      }
    }
  }
}
