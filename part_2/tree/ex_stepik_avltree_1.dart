import 'dart:math';

/// Задача 1: Разрезание дерева (Split)
/// Операция, обратная слиянию. Разделяет дерево на два:
/// treeLess (все ключи <= pivot) и treeGreater (все ключи > pivot)
/// Сложность: O(log N)

class AVLTreeEntry<K extends Comparable<dynamic>, V>
    implements Comparable<AVLTreeEntry<K, V>> {
  K key;
  V value;

  AVLTreeEntry(this.key, this.value);

  @override
  int compareTo(AVLTreeEntry<K, V> other) {
    return key.compareTo(other.key);
  }

  @override
  String toString() {
    return '{$key: $value}';
  }
}

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? left;
  _Node<T>? right;
  int height = 1;

  _Node(this.data, {this.left, this.right});
}

/// Результат операции split - два AVL-дерева
class SplitResult<K extends Comparable<dynamic>, V> {
  final AVLTreeWithSplit<K, V> treeLess; // Все ключи <= pivot
  final AVLTreeWithSplit<K, V> treeGreater; // Все ключи > pivot

  SplitResult(this.treeLess, this.treeGreater);
}

class AVLTreeWithSplit<K extends Comparable<dynamic>, V>
    extends Iterable<AVLTreeEntry<K, V>> {
  _Node<AVLTreeEntry<K, V>>? _root;

  AVLTreeWithSplit();

  /// Разрезает дерево на два по ключу pivot
  /// Сложность: O(log N)
  SplitResult<K, V> split(K pivot) {
    final result = _split(_root, pivot);
    final treeLess = AVLTreeWithSplit<K, V>();
    final treeGreater = AVLTreeWithSplit<K, V>();
    treeLess._root = result.less;
    treeGreater._root = result.greater;
    return SplitResult(treeLess, treeGreater);
  }

  /// Вспомогательная структура для рекурсивного split
  _SplitPair<K, V> _split(_Node<AVLTreeEntry<K, V>>? node, K pivot) {
    if (node == null) {
      return _SplitPair<K, V>(null, null);
    }

    final cmp = pivot.compareTo(node.data.key);
    if (cmp < 0) {
      // pivot меньше текущего узла - весь правый поддерево идет в greater
      final leftSplit = _split(node.left, pivot);
      node.left = leftSplit.greater;
      _updateNodeHeight(node);
      final balancedNode = _balance(node);
      return _SplitPair(leftSplit.less, balancedNode);
    } else if (cmp > 0) {
      // pivot больше текущего узла - весь левый поддерево идет в less
      final rightSplit = _split(node.right, pivot);
      node.right = rightSplit.less;
      _updateNodeHeight(node);
      final balancedNode = _balance(node);
      return _SplitPair(balancedNode, rightSplit.greater);
    } else {
      // pivot равен текущему узлу
      // Левый поддерево идет в less, правый - в greater
      final leftTree = node.left;
      final rightTree = node.right;
      node.left = null;
      node.right = null;
      _updateNodeHeight(node);
      
      // Узел с pivot идет в less (так как <= pivot)
      return _SplitPair<K, V>(
        _merge(leftTree, node),
        rightTree,
      );
    }
  }

  /// Сливает два дерева в одно (используется для объединения leftTree и узла)
  _Node<AVLTreeEntry<K, V>>? _merge(
    _Node<AVLTreeEntry<K, V>>? left,
    _Node<AVLTreeEntry<K, V>>? right,
  ) {
    if (left == null) return right;
    if (right == null) return left;

    // Находим максимальный узел в левом дереве
    _Node<AVLTreeEntry<K, V>>? maxNode = left;
    while (maxNode!.right != null) {
      maxNode = maxNode.right;
    }

    // Удаляем максимальный узел из левого дерева
    left = _removeMax(left);

    // Делаем максимальный узел корнем и подвешиваем деревья
    maxNode.left = left;
    maxNode.right = right;
    _updateNodeHeight(maxNode);
    return _balance(maxNode);
  }

  /// Удаляет максимальный узел из дерева
  _Node<AVLTreeEntry<K, V>>? _removeMax(_Node<AVLTreeEntry<K, V>>? node) {
    if (node == null) return null;
    if (node.right == null) {
      return node.left;
    }
    node.right = _removeMax(node.right);
    _updateNodeHeight(node);
    return _balance(node);
  }

  int _height(_Node<AVLTreeEntry<K, V>>? node) {
    return node?.height ?? 0;
  }

  int _balanceFactor(_Node<AVLTreeEntry<K, V>>? node) {
    return _height(node?.right) - _height(node?.left);
  }

  void _updateNodeHeight(_Node<AVLTreeEntry<K, V>>? node) {
    node?.height = 1 + max(_height(node.left), _height(node.right));
  }

  _Node<AVLTreeEntry<K, V>>? _rotateLeft(_Node<AVLTreeEntry<K, V>>? node) {
    final newRoot = node?.right;
    node?.right = newRoot?.left;
    newRoot?.left = node;
    _updateNodeHeight(node);
    _updateNodeHeight(newRoot);
    return newRoot;
  }

  _Node<AVLTreeEntry<K, V>>? _rotateRight(_Node<AVLTreeEntry<K, V>>? node) {
    final newRoot = node?.left;
    node?.left = newRoot?.right;
    newRoot?.right = node;
    _updateNodeHeight(node);
    _updateNodeHeight(newRoot);
    return newRoot;
  }

  _Node<AVLTreeEntry<K, V>>? _balance(_Node<AVLTreeEntry<K, V>>? node) {
    if (node == null) return null;
    _updateNodeHeight(node);
    final balance = _balanceFactor(node);
    if (balance >= 2) {
      if (_balanceFactor(node.right) < 0) {
        node.right = _rotateRight(node.right);
      }
      return _rotateLeft(node);
    } else if (balance <= -2) {
      if (_balanceFactor(node.left) > 0) {
        node.left = _rotateLeft(node.left);
      }
      return _rotateRight(node);
    }
    return node;
  }

  void insert(K key, V value) {
    _root = _insert(_root, key, value);
  }

  _Node<AVLTreeEntry<K, V>>? _insert(
      _Node<AVLTreeEntry<K, V>>? node, K key, V value) {
    if (node == null) {
      return _Node<AVLTreeEntry<K, V>>(AVLTreeEntry(key, value));
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _insert(node.left, key, value);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _insert(node.right, key, value);
    } else {
      node.data.value = value;
    }
    return _balance(node);
  }

  void operator []=(K key, V value) {
    insert(key, value);
  }

  V? operator [](K key) {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node != null) {
      if (key.compareTo(node.data.key) < 0) {
        node = node.left;
      } else if (key.compareTo(node.data.key) > 0) {
        node = node.right;
      } else {
        return node.data.value;
      }
    }
    return null;
  }

  bool containsKey(K key) {
    return this[key] != null;
  }

  void remove(K key) {
    _root = _remove(_root, key);
  }

  _Node<AVLTreeEntry<K, V>>? _remove(
    _Node<AVLTreeEntry<K, V>>? node,
    K key,
  ) {
    if (node == null) {
      return null;
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _remove(node.left, key);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _remove(node.right, key);
    } else {
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      }
      node.data = _minNode(node.right)!.data;
      node.right = _remove(node.right, node.data.key);
    }
    return _balance(node);
  }

  _Node<AVLTreeEntry<K, V>>? _minNode(_Node<AVLTreeEntry<K, V>>? node) {
    if (node?.left == null) {
      return node;
    }
    return _minNode(node?.left);
  }

  void clear() {
    _root = null;
  }

  AVLTreeEntry<K, V> minimum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node?.left != null) {
      node = node!.left;
    }
    return node!.data;
  }

  AVLTreeEntry<K, V> maximum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node?.right != null) {
      node = node!.right;
    }
    return node!.data;
  }

  @override
  bool get isEmpty => _root == null;

  @override
  int get length {
    int count = 0;
    for (var _ in this) {
      count++;
    }
    return count;
  }

  @override
  Iterator<AVLTreeEntry<K, V>> get iterator => _AVLTreeIterator(_root);

  /// Проверка валидности AVL-дерева (для тестирования)
  bool _isValidAVL() {
    return _checkBalance(_root) != -1;
  }

  int _checkBalance(_Node<AVLTreeEntry<K, V>>? node) {
    if (node == null) return 0;
    final leftHeight = _checkBalance(node.left);
    final rightHeight = _checkBalance(node.right);
    if (leftHeight == -1 || rightHeight == -1) return -1;
    if ((leftHeight - rightHeight).abs() > 1) return -1;
    if (node.height != max(leftHeight, rightHeight) + 1) return -1;
    return max(leftHeight, rightHeight) + 1;
  }

  @override
  String toString() {
    List<String> result = ['AVLTree\n'];
    if (!isEmpty) {
      _createStrTree(result, '', _root, true);
    }
    return result.join();
  }

  void _createStrTree(
    List<String> result,
    String prefix,
    _Node<AVLTreeEntry<K, V>>? node,
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
}

/// Вспомогательный класс для хранения пары деревьев при split
class _SplitPair<K extends Comparable<dynamic>, V> {
  final _Node<AVLTreeEntry<K, V>>? less;
  final _Node<AVLTreeEntry<K, V>>? greater;

  _SplitPair(this.less, this.greater);
}

class _AVLTreeIterator<K extends Comparable<dynamic>, V>
    implements Iterator<AVLTreeEntry<K, V>> {
  final List<_Node<AVLTreeEntry<K, V>>> _stack = [];
  _Node<AVLTreeEntry<K, V>>? _currentNode;

  _AVLTreeIterator(_Node<AVLTreeEntry<K, V>>? root) {
    _pushLeft(root);
  }

  @override
  AVLTreeEntry<K, V> get current => _currentNode!.data;

  @override
  bool moveNext() {
    if (_stack.isEmpty) {
      _currentNode = null;
      return false;
    }
    _currentNode = _stack.removeLast();
    _pushLeft(_currentNode!.right);
    return true;
  }

  void _pushLeft(_Node<AVLTreeEntry<K, V>>? node) {
    while (node != null) {
      _stack.add(node);
      node = node.left;
    }
  }
}

void main() {
  // Тест: создаем дерево с 100 элементами
  final tree = AVLTreeWithSplit<int, String>();
  for (int i = 1; i <= 100; i++) {
    tree[i] = 'value_$i';
  }

  print('Исходное дерево (первые 20 элементов):');
  var count = 0;
  for (var entry in tree) {
    if (count++ < 20) {
      print('${entry.key}: ${entry.value}');
    }
  }
  print('Всего элементов: ${tree.length}');
  print('Валидное AVL: ${tree._isValidAVL()}');
  print('');

  // Выполняем split(50)
  print('Выполняем split(50)...');
  final result = tree.split(50);

  print('\nДерево treeLess (ключи <= 50):');
  count = 0;
  for (var entry in result.treeLess) {
    if (count++ < 20) {
      print('${entry.key}: ${entry.value}');
    }
  }
  print('Всего элементов: ${result.treeLess.length}');
  print('Валидное AVL: ${result.treeLess._isValidAVL()}');
  
  // Проверка: все ключи <= 50
  bool allLessOrEqual = true;
  for (var entry in result.treeLess) {
    if (entry.key > 50) {
      allLessOrEqual = false;
      print('ОШИБКА: найден ключ ${entry.key} > 50');
      break;
    }
  }
  print('Все ключи <= 50: $allLessOrEqual');

  print('\nДерево treeGreater (ключи > 50):');
  count = 0;
  for (var entry in result.treeGreater) {
    if (count++ < 20) {
      print('${entry.key}: ${entry.value}');
    }
  }
  print('Всего элементов: ${result.treeGreater.length}');
  print('Валидное AVL: ${result.treeGreater._isValidAVL()}');
  
  // Проверка: все ключи > 50
  bool allGreater = true;
  for (var entry in result.treeGreater) {
    if (entry.key <= 50) {
      allGreater = false;
      print('ОШИБКА: найден ключ ${entry.key} <= 50');
      break;
    }
  }
  print('Все ключи > 50: $allGreater');

  print('\nПроверка суммы элементов:');
  print('treeLess: ${result.treeLess.length}');
  print('treeGreater: ${result.treeGreater.length}');
  print('Сумма: ${result.treeLess.length + result.treeGreater.length}');
  print('Ожидалось: 100');
}
