class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker{name: $name, id: $id}';
}

// Узел дерева
class _Node<T> {
  int label;
  // Ссылки на дочерние узлы
  _Node<T>? leftNode;
  _Node<T>? rightNode;
  _Node<T>? middleNode;
  // Ссылка на хранимое значение
  T? value;
  // Признак конечного узла
  bool isEnd = false;
  // Ссылка на ключ
  String? key;

  _Node(this.label);
}

class Trie<T> {
  _Node<T>? _root;

  void put(String key, T value) {
    if (key.isEmpty) {
      throw ArgumentError('key is empty');
    }
    _root = _put(_root, key, value, 0, true);
  }

  _Node<T> _put(
    _Node<T>? curNode,
    String key,
    T? value,
    int index,
    bool isEnd,
  ) {
    int label = key.codeUnitAt(index);
    curNode ??= _Node<T>(label);

    if (label < curNode.label) {
      curNode.leftNode = _put(curNode.leftNode, key, value, index, isEnd);
    } else if (label > curNode.label) {
      curNode.rightNode = _put(curNode.rightNode, key, value, index, isEnd);
    } else if (index < key.length - 1) {
      curNode.middleNode = _put(
        curNode.middleNode,
        key,
        value,
        index + 1,
        isEnd,
      );
    } else {
      curNode.value = value;
      curNode.isEnd = isEnd;
      curNode.key = key;
    }
    return curNode;
  }

  bool contains(String key) {
    if (key.isEmpty) {
      return false;
    }
    return get(key) != null;
  }

  T? get(String key) {
    if (key.isEmpty) {
      return null;
    }
    final x = _findNode(_root, key, 0);
    if (x == null || !x.isEnd) {
      return null;
    }
    return x.value;
  }

  _Node<T>? _findNode(_Node<T>? curNode, String key, int index) {
    if (curNode == null || key.isEmpty) {
      return null;
    }
    int c = key.codeUnitAt(index);
    if (c < curNode.label) {
      return _findNode(curNode.leftNode, key, index);
    } else if (c > curNode.label) {
      return _findNode(curNode.rightNode, key, index);
    } else if (index < key.length - 1) {
      return _findNode(curNode.middleNode, key, index + 1);
    } else {
      return curNode;
    }
  }

  void remove(String key) {
    if (key.isEmpty || !contains(key)) {
      return;
    }
    _root = _put(_root, key, null, 0, false);
  }

  List<String> allKeys() {
    return _assemble(_root, "", []);
  }

  List<String> allKeysWithPrefix(String prefix) {
    if (prefix.isEmpty) {
      throw ArgumentError('query string is empty');
    }
    final x = _findNode(_root, prefix, 0);
    if (x == null) {
      throw Exception('keys not founded');
    }
    List<String> queue = [];
    if (x.isEnd) {
      queue.add(prefix);
    }
    return _assemble(x.middleNode, prefix, queue);
  }

  List<String> _assemble(_Node<T>? curNode, String prefix, List<String> queue) {
    if (curNode == null) {
      return queue;
    }
    _assemble(curNode.leftNode, prefix, queue);
    if (curNode.isEnd) {
      queue.add(prefix + String.fromCharCode(curNode.label));
    }
    _assemble(
      curNode.middleNode,
      prefix + String.fromCharCode(curNode.label),
      queue,
    );
    return _assemble(curNode.rightNode, prefix, queue);
  }

  String longestPrefix(String query) {
    if (query.isEmpty) {
      return "";
    }
    int length = 0;
    _Node<T>? currentNode = _root;
    int i = 0;
    while (currentNode != null && i < query.length) {
      int label = query.codeUnitAt(i);
      if (label < currentNode.label) {
        currentNode = currentNode.leftNode;
      } else if (label > currentNode.label) {
        currentNode = currentNode.rightNode;
      } else {
        i++;
        if (currentNode.isEnd) {
          length = i;
        }
        currentNode = currentNode.middleNode;
      }
    }
    return query.substring(0, length);
  }

  void forEach(void Function(String key, T value) myFunc) {
    _forEach(_root, myFunc);
  }

  void _forEach(
    _Node<T>? localRoot,
    void Function(String key, T value) myFunc,
  ) {
    if (localRoot != null) {
      if (localRoot.isEnd && localRoot.key != null && localRoot.value != null) {
        myFunc(localRoot.key!, localRoot.value as T);
      }
      _forEach(localRoot.leftNode, myFunc);
      _forEach(localRoot.middleNode, myFunc);
      _forEach(localRoot.rightNode, myFunc);
    }
  }
}

void main() {
  final trie = Trie<List<Worker>>();

  trie.put('manager', [
    Worker('Julie', 1),
    Worker('Alex', 2),
    Worker('Tom', 4),
  ]);
  trie.put('policeman', [Worker('George', 3), Worker('Max', 60)]);
  trie.put('postman', [Worker('Tommy', 94), Worker('William', 12)]);
  trie.put('mathematician', [Worker('Sophia', 14), Worker('Oliver', 13)]);
  trie.put('postwoman', [Worker('Sandra', 91), Worker('Ann', 6)]);
  trie.put('policewoman', [Worker('Elizabeth', 9), Worker('Kate', 20)]);

  trie.forEach((key, value) {
    print('Key: $key ; Value: $value');
  });

  print("'man' is Contains? ${trie.contains('man')}");
  print("'manager' is Contains? ${trie.contains('manager')}");

  try {
    final keysPo = trie.allKeysWithPrefix('po');
    print("Keys with prefix 'po' $keysPo");
  } catch (e) {
    print(e);
  }

  try {
    final keysPolice = trie.allKeysWithPrefix('police');
    print("Keys with prefix 'police' $keysPolice");
  } catch (e) {
    print(e);
  }

  try {
    final keysM = trie.allKeysWithPrefix('m');
    print("Keys with prefix 'm' $keysM");
  } catch (e) {
    print(e);
  }

  print('All keys: ${trie.allKeys()}');

  print('----- Remove key \'manager\'------');
  trie.remove('manager');

  trie.forEach((key, value) {
    print('Key: $key ; Value: $value');
  });
}
