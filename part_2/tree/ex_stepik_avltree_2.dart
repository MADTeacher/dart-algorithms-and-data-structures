import 'dart:math';

/// Задача 2: "Ленивое" удаление (Lazy Deletion) с очисткой
/// Физическое удаление узла и перебалансировка — дорогая операция.
/// Используется "логическое" удаление (флаг deleted = true).
/// Если удаленных узлов становится > 50%, запускается полная перестройка дерева.

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
  bool isDeleted = false; // Флаг ленивого удаления

  _Node(this.data, {this.left, this.right});
}

class AVLTreeWithLazyDeletion<K extends Comparable<dynamic>, V>
    extends Iterable<AVLTreeEntry<K, V>> {
  _Node<AVLTreeEntry<K, V>>? _root;
  int _totalNodes = 0; // Общее количество узлов (включая удаленные)
  int _aliveNodes = 0; // Количество живых узлов

  AVLTreeWithLazyDeletion();

  int get _deletedNodes => _totalNodes - _aliveNodes;

  /// Проверяет, нужно ли выполнить перестройку дерева
  bool get _shouldRebuild => _totalNodes > 0 && _deletedNodes > _totalNodes ~/ 2;

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
    if (_shouldRebuild) {
      _rebuild();
    }
  }

  _Node<AVLTreeEntry<K, V>>? _insert(
      _Node<AVLTreeEntry<K, V>>? node, K key, V value) {
    if (node == null) {
      _totalNodes++;
      _aliveNodes++;
      return _Node<AVLTreeEntry<K, V>>(AVLTreeEntry(key, value));
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _insert(node.left, key, value);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _insert(node.right, key, value);
    } else {
      // Ключ уже существует
      if (node.isDeleted) {
        // Восстанавливаем удаленный узел
        node.isDeleted = false;
        node.data.value = value;
        _aliveNodes++;
      } else {
        // Просто обновляем значение
        node.data.value = value;
      }
    }
    return _balance(node);
  }

  void operator []=(K key, V value) {
    insert(key, value);
  }

  V? operator [](K key) {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node != null) {
      if (node.isDeleted) {
        // Пропускаем удаленные узлы при поиске
        // Нужно продолжить поиск в правильном направлении
        if (key.compareTo(node.data.key) < 0) {
          node = node.left;
        } else if (key.compareTo(node.data.key) > 0) {
          node = node.right;
        } else {
          // Найден удаленный узел
          return null;
        }
      } else if (key.compareTo(node.data.key) < 0) {
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

  /// Ленивое удаление - просто ставит флаг isDeleted = true
  void remove(K key) {
    final node = _findNode(_root, key);
    if (node != null && !node.isDeleted) {
      node.isDeleted = true;
      _aliveNodes--;
      // Высота не меняется при ленивом удалении
    }
    if (_shouldRebuild) {
      _rebuild();
    }
  }

  /// Находит узел по ключу (включая удаленные)
  _Node<AVLTreeEntry<K, V>>? _findNode(
      _Node<AVLTreeEntry<K, V>>? node, K key) {
    if (node == null) return null;
    if (key.compareTo(node.data.key) < 0) {
      return _findNode(node.left, key);
    } else if (key.compareTo(node.data.key) > 0) {
      return _findNode(node.right, key);
    } else {
      return node;
    }
  }

  /// Полная перестройка дерева - удаляет все "мертвые" узлы физически
  void _rebuild() {
    // Собираем все живые узлы
    final aliveEntries = <AVLTreeEntry<K, V>>[];
    _collectAliveNodes(_root, aliveEntries);

    // Строим новое дерево из живых узлов
    _root = null;
    _totalNodes = 0;
    _aliveNodes = 0;

    for (var entry in aliveEntries) {
      insert(entry.key, entry.value);
    }
  }

  /// Собирает все живые узлы в список
  void _collectAliveNodes(
      _Node<AVLTreeEntry<K, V>>? node, List<AVLTreeEntry<K, V>> result) {
    if (node == null) return;
    _collectAliveNodes(node.left, result);
    if (!node.isDeleted) {
      result.add(node.data);
    }
    _collectAliveNodes(node.right, result);
  }

  void clear() {
    _root = null;
    _totalNodes = 0;
    _aliveNodes = 0;
  }

  AVLTreeEntry<K, V> minimum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node != null) {
      if (node.isDeleted) {
        // Пропускаем удаленные узлы
        node = node.left ?? node.right;
      } else if (node.left != null && !node.left!.isDeleted) {
        node = node.left;
      } else {
        break;
      }
    }
    return node!.data;
  }

  AVLTreeEntry<K, V> maximum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node != null) {
      if (node.isDeleted) {
        // Пропускаем удаленные узлы
        node = node.right ?? node.left;
      } else if (node.right != null && !node.right!.isDeleted) {
        node = node.right;
      } else {
        break;
      }
    }
    return node!.data;
  }

  @override
  bool get isEmpty => _aliveNodes == 0;

  @override
  int get length => _aliveNodes;

  @override
  Iterator<AVLTreeEntry<K, V>> get iterator => _AVLTreeIterator(_root);

  /// Получает структуру дерева для проверки (включая удаленные узлы)
  /// Используется для тестирования
  Map<String, dynamic> _getTreeStructure() {
    return {
      'totalNodes': _totalNodes,
      'aliveNodes': _aliveNodes,
      'deletedNodes': _deletedNodes,
      'height': _getTreeHeight(_root),
    };
  }

  int _getTreeHeight(_Node<AVLTreeEntry<K, V>>? node) {
    if (node == null) return 0;
    return 1 + max(_getTreeHeight(node.left), _getTreeHeight(node.right));
  }

  @override
  String toString() {
    List<String> result = ['AVLTree (Lazy Deletion)\n'];
    result.add('Всего узлов: $_totalNodes, Живых: $_aliveNodes, Удаленных: $_deletedNodes\n');
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

    final marker = node?.isDeleted == true ? ' [DELETED]' : '';
    result.add('$prefix${isTail ? '└── ' : '┌── '} ${node?.data}$marker\n');

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
    while (true) {
      if (_stack.isEmpty) {
        _currentNode = null;
        return false;
      }
      _currentNode = _stack.removeLast();
      _pushLeft(_currentNode!.right);
      
      // Пропускаем удаленные узлы
      if (!_currentNode!.isDeleted) {
        return true;
      }
    }
  }

  void _pushLeft(_Node<AVLTreeEntry<K, V>>? node) {
    while (node != null) {
      _stack.add(node);
      node = node.left;
    }
  }
}

void main() {
  final tree = AVLTreeWithLazyDeletion<int, String>();

  // Вставляем 100 элементов
  print('Вставляем 100 элементов...');
  for (int i = 1; i <= 100; i++) {
    tree[i] = 'value_$i';
  }
  print('После вставки:');
  print('Всего узлов: ${tree._totalNodes}');
  print('Живых узлов: ${tree._aliveNodes}');
  print('Высота дерева: ${tree._getTreeStructure()['height']}');
  print('');

  // Удаляем 40 элементов
  print('Удаляем 40 элементов...');
  for (int i = 1; i <= 40; i++) {
    tree.remove(i);
  }
  print('После удаления 40:');
  print('Всего узлов: ${tree._totalNodes}');
  print('Живых узлов: ${tree._aliveNodes}');
  print('Удаленных узлов: ${tree._deletedNodes}');
  print('Высота дерева: ${tree._getTreeStructure()['height']}');
  print('Процент удаленных: ${(tree._deletedNodes / tree._totalNodes * 100).toStringAsFixed(1)}%');
  print('Структура дерева не изменилась (высота осталась прежней)');
  print('');

  // Удаляем еще 11 элементов (итого 51%)
  print('Удаляем еще 11 элементов (итого 51%)...');
  for (int i = 41; i <= 51; i++) {
    tree.remove(i);
  }
  print('После удаления 51:');
  print('Всего узлов: ${tree._totalNodes}');
  print('Живых узлов: ${tree._aliveNodes}');
  print('Удаленных узлов: ${tree._deletedNodes}');
  print('Высота дерева: ${tree._getTreeStructure()['height']}');
  print('Процент удаленных: ${(tree._deletedNodes / tree._totalNodes * 100).toStringAsFixed(1)}%');
  print('Дерево перестроилось (высота уменьшилась, мертвые узлы исчезли)');
  print('');

  // Проверяем содержимое
  print('Проверка содержимого:');
  print('Содержит ключ 50: ${tree.containsKey(50)} (должно быть false)');
  print('Содержит ключ 60: ${tree.containsKey(60)} (должно быть true)');
  print('Содержит ключ 100: ${tree.containsKey(100)} (должно быть true)');
  print('Количество элементов: ${tree.length} (должно быть 49)');
  print('');

  // Выводим все элементы
  print('Все элементы дерева:');
  var count = 0;
  for (var entry in tree) {
    if (count++ < 20) {
      print('${entry.key}: ${entry.value}');
    }
  }
  if (tree.length > 20) {
    print('... и еще ${tree.length - 20} элементов');
  }
}


