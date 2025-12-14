import 'dart:math';

/// Задача 3: Set Difference (Вычитание множеств)
/// Реализует операцию A - B (вернуть дерево, содержащее элементы A, которых нет в B).
/// Оптимизированное решение использует рекурсивный обход обоих деревьев параллельно.
/// Сложность: O(N + M) вместо O(M log N) при наивном подходе.

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

class AVLTreeWithRemoveAll<K extends Comparable<dynamic>, V>
    extends Iterable<AVLTreeEntry<K, V>> {
  _Node<AVLTreeEntry<K, V>>? _root;

  AVLTreeWithRemoveAll();

  /// Удаляет все элементы, которые присутствуют в other
  /// Оптимизированная версия с параллельным обходом обоих деревьев
  void removeAll(AVLTreeWithRemoveAll<K, V> other) {
    _root = _removeAllRecursive(_root, other._root);
  }

  /// Рекурсивное удаление элементов из текущего дерева,
  /// которые присутствуют в other дереве
  _Node<AVLTreeEntry<K, V>>? _removeAllRecursive(
    _Node<AVLTreeEntry<K, V>>? thisNode,
    _Node<AVLTreeEntry<K, V>>? otherNode,
  ) {
    if (thisNode == null) return null;
    if (otherNode == null) return thisNode; // Нет элементов для удаления

    // Оптимизация: если все поддерево other меньше минимального узла this,
    // то пропускаем его целиком
    final thisMin = _minNode(thisNode);
    if (thisMin != null && otherNode.data.key.compareTo(thisMin.data.key) < 0) {
      // other полностью меньше this - пропускаем правое поддерево other
      return _removeAllRecursive(thisNode, otherNode.right);
    }

    // Оптимизация: если все поддерево other больше максимального узла this,
    // то пропускаем его целиком
    final thisMax = _maxNode(thisNode);
    if (thisMax != null && otherNode.data.key.compareTo(thisMax.data.key) > 0) {
      // other полностью больше this - пропускаем левое поддерево other
      return _removeAllRecursive(thisNode, otherNode.left);
    }

    // Рекурсивно обрабатываем поддеревья
    thisNode.left = _removeAllRecursive(thisNode.left, otherNode);
    thisNode.right = _removeAllRecursive(thisNode.right, otherNode);

    // Проверяем, нужно ли удалить текущий узел
    if (_containsKey(otherNode, thisNode.data.key)) {
      // Удаляем текущий узел
      return _removeNode(thisNode);
    }

    return _balance(thisNode);
  }

  /// Проверяет, содержит ли дерево с корнем node ключ key
  bool _containsKey(_Node<AVLTreeEntry<K, V>>? node, K key) {
    while (node != null) {
      final cmp = key.compareTo(node.data.key);
      if (cmp < 0) {
        node = node.left;
      } else if (cmp > 0) {
        node = node.right;
      } else {
        return true;
      }
    }
    return false;
  }

  /// Удаляет узел из дерева
  _Node<AVLTreeEntry<K, V>>? _removeNode(_Node<AVLTreeEntry<K, V>>? node) {
    if (node == null) return null;
    if (node.left == null) {
      return node.right;
    } else if (node.right == null) {
      return node.left;
    } else {
      // Узел имеет оба поддерева
      final minRight = _minNode(node.right);
      node.data = minRight!.data;
      node.right = _remove(node.right, node.data.key);
      return _balance(node);
    }
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

  _Node<AVLTreeEntry<K, V>>? _maxNode(_Node<AVLTreeEntry<K, V>>? node) {
    if (node?.right == null) {
      return node;
    }
    return _maxNode(node?.right);
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
  // Тест: Tree A: числа от 1 до 100
  final treeA = AVLTreeWithRemoveAll<int, String>();
  print('Создаем дерево A с числами от 1 до 100...');
  for (int i = 1; i <= 100; i++) {
    treeA[i] = 'value_$i';
  }
  print('Дерево A: ${treeA.length} элементов');
  print('Валидное AVL: ${treeA._isValidAVL()}');
  print('');

  // Tree B: числа от 20 до 80
  final treeB = AVLTreeWithRemoveAll<int, String>();
  print('Создаем дерево B с числами от 20 до 80...');
  for (int i = 20; i <= 80; i++) {
    treeB[i] = 'value_$i';
  }
  print('Дерево B: ${treeB.length} элементов');
  print('');

  // Выполняем A.removeAll(B)
  print('Выполняем A.removeAll(B)...');
  treeA.removeAll(treeB);
  print('После removeAll:');
  print('Дерево A: ${treeA.length} элементов');
  print('Валидное AVL: ${treeA._isValidAVL()}');
  print('');

  // Проверяем результат: должны остаться 1..19 и 81..100
  print('Проверка результата:');
  print('Ожидается: элементы 1..19 и 81..100');
  
  // Проверяем, что элементы 1..19 присутствуют
  bool allPresent = true;
  for (int i = 1; i <= 19; i++) {
    if (!treeA.containsKey(i)) {
      print('ОШИБКА: элемент $i отсутствует');
      allPresent = false;
    }
  }
  print('Элементы 1..19 присутствуют: $allPresent');

  // Проверяем, что элементы 20..80 отсутствуют
  bool allAbsent = true;
  for (int i = 20; i <= 80; i++) {
    if (treeA.containsKey(i)) {
      print('ОШИБКА: элемент $i присутствует (должен быть удален)');
      allAbsent = false;
    }
  }
  print('Элементы 20..80 отсутствуют: $allAbsent');

  // Проверяем, что элементы 81..100 присутствуют
  allPresent = true;
  for (int i = 81; i <= 100; i++) {
    if (!treeA.containsKey(i)) {
      print('ОШИБКА: элемент $i отсутствует');
      allPresent = false;
    }
  }
  print('Элементы 81..100 присутствуют: $allPresent');
  print('');

  // Выводим все элементы дерева A
  print('Все элементы дерева A после removeAll:');
  var count = 0;
  for (var entry in treeA) {
    if (count++ < 30) {
      print('${entry.key}: ${entry.value}');
    }
  }
  if (treeA.length > 30) {
    print('... и еще ${treeA.length - 30} элементов');
  }
  print('');

  // Проверяем корректность структуры
  print('Проверка структуры дерева:');
  print('Количество элементов: ${treeA.length} (ожидается 39)');
  print('Минимальный элемент: ${treeA.minimum().key} (ожидается 1)');
  print('Максимальный элемент: ${treeA.maximum().key} (ожидается 100)');
  print('Валидное AVL-дерево: ${treeA._isValidAVL()}');
}


