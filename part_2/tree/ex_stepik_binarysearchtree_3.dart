class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? left;
  _Node<T>? right;

  _Node(this.data, {this.left, this.right});

  @override
  String toString() {
    return '$data';
  }
}

class BinarySearchTree<T extends Comparable<dynamic>> {
  _Node<T>? _root;
  int _length = 0;

  BinarySearchTree();

  bool get isEmpty => _root == null;
  int get length => _length;

  void insert(T data) {
    _root = _insert(_root, data);
  }

  _Node<T>? _insert(_Node<T>? node, T data) {
    if (node == null) {
      _length++;
      return _Node<T>(data);
    } else if (data.compareTo(node.data) < 0) {
      node.left = _insert(node.left, data);
    } else if (data.compareTo(node.data) > 0) {
      node.right = _insert(node.right, data);
    } else {
      node.data = data;
    }
    return node;
  }

  T? find(T data) {
    _Node<T>? node = _root;
    while (node != null) {
      if (data.compareTo(node.data) < 0) {
        node = node.left;
      } else if (data.compareTo(node.data) > 0) {
        node = node.right;
      } else {
        return node.data;
      }
    }
    return null;
  }

  bool containsKey(T data) {
    return find(data) != null;
  }

  T minimum() {
    if (_root == null) {
      throw StateError('Tree is empty');
    }
    _Node<T>? node = _root;
    while (node?.left != null) {
      node = node!.left;
    }
    return node!.data;
  }

  T maximum() {
    if (_root == null) {
      throw StateError('Tree is empty');
    }
    _Node<T>? node = _root;
    while (node?.right != null) {
      node = node!.right;
    }
    return node!.data;
  }

  void remove(T value) {
    _root = _remove(_root, value);
    if (_root != null) {
      _length--;
    }
  }

  _Node<T>? _remove(_Node<T>? node, T value) {
    if (node == null) {
      return null;
    } else if (value.compareTo(node.data) < 0) {
      node.left = _remove(node.left, value);
    } else if (value.compareTo(node.data) > 0) {
      node.right = _remove(node.right, value);
    } else {
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      } else {
        _Node<T>? minNode = _findMinNode(node.right);
        node.data = minNode!.data;
        node.right = _remove(node.right, minNode.data);
      }
    }
    return node;
  }

  _Node<T>? _findMinNode(_Node<T>? node) {
    if (node == null) {
      return null;
    } else if (node.left == null) {
      return node;
    } else {
      return _findMinNode(node.left);
    }
  }

  void clear() {
    _root = null;
  }

  void forEach(void Function(T) func) {
    var node = _root;
    if (node == null) {
      throw StateError('Tree is empty');
    }
    _forEach(node, func);
  }

  void _forEach(_Node<T>? node, void Function(T) func) {
    if (node == null) {
      return;
    }
    _forEach(node.left, func);
    func(node.data);
    _forEach(node.right, func);
  }

  @override
  String toString() {
    List<String> result = ['BinarySearchTree\n'];
    if (!isEmpty) {
      _createStrTree(result, '', _root, true);
    }
    return result.join();
  }

  void _createStrTree(
    List<String> result,
    String prefix,
    _Node<T>? node,
    bool isTail,
  ) {
    if (node?.right != null) {
      String newPrefix = prefix + (isTail ? '│   ' : '    ');
      _createStrTree(result, newPrefix, node!.right, false);
    }

    result.add('$prefix${isTail ? '└── ' : '┌── '} ${node?.data}\n');

    if (node?.left != null) {
      String newPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStrTree(result, newPrefix, node!.left, true);
    }
  }

  /// Задача 3: Фильтрация по диапазону
  /// Возвращает список всех значений в дереве, которые находятся
  /// в диапазоне от low до high (включительно).
  /// Список отсортирован по возрастанию.
  /// Оптимизация: не посещает ветки, которые заведомо не подходят под диапазон.
  List<T> getValuesBetween(T low, T high) {
    List<T> result = [];
    _getValuesBetween(_root, low, high, result);
    return result;
  }

  void _getValuesBetween(
    _Node<T>? node,
    T low,
    T high,
    List<T> result,
  ) {
    if (node == null) {
      return;
    }

    // Если значение узла больше low, проверяем левое поддерево
    if (node.data.compareTo(low) > 0) {
      _getValuesBetween(node.left, low, high, result);
    }

    // Если значение узла в диапазоне [low, high], добавляем его
    if (node.data.compareTo(low) >= 0 && node.data.compareTo(high) <= 0) {
      result.add(node.data);
    }

    // Если значение узла меньше high, проверяем правое поддерево
    if (node.data.compareTo(high) < 0) {
      _getValuesBetween(node.right, low, high, result);
    }
  }
}

void main() {
  // Тест 1: Пример из задания
  var tree1 = BinarySearchTree<int>();
  tree1.insert(10);
  tree1.insert(5);
  tree1.insert(15);
  tree1.insert(2);
  tree1.insert(7);
  tree1.insert(12);
  tree1.insert(20);
  print('Тест 1: Дерево [10, 5, 15, 2, 7, 12, 20]');
  print(tree1);
  print('getValuesBetween(6, 13): ${tree1.getValuesBetween(6, 13)}'); // Ожидается: [7, 10, 12]
  print('');

  // Тест 2: Весь диапазон
  print('Тест 2: getValuesBetween(2, 20)');
  print('Результат: ${tree1.getValuesBetween(2, 20)}'); // Ожидается: [2, 5, 7, 10, 12, 15, 20]
  print('');

  // Тест 3: Один элемент
  print('Тест 3: getValuesBetween(10, 10)');
  print('Результат: ${tree1.getValuesBetween(10, 10)}'); // Ожидается: [10]
  print('');

  // Тест 4: Нет элементов в диапазоне
  print('Тест 4: getValuesBetween(100, 200)');
  print('Результат: ${tree1.getValuesBetween(100, 200)}'); // Ожидается: []
  print('');

  // Тест 5: Частичный диапазон
  print('Тест 5: getValuesBetween(5, 12)');
  print('Результат: ${tree1.getValuesBetween(5, 12)}'); // Ожидается: [5, 7, 10, 12]
}


