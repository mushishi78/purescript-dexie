exports.addImpl = function (item) {
  return function (nullableKey) {
    return function (table) {
      return function () {
        return table.add(item, nullableKey)
      }
    }
  }
}

exports.bulkAddImpl = function (items) {
  return function (nullableKeys) {
    return function (table) {
      return function () {
        return table.bulkAdd(items, nullableKeys, { allKeys: true })
      }
    }
  }
}

exports.bulkDeleteImpl = function (keys) {
  return function (table) {
    return function () {
      return table.bulkDelete(keys)
    }
  }
}

exports.bulkGetImpl = function (keys) {
  return function (table) {
    return function () {
      return table.bulkGet(keys)
    }
  }
}

exports.bulkPutImpl = function (items) {
  return function (nullableKeys) {
    return function (table) {
      return function () {
        return table.bulkPut(items, nullableKeys, { allKeys: true })
      }
    }
  }
}

exports.clearImpl = function (table) {
  return function () {
    return table.clear()
  }
}

exports.countImpl = function (table) {
  return function () {
    return table.count()
  }
}

exports.deleteImpl = function (key) {
  return function (table) {
    return function () {
      return table.delete(key)
    }
  }
}

exports.eachImpl = function (callback) {
  return function (table) {
    return function () {
      return table.each(function (item) {
        callback(item)()
      })
    }
  }
}

exports.filterImpl = function (filterFn) {
  return function (table) {
    return function () {
      return table.filter(filterFn)
    }
  }
}

exports.getImpl = function (indexQuery) {
  return function (table) {
    return function () {
      return table.get(indexQuery)
    }
  }
}

exports.onCreatingImpl = function (callback) {
  return function (table) {
    return function () {
      function listener(primaryKey, item, transaction) {
        return callback({
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            this.onsuccess = onSuccess
          },
          setOnError: function (onError) {
            this.onerror = onError
          },
        })()
      }

      table.hook('creating', listener)

      return function () {
        table.hook('creating').unsubscribe(listener)
      }
    }
  }
}

exports.onDeletingImpl = function (callback) {
  return function (table) {
    return function () {
      function listener(primaryKey, item, transaction) {
        callback({
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            this.onsuccess = onSuccess
          },
          setOnError: function (onError) {
            this.onerror = onError
          },
        })()
      }

      table.hook('deleting', listener)

      return function () {
        table.hook('deleting').unsubscribe(listener)
      }
    }
  }
}

exports.onReadingImpl = function (callback) {
  return function (table) {
    return function () {
      function listener(item) {
        return callback(item)()
      }

      table.hook('reading', listener)

      return function () {
        table.hook('reading').unsubscribe(listener)
      }
    }
  }
}

exports.onUpdatingImpl = function (callback) {
  return function (table) {
    return function () {
      function listener(primaryKey, item, transaction) {
        return callback({
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            this.onsuccess = onSuccess
          },
          setOnError: function (onError) {
            this.onerror = onError
          },
        })()
      }

      table.hook('updating', listener)

      return function () {
        table.hook('updating').unsubscribe(listener)
      }
    }
  }
}

exports.limitImpl = function (n) {
  return function (table) {
    return function () {
      return table.limit(n)
    }
  }
}

exports.nameImpl = function (table) {
  return function () {
    return table.name
  }
}

exports.offsetImpl = function (n) {
  return function (table) {
    return function () {
      return table.offset(n)
    }
  }
}

exports.orderByImpl = function (index) {
  return function (table) {
    return function () {
      return table.orderBy(index)
    }
  }
}

exports.putImpl = function (item) {
  return function (nullableKey) {
    return function (table) {
      return function () {
        return table.put(item, nullableKey)
      }
    }
  }
}

exports.reverseImpl = function (table) {
  return function () {
    return table.reverse()
  }
}

exports.toArrayImpl = function (table) {
  return function () {
    return table.toArray()
  }
}

exports.toCollectionImpl = function (table) {
  return function () {
    return table.toCollection()
  }
}

exports.updateImpl = function (key) {
  return function (changes) {
    return function (table) {
      return function () {
        return table.update(key, changes)
      }
    }
  }
}

exports.whereClauseImpl = function (index) {
  return function (table) {
    return function () {
      return table.where(index)
    }
  }
}

exports.whereValuesImpl = function (valuesObject) {
  return function (table) {
    return function () {
      return table.where(valuesObject)
    }
  }
}
