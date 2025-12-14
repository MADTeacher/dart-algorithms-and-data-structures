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

class HashTable<K, V> {
  static const int _defaultSize = 16;
  final int _initialCapacity;
  List<_Node<HashTableEntry<K, V>>?> _buckets;
  int _size = 0;

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

    for (var node in oldBuckets) {
      while (node != null) {
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
  }

  void forEach(void Function(K key, V value) callback) {
    for (var bucket in _buckets) {
      while (bucket != null) {
        callback(bucket.data.key, bucket.data.value);
        bucket = bucket.next;
      }
    }
  }

  @override
  String toString() {
    if (isEmpty) return '{}';

    StringBuffer buffer = StringBuffer();
    buffer.write('{');
    for (var bucket in _buckets) {
      while (bucket != null) {
        buffer.write('${bucket.data.key}: ${bucket.data.value}, ');
        bucket = bucket.next;
      }
    }
    buffer.write('}');
    return buffer.toString();
  }
}

