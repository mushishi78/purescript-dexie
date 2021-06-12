exports._add = function (item) {
  return function (nullableKey) {
    return function (table) {
      return function () {
        return table.add(item, nullableKey)
      }
    }
  }
}

exports._bulkAdd = function (items) {
  return function (nullableKeys) {
    return function (table) {
      return function () {
        return table.bulkAdd(items, nullableKeys, { allKeys: true })
      }
    }
  }
}

exports._bulkDelete = function (keys) {
  return function (table) {
    return function () {
      return table.bulkDelete(keys)
    }
  }
}

exports._bulkGet = function (keys) {
  return function (table) {
    return function () {
      return table.bulkGet(keys)
    }
  }
}

exports._bulkPut = function (items) {
  return function (nullableKeys) {
    return function (table) {
      return function () {
        return table.bulkPut(items, nullableKeys, { allKeys: true })
      }
    }
  }
}

exports._clear = function (table) {
  return function () {
    return table.clear()
  }
}

exports._count = function (table) {
  return function () {
    return table.count()
  }
}

exports._delete = function (key) {
  return function (table) {
    return function () {
      return table.delete(key)
    }
  }
}

exports._each = function (callback) {
  return function (table) {
    return function () {
      return table.each(function (item) {
        callback(item)()
      })
    }
  }
}

exports._filter = function (filterFn) {
  return function (table) {
    return function () {
      return table.filter(filterFn)
    }
  }
}

exports._get = function (indexQuery) {
  return function (table) {
    return function () {
      return table.get(indexQuery)
    }
  }
}

exports._onCreating = function (callback) {
  return function (table) {
    return function () {
      function listener(primaryKey, item, transaction) {
        var self = this
        return callback({
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            return function () {
              self.onsuccess = function (primaryKey) {
                try {
                  return onSuccess(primaryKey)()
                } catch (error) {
                  console.error(error)
                }
              }
            }
          },
          setOnError: function (onError) {
            return function () {
              self.onerror = function (error) {
                try {
                  return onError(error)()
                } catch (error) {
                  console.error(error)
                }
              }
            }
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

exports._onDeleting = function (callback) {
  return function (table) {
    return function () {
      function listener(primaryKey, item, transaction) {
        var self = this
        callback({
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            return function () {
              self.onsuccess = function () {
                try {
                  return onSuccess()
                } catch (error) {
                  console.error(error)
                }
              }
            }
          },
          setOnError: function (onError) {
            return function () {
              self.onerror = function (error) {
                try {
                  return onError(error)()
                } catch (error) {
                  console.error(error)
                }
              }
            }
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

exports._onReading = function (callback) {
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

exports._onUpdating = function (callback) {
  return function (table) {
    return function () {
      function listener(modifications, primaryKey, item, transaction) {
        var self = this
        return callback({
          modifications,
          primaryKey,
          item,
          transaction,
          setOnSuccess: function (onSuccess) {
            return function () {
              self.onsuccess = function (updatedItem) {
                try {
                  return onSuccess(updatedItem)()
                } catch (error) {
                  console.error(error)
                }
              }
            }
          },
          setOnError: function (onError) {
            return function () {
              self.onerror = function (error) {
                try {
                  return onError(error)()
                } catch (error) {
                  console.error(error)
                }
              }
            }
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

exports._limit = function (n) {
  return function (table) {
    return function () {
      return table.limit(n)
    }
  }
}

exports._name = function (table) {
  return function () {
    return table.name
  }
}

exports._offset = function (n) {
  return function (table) {
    return function () {
      return table.offset(n)
    }
  }
}

exports._orderBy = function (index) {
  return function (table) {
    return function () {
      return table.orderBy(index)
    }
  }
}

exports._put = function (item) {
  return function (nullableKey) {
    return function (table) {
      return function () {
        return table.put(item, nullableKey)
      }
    }
  }
}

exports._reverse = function (table) {
  return function () {
    return table.reverse()
  }
}

exports._toArray = function (table) {
  return function () {
    return table.toArray()
  }
}

exports._toCollection = function (table) {
  return function () {
    return table.toCollection()
  }
}

exports._update = function (key) {
  return function (changes) {
    return function (table) {
      return function () {
        return table.update(key, changes)
      }
    }
  }
}

exports._whereClause = function (index) {
  return function (table) {
    return function () {
      return table.where(index)
    }
  }
}

exports._whereValues = function (valuesObject) {
  return function (table) {
    return function () {
      return table.where(valuesObject)
    }
  }
}
