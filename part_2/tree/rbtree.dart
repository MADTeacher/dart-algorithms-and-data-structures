import 'dart:math';

enum _Color { red, black }

abstract class IKey {
  int get key;
}

/************* Node  ****************/
class _Node<T extends IKey> {
  T data;
  _Node<T>? parent;
  _Node<T>? left;
  _Node<T>? right;
  _Color color;

  _Node(
    this.data, {
    this.parent,
    this.left,
    this.right,
    this.color = _Color.red,
  });

  int get key => data.key;
  // Возвращаем деда узла
  _Node<T>? get grandparent => parent?.parent;
  // Возвращаем дядю узла
  _Node<T>? get uncle => parent?.sibling;
  // Возвращаем брата узла
  _Node<T>? get sibling {
    if (parent == null) return null;
    if (this == parent?.left) return parent?.right;
    return parent?.left;
  }
}

/************* Worker  ****************/
class Worker implements IKey {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  int get key => id;

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

/************* RBTree  ****************/
class RBTree<T extends IKey> {
  _Node<T>? _root;
  bool get isEmpty => _root == null;

  // Возвращаем цвет узла
  _Color _getNodeColor(_Node<T>? node) {
    return node?.color ?? _Color.black;
  }

  // Заменяем узел
  void _replaceNode(_Node<T> oldNode, _Node<T>? newNode) {
    if (oldNode.parent == null) {
      _root = newNode;
    } else {
      if (oldNode == oldNode.parent?.left) {
        oldNode.parent?.left = newNode;
      } else {
        oldNode.parent?.right = newNode;
      }
    }
    if (newNode != null) {
      newNode.parent = oldNode.parent;
    }
  }

  // Поворачиваем узел влево
  void _rotateLeft(_Node<T> node) {
    final right = node.right!;
    _replaceNode(node, right);
    node.right = right.left;
    if (right.left != null) {
      right.left!.parent = node;
    }
    right.left = node;
    node.parent = right;
  }

  // Поворачиваем узел вправо
  void _rotateRight(_Node<T> node) {
    final left = node.left!;
    _replaceNode(node, left);
    node.left = left.right;
    if (left.right != null) {
      left.right!.parent = node;
    }
    left.right = node;
    node.parent = left;
  }

  // Добавляем узел в дерево
  void insert(T value) {
    _Node<T> newNode;
    if (_root == null) {
      // Корень всегда черный
      _root = _Node(value, color: _Color.black);
      return;
    } else {
      var current = _root;
      final insertNode = _Node(value, color: _Color.red);
      while (true) {
        if (insertNode.key == current!.key) {
          current.data = value; // Обновляем значение
          return;
        }
        if (insertNode.key < current.key) {
          if (current.left == null) {
            current.left = insertNode;
            newNode = current.left!;
            break;
          } else {
            current = current.left;
          }
        } else {
          // insertNode.key > current.key
          if (current.right == null) {
            current.right = insertNode;
            newNode = current.right!;
            break;
          } else {
            current = current.right;
          }
        }
      }
      newNode.parent = current;
    }
    _insertCase1(newNode);
  }

  // Обрабатываем первый случай при добавлении узла
  void _insertCase1(_Node<T> node) {
    if (node.parent == null) {
      node.color = _Color.black;
    } else {
      _insertCase2(node);
    }
  }

  // Обрабатываем второй случай при добавлении узла
  void _insertCase2(_Node<T> node) {
    if (_getNodeColor(node.parent) == _Color.black) {
      return; // Дерево сбалансировано
    }
    _insertCase3(node);
  }

  // Обрабатываем третий случай при добавлении узла
  void _insertCase3(_Node<T> node) {
    final uncle = node.uncle;
    if (_getNodeColor(uncle) == _Color.red) {
      node.parent!.color = _Color.black;
      uncle!.color = _Color.black;
      node.grandparent!.color = _Color.red;
      _insertCase1(node.grandparent!);
    } else {
      _insertCase4(node);
    }
  }

  // Обрабатываем четвертый случай при добавлении узла
  void _insertCase4(_Node<T> node) {
    var grandfather = node.grandparent!;
    var current = node;
    if (current == current.parent?.right &&
        current.parent == grandfather.left) {
      _rotateLeft(current.parent!);
      current = current.left!;
    } else if (current == current.parent?.left &&
        current.parent == grandfather.right) {
      _rotateRight(current.parent!);
      current = current.right!;
    }
    _insertCase5(current);
  }

  // Обрабатываем пятый случай при добавлении узла
  void _insertCase5(_Node<T> node) {
    node.parent!.color = _Color.black;
    final grandfather = node.grandparent!;
    grandfather.color = _Color.red;
    if (node == node.parent?.left && node.parent == grandfather.left) {
      _rotateRight(grandfather);
    } else {
      // node == node.parent?.right && node.parent == grandfather.right
      _rotateLeft(grandfather);
    }
  }

  // Поиск узла по ключу
  _Node<T>? _findNode(int key) {
    var current = _root;
    while (current != null && current.key != key) {
      if (key < current.key) {
        current = current.left;
      } else {
        current = current.right;
      }
    }
    return current;
  }

  // Поиск левого максимального узла
  _Node<T> _findLeftMaximumNode(_Node<T> node) {
    var current = node.left!;
    while (current.right != null) {
      current = current.right!;
    }
    return current;
  }

  // Метод удаления узла из дерева по его ключу
  void remove(int key) {
    var removingNode = _findNode(key);
    if (removingNode == null) {
      return; // Ключ не найден
    }

    if (removingNode.left != null && removingNode.right != null) {
      final successor = _findLeftMaximumNode(removingNode);
      removingNode.data = successor.data;
      removingNode = successor;
    }

    final childNode = removingNode.right ?? removingNode.left;
    if (_getNodeColor(removingNode) == _Color.black) {
      removingNode.color = _getNodeColor(childNode);
      _deleteCase1(removingNode);
    }
    _replaceNode(removingNode, childNode);

    if (removingNode.parent == null && childNode != null) {
      childNode.color = _Color.black;
    }
  }

  // Обрабатываем первый случай при удалении узла
  void _deleteCase1(_Node<T> node) {
    if (node.parent != null) {
      _deleteCase2(node);
    }
  }

  // Обрабатываем второй случай при удалении узла
  void _deleteCase2(_Node<T> node) {
    var sibling = node.sibling;
    if (_getNodeColor(sibling) == _Color.red) {
      node.parent!.color = _Color.red;
      sibling!.color = _Color.black;
      if (node == node.parent?.left) {
        _rotateLeft(node.parent!);
      } else {
        _rotateRight(node.parent!);
      }
    }
    _deleteCase3(node);
  }

  // Обрабатываем третий случай при удалении узла
  void _deleteCase3(_Node<T> node) {
    var sibling = node.sibling;
    if (_getNodeColor(node.parent) == _Color.black &&
        _getNodeColor(sibling) == _Color.black &&
        _getNodeColor(sibling?.left) == _Color.black &&
        _getNodeColor(sibling?.right) == _Color.black) {
      sibling?.color = _Color.red;
      _deleteCase1(node.parent!);
    } else {
      _deleteCase4(node);
    }
  }

  // Обрабатываем четвертый случай при удалении узла
  void _deleteCase4(_Node<T> node) {
    var sibling = node.sibling;
    if (_getNodeColor(node.parent) == _Color.red &&
        _getNodeColor(sibling) == _Color.black &&
        _getNodeColor(sibling?.left) == _Color.black &&
        _getNodeColor(sibling?.right) == _Color.black) {
      sibling?.color = _Color.red;
      node.parent!.color = _Color.black;
    } else {
      _deleteCase5(node);
    }
  }

  // Обрабатываем пятый случай при удалении узла
  void _deleteCase5(_Node<T> node) {
    var sibling = node.sibling!;
    if (node == node.parent?.left &&
        _getNodeColor(sibling) == _Color.black &&
        _getNodeColor(sibling.left) == _Color.red &&
        _getNodeColor(sibling.right) == _Color.black) {
      sibling.color = _Color.red;
      sibling.left!.color = _Color.black;
      _rotateRight(sibling);
    } else if (node == node.parent?.right &&
        _getNodeColor(sibling) == _Color.black &&
        _getNodeColor(sibling.right) == _Color.red &&
        _getNodeColor(sibling.left) == _Color.black) {
      sibling.color = _Color.red;
      sibling.right!.color = _Color.black;
      _rotateLeft(sibling);
    }
    _deleteCase6(node);
  }

  // Обрабатываем шестой случай при удалении узла
  void _deleteCase6(_Node<T> node) {
    var sibling = node.sibling!;
    sibling.color = _getNodeColor(node.parent);
    node.parent!.color = _Color.black;
    if (node == node.parent?.left) {
      if (_getNodeColor(sibling.right) == _Color.red) {
        sibling.right!.color = _Color.black;
        _rotateLeft(node.parent!);
      }
    } else {
      // node == node.parent.right
      if (_getNodeColor(sibling.left) == _Color.red) {
        sibling.left!.color = _Color.black;
        _rotateRight(node.parent!);
      }
    }
  }

  T find(int key) {
    final node = _findNode(key);
    if (node == null) {
      throw Exception('Key not found');
    }
    return node.data;
  }

  void symmetricTraversal(void Function(T data) action) {
    print('Symmetric traversal: ');
    _symmetricTraversal(_root, action);
    print('');
  }

  void _symmetricTraversal(_Node<T>? localRoot, void Function(T data) action) {
    if (localRoot != null) {
      _symmetricTraversal(localRoot.left, action);
      action(localRoot.data);
      _symmetricTraversal(localRoot.right, action);
    }
  }

  T minimum() {
    if (_root == null) throw Exception('Tree is empty');
    var current = _root!;
    while (current.left != null) {
      current = current.left!;
    }
    return current.data;
  }

  T maximum() {
    if (_root == null) throw Exception('Tree is empty');
    var current = _root!;
    while (current.right != null) {
      current = current.right!;
    }
    return current.data;
  }

  void printTree() {
    if (_root == null) {
      print('RBTree is empty');
      return;
    }
    final buffer = StringBuffer('RBTree\n');
    _createStringTree(buffer, '', _root, true);
    print(buffer.toString());
  }

  void _createStringTree(
    StringBuffer buffer,
    String prefix,
    _Node<T>? node,
    bool isTail,
  ) {
    if (node == null) return;
    if (node.right != null) {
      final newPrefix = prefix + (isTail ? '│   ' : '    ');
      _createStringTree(buffer, newPrefix, node.right, false);
    }
    buffer.write(prefix);
    buffer.write(isTail ? '└── ' : '┌── ');
    final color = node.color == _Color.red ? 'R' : 'B';
    buffer.write('${node.key} ($color)\n');
    if (node.left != null) {
      final newPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStringTree(buffer, newPrefix, node.left, true);
    }
  }
}

void main() {
  final workers = <Worker>[
    Worker('Max', 83),
    Worker('Alex', 58),
    Worker('Tom', 98),
    Worker('Tommy', 62),
    Worker('Max', 70),
    Worker('Alex', 34),
    Worker('Tom', 22),
    Worker('Max', 60),
    Worker('Alex', 99),
    Worker('Tom', 91),
    Worker('Tommy', 94),
    Worker('Tommy', 85),
  ];

  final tree = RBTree<Worker>();

  for (final worker in workers) {
    tree.insert(worker);
    print('----------------------------');
    print('Added $worker');
    tree.printTree();
  }

  print('----- Find ------');
  try {
    final found = tree.find(62);
    print('Found key value: $found');
  } catch (e) {
    print(e);
  }

  print('----- Max key ------');
  try {
    final max = tree.maximum();
    print('Max key value: $max');
  } catch (e) {
    print(e);
  }

  print('----- Min key ------');
  try {
    final min = tree.minimum();
    print('Min key value: $min');
  } catch (e) {
    print(e);
  }

  print('----- Remove ------');
  final random = Random();
  final removingWorker = workers[random.nextInt(workers.length)];
  print('Remove node with key: ${removingWorker.key}');
  tree.remove(removingWorker.key);
  tree.printTree();

  // A more Dart-idiomatic way to show traversal:
  final List<int> orderedKeys = [];
  tree.symmetricTraversal((worker) => orderedKeys.add(worker.key));
  print('Symmetric traversal keys: ${orderedKeys.join(' ')}');
}
