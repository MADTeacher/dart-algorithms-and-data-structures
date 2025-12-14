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

  /// Задача 2: Подсчет листьев
  /// Листьями называются узлы, у которых нет потомков (ни левого, ни правого).
  int getLeafCount() {
    return _getLeafCount(_root);
  }

  int _getLeafCount(_Node<T>? node) {
    if (node == null) {
      return 0;
    }

    // Если у узла нет потомков, это лист
    if (node.left == null && node.right == null) {
      return 1;
    }

    // Рекурсивно подсчитываем листья в левом и правом поддеревьях
    return _getLeafCount(node.left) + _getLeafCount(node.right);
  }
}

void main() {
  // Тест 1: Пример из задания
  var tree1 = BinarySearchTree<int>();
  tree1.insert(5);
  tree1.insert(3);
  tree1.insert(7);
  tree1.insert(2);
  tree1.insert(8);
  print('Тест 1: Дерево [5, 3, 7, 2, 8]');
  print(tree1);
  print('Количество листьев: ${tree1.getLeafCount()}'); // Ожидается: 2 (листья: 2 и 8)
  print('');

  // Тест 2: Пустое дерево
  var tree2 = BinarySearchTree<int>();
  print('Тест 2: Пустое дерево');
  print('Количество листьев: ${tree2.getLeafCount()}'); // Ожидается: 0
  print('');

  // Тест 3: Один элемент (является листом)
  var tree3 = BinarySearchTree<int>();
  tree3.insert(10);
  print('Тест 3: Дерево [10]');
  print('Количество листьев: ${tree3.getLeafCount()}'); // Ожидается: 1
  print('');

  // Тест 4: Больше элементов
  var tree4 = BinarySearchTree<int>();
  tree4.insert(10);
  tree4.insert(5);
  tree4.insert(15);
  tree4.insert(2);
  tree4.insert(7);
  tree4.insert(12);
  tree4.insert(20);
  print('Тест 4: Дерево [10, 5, 15, 2, 7, 12, 20]');
  print(tree4);
  print('Количество листьев: ${tree4.getLeafCount()}'); // Ожидается: 4 (листья: 2, 7, 12, 20)
}


