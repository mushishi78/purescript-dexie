export function _and(filter) {
  return function (collection) {
    return function () {
      return collection.and(filter)
    }
  }
}

export function _clone(collection) {
  return function () {
    return collection.clone()
  }
}

export function _count(collection) {
  return function () {
    return collection.count()
  }
}

export function _delete(collection) {
  return function () {
    return collection.delete()
  }
}

export function _distinct(collection) {
  return function () {
    return collection.distinct()
  }
}

export function _each(callback) {
  return function (collection) {
    return function () {
      return collection.each(function (item) {
        callback(item)()
      })
    }
  }
}

export function _eachKey(callback) {
  return function (collection) {
    return function () {
      return collection.eachKey(function (key) {
        callback(key)()
      })
    }
  }
}

export function _eachPrimaryKey(callback) {
  return function (collection) {
    return function () {
      return collection.eachPrimaryKey(function (primaryKey) {
        callback(primaryKey)()
      })
    }
  }
}

export function _eachUniqueKey(callback) {
  return function (collection) {
    return function () {
      return collection.eachUniqueKey(function (uniqueKey) {
        callback(uniqueKey)()
      })
    }
  }
}

export function _filter(filter) {
  return function (collection) {
    return function () {
      return collection.filter(filter)
    }
  }
}

export function _first(collection) {
  return function () {
    return collection.first()
  }
}

export function _keys(collection) {
  return function () {
    return collection.keys()
  }
}

export function _last(collection) {
  return function () {
    return collection.last()
  }
}

export function _limit(count) {
  return function (collection) {
    return function () {
      return collection.limit(count)
    }
  }
}

export function _modify(changes) {
  return function (collection) {
    return function () {
      return collection.modify(changes)
    }
  }
}

export function _offset(count) {
  return function (collection) {
    return function () {
      return collection.offset(count)
    }
  }
}

export function _or(indexName) {
  return function (collection) {
    return function () {
      return collection.or(indexName)
    }
  }
}

export function _primaryKeys(collection) {
  return function () {
    return collection.primaryKeys()
  }
}

export function _raw(collection) {
  return function () {
    return collection.raw()
  }
}

export function _reverse(collection) {
  return function () {
    return collection.reverse()
  }
}

export function _sortBy(keyPath) {
  return function (collection) {
    return function () {
      return collection.sortBy(keyPath)
    }
  }
}

export function _toArray(collection) {
  return function () {
    return collection.toArray()
  }
}

export function _uniqueKeys(collection) {
  return function () {
    return collection.uniqueKeys()
  }
}

export function _until(filterFn) {
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

export function _createModifyMapper(getModifyReplaceValue) {
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
