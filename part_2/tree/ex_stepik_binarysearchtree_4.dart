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
    _updateLength();
  }

  _Node<T>? _insert(_Node<T>? node, T data) {
    if (node == null) {
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

  void _updateLength() {
    _length = _countNodes(_root);
  }

  int _countNodes(_Node<T>? node) {
    if (node == null) {
      return 0;
    }
    return 1 + _countNodes(node.left) + _countNodes(node.right);
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
    _updateLength();
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
    _length = 0;
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

  /// Задача 4: Обрезка дерева (Pruning)
  /// Деструктивная операция: удаляет все узлы (и их ветви),
  /// значения которых находятся вне заданного диапазона [min, max].
  /// Метод изменяет текущую структуру дерева (_root), а не возвращает новое.
  /// Алгоритм "отцепляет" ненужные ветки целиком.
  void trim(T min, T max) {
    _root = _trim(_root, min, max);
    _updateLength();
  }

  _Node<T>? _trim(_Node<T>? node, T min, T max) {
    if (node == null) {
      return null;
    }

    // Если значение узла меньше min, то все левое поддерево тоже меньше min,
    // поэтому отбрасываем его и обрезаем правое поддерево
    if (node.data.compareTo(min) < 0) {
      return _trim(node.right, min, max);
    }

    // Если значение узла больше max, то все правое поддерево тоже больше max,
    // поэтому отбрасываем его и обрезаем левое поддерево
    if (node.data.compareTo(max) > 0) {
      return _trim(node.left, min, max);
    }

    // Если значение узла в диапазоне [min, max], сохраняем узел
    // и рекурсивно обрезаем левое и правое поддеревья
    node.left = _trim(node.left, min, max);
    node.right = _trim(node.right, min, max);
    return node;
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
  print('Тест 1: Исходное дерево [10, 5, 15, 2, 7, 12, 20]');
  print(tree1);
  print('Длина: ${tree1.length}');
  print('');

  print('Вызов trim(6, 13)');
  tree1.trim(6, 13);
  print('Дерево после обрезки:');
  print(tree1);
  print('Длина: ${tree1.length}'); // Ожидается: 3 (7, 10, 12)
  print('');

  // Проверка содержимого через forEach
  print('Элементы дерева (in-order):');
  tree1.forEach((value) => print(value));
  print('');

  // Тест 2: Обрезка до одного элемента
  var tree2 = BinarySearchTree<int>();
  tree2.insert(10);
  tree2.insert(5);
  tree2.insert(15);
  tree2.insert(2);
  tree2.insert(7);
  print('\nТест 2: Исходное дерево [10, 5, 15, 2, 7]');
  print(tree2);
  print('Вызов trim(10, 10)');
  tree2.trim(10, 10);
  print('Дерево после обрезки:');
  print(tree2);
  print('Длина: ${tree2.length}'); // Ожидается: 1
  print('');

  // Тест 3: Обрезка всего дерева (все элементы вне диапазона)
  var tree3 = BinarySearchTree<int>();
  tree3.insert(10);
  tree3.insert(5);
  tree3.insert(15);
  print('\nТест 3: Исходное дерево [10, 5, 15]');
  print(tree3);
  print('Вызов trim(100, 200)');
  tree3.trim(100, 200);
  print('Дерево после обрезки:');
  print(tree3);
  print('Длина: ${tree3.length}'); // Ожидается: 0
  print('Пустое: ${tree3.isEmpty}'); // Ожидается: true
  print('');

  // Тест 4: Обрезка не требуется (все элементы в диапазоне)
  var tree4 = BinarySearchTree<int>();
  tree4.insert(10);
  tree4.insert(5);
  tree4.insert(15);
  print('\nТест 4: Исходное дерево [10, 5, 15]');
  print(tree4);
  print('Вызов trim(1, 20)');
  tree4.trim(1, 20);
  print('Дерево после обрезки:');
  print(tree4);
  print('Длина: ${tree4.length}'); // Ожидается: 3
}


