// Задание 8: Защита от модификации при итерации (Fail-Fast)
// 
// Этот файл содержит полную реализацию HashTable с защитой от модификации.
// Для использования в других файлах можно импортировать этот файл вместо hashtable_v.1.dart

class HashTableEntry<K, V> {
  K key;
  V value;

  HashTableEntry(this.key, this.value);
}

class _Node<T> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

// Класс исключения для обнаружения модификации при итерации
class ConcurrentModificationError extends Error {
  final String message;
  ConcurrentModificationError(this.message);
  
  @override
  String toString() => 'ConcurrentModificationError: $message';
}

class HashTable<K, V> {
  static const int _defaultSize = 16;
  final int _initialCapacity;
  List<_Node<HashTableEntry<K, V>>?> _buckets;
  int _size = 0;
  int _modCount = 0; // Счетчик модификаций для защиты от изменения при итерации

  HashTable([this._initialCapacity = _defaultSize])
    : _buckets = List<_Node<HashTableEntry<K, V>>?>.filled(
        _initialCapacity,
        null,
      );

  int get length => _size;

  bool get isEmpty => _size == 0;

  int _getBucketIndex(K key) {
    int hashCode = key.hashCode;
    return hashCode % _buckets.length;
  }

  void add(K key, V value) {
    if ((_size + 1) / _buckets.length > 0.75) {
      print('resize');
      _resize();
    }

    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        node.data.value = value; // замена значения по ключу
        return;
      }
      node = node.next;
    }
    _buckets[index] = _Node<HashTableEntry<K, V>>(
      HashTableEntry(key, value),
      next: _buckets[index],
    );
    _size++;
    _modCount++; // Увеличиваем счетчик модификаций
  }

  void operator []=(K key, V value) {
    add(key, value);
  }

  V? get(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        return node.data.value;
      }
      node = node.next;
    }
    return null;
  }

  V? operator [](K key) {
    return get(key);
  }

  void _resize() {
    final oldBuckets = _buckets;
    _buckets = List<_Node<HashTableEntry<K, V>>?>.filled(
      oldBuckets.length * 2,
      null,
    );
    _size = 0;
    _modCount++; // Увеличиваем счетчик модификаций при изменении структуры

    for (var node in oldBuckets) {
      while (node != null) {
        // Внутри add также увеличивается _modCount
        add(node.data.key, node.data.value);
        node = node.next;
      }
    }
  }

  bool containsKey(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        return true;
      }
      node = node.next;
    }
    return false;
  }

  V? remove(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    _Node<HashTableEntry<K, V>>? prevNode;
    while (node != null) {
      if (node.data.key == key) {
        if (prevNode == null) {
          _buckets[index] = node.next;
        } else {
          prevNode.next = node.next;
        }
        _size--;
        _modCount++; // Увеличиваем счетчик модификаций
        return node.data.value;
      }
      prevNode = node;
      node = node.next;
    }
    return null;
  }

  void clear() {
    _buckets = List<_Node<HashTableEntry<K, V>>?>.filled(
      _initialCapacity,
      null,
    );
    _size = 0;
    _modCount++; // Увеличиваем счетчик модификаций
  }

  void forEach(void Function(K key, V value) callback) {
    int expectedModCount = _modCount; // Запоминаем значение счетчика перед итерацией
    for (var bucket in _buckets) {
      var node = bucket;
      while (node != null) {
        // Проверяем, не изменилась ли структура таблицы
        if (_modCount != expectedModCount) {
          throw ConcurrentModificationError(
            'Хеш-таблица была модифицирована во время итерации'
          );
        }
        callback(node.data.key, node.data.value);
        node = node.next;
      }
    }
  }

  @override
  String toString() {
    if (isEmpty) return '{}';

    StringBuffer buffer = StringBuffer();
    buffer.write('{');
    for (var bucket in _buckets) {
      var node = bucket;
      while (node != null) {
        buffer.write('${node.data.key}: ${node.data.value}, ');
        node = node.next;
      }
    }
    buffer.write('}');
    return buffer.toString();
  }
}

void main() {  
  // Тест 1: Удаление элемента во время итерации
  print('Тест 1: Попытка удаления элемента во время итерации');
  var table1 = HashTable<String, int>();
  table1["a"] = 1;
  table1["b"] = 2;
  table1["c"] = 3;
  
  print('Таблица: $table1');
  
  try {
    table1.forEach((k, v) {
      print('Обрабатываем: $k = $v');
      if (k == "a") {
        print('  -> Удаляем "b" во время итерации...');
        table1.remove("b"); // Это должно вызвать ошибку на следующей итерации
      }
    });
    print('ОШИБКА: Исключение не было выброшено!');
  } catch (e) {
    print('✓ Поймали ошибку изменения: $e');
    print('Тест пройден!\n');
  }
  
  // Тест 2: Добавление элемента во время итерации
  print('Тест 2: Попытка добавления элемента во время итерации');
  var table2 = HashTable<int, String>();
  table2[1] = "один";
  table2[2] = "два";
  
  print('Таблица: $table2');
  
  try {
    table2.forEach((k, v) {
      print('Обрабатываем: $k = $v');
      if (k == 1) {
        print('  -> Добавляем новый элемент во время итерации...');
        table2[3] = "три"; // Это должно вызвать ошибку
      }
    });
    print('ОШИБКА: Исключение не было выброшено!');
  } catch (e) {
    print('✓ Поймали ошибку изменения: $e');
    print('Тест пройден!\n');
  }
  
  // Тест 3: Очистка таблицы во время итерации
  print('Тест 3: Попытка очистки таблицы во время итерации');
  var table3 = HashTable<String, int>();
  table3["x"] = 10;
  table3["y"] = 20;
  
  print('Таблица: $table3');
  
  try {
    table3.forEach((k, v) {
      print('Обрабатываем: $k = $v');
      if (k == "x") {
        print('  -> Очищаем таблицу во время итерации...');
        table3.clear(); // Это должно вызвать ошибку
      }
    });
    print('ОШИБКА: Исключение не было выброшено!');
  } catch (e) {
    print('✓ Поймали ошибку изменения: $e');
    print('Тест пройден!\n');
  }
  
  // Тест 4: Нормальная итерация без модификации
  print('Тест 4: Нормальная итерация без модификации');
  var table4 = HashTable<String, int>();
  table4["a"] = 1;
  table4["b"] = 2;
  table4["c"] = 3;
  
  print('Таблица: $table4');
  print('Итерация:');
  table4.forEach((k, v) {
    print('  $k = $v');
  });
  print('Итерация завершена успешно!');
}
