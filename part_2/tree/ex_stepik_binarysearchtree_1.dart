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

  /// Задача 1: Проверка на сбалансированность
  /// Дерево считается сбалансированным, если для каждого узла
  /// высота его левого и правого поддеревья отличается не более чем на 1.
  bool isBalanced() {
    return _isBalanced(_root) != -1;
  }

  /// Возвращает высоту поддерева, если оно сбалансировано, иначе -1
  int _isBalanced(_Node<T>? node) {
    if (node == null) {
      return 0;
    }

    int leftHeight = _isBalanced(node.left);
    if (leftHeight == -1) {
      return -1;
    }

    int rightHeight = _isBalanced(node.right);
    if (rightHeight == -1) {
      return -1;
    }

    if ((leftHeight - rightHeight).abs() > 1) {
      return -1;
    }

    return (leftHeight > rightHeight ? leftHeight : rightHeight) + 1;
  }
}

void main() {
  // Тест 1: Сбалансированное дерево
  var tree1 = BinarySearchTree<int>();
  tree1.insert(10);
  tree1.insert(5);
  tree1.insert(15);
  print('Тест 1: Дерево [10, 5, 15]');
  print('Сбалансировано: ${tree1.isBalanced()}'); // Ожидается: true
  print(tree1);
  print('');

  // Тест 2: Несбалансированное дерево
  var tree2 = BinarySearchTree<int>();
  tree2.insert(10);
  tree2.insert(5);
  tree2.insert(15);
  tree2.insert(3);
  tree2.insert(1);
  print('Тест 2: Дерево [10, 5, 15, 3, 1]');
  print('Сбалансировано: ${tree2.isBalanced()}'); // Ожидается: false
  print(tree2);
  print('');

  // Тест 3: Пустое дерево
  var tree3 = BinarySearchTree<int>();
  print('Тест 3: Пустое дерево');
  print('Сбалансировано: ${tree3.isBalanced()}'); // Ожидается: true
  print('');

  // Тест 4: Один элемент
  var tree4 = BinarySearchTree<int>();
  tree4.insert(10);
  print('Тест 4: Дерево [10]');
  print('Сбалансировано: ${tree4.isBalanced()}'); // Ожидается: true
}


