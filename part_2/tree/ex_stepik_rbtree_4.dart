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
      // Корень всегда черный
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

  // Обрабатываем первый случай при добавлении узла
  void _insertCase1(_Node<T> node) {
    if (node.parent == null) {
      node.color = _Color.black;
    } else {
      _insertCase2(node);
    }
  }

  // Обрабатываем второй случай при добавлении узла
  void _insertCase2(_Node<T> node) {
    if (_getNodeColor(node.parent) == _Color.black) {
      return; // Дерево сбалансировано
    }
    _insertCase3(node);
  }

  // Обрабатываем третий случай при добавлении узла
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

  // Обрабатываем четвертый случай при добавлении узла
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

  // Обрабатываем пятый случай при добавлении узла
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
      return; // Ключ не найден
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

  // Обрабатываем первый случай при удалении узла
  void _deleteCase1(_Node<T> node) {
    if (node.parent != null) {
      _deleteCase2(node);
    }
  }

  // Обрабатываем второй случай при удалении узла
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

  // Обрабатываем третий случай при удалении узла
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

  // Обрабатываем четвертый случай при удалении узла
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

  // Обрабатываем пятый случай при удалении узла
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

  // Обрабатываем шестой случай при удалении узла
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

  // Задача 4: Ранг элемента (Rank)
  int getRank(int key) {
    return _countSmaller(_root, key);
  }

  int _countSmaller(_Node<T>? node, int key) {
    if (node == null) return 0;
    int count = 0;
    if (node.key < key) {
      // Текущий узел меньше ключа, считаем его и все узлы в левом поддереве
      count = 1 + _countNodes(node.left) + _countSmaller(node.right, key);
    } else {
      // Текущий узел >= ключа, идем влево
      count = _countSmaller(node.left, key);
    }
    return count;
  }

  int _countNodes(_Node<T>? node) {
    if (node == null) return 0;
    return 1 + _countNodes(node.left) + _countNodes(node.right);
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
  print('=== Задача 4: Ранг элемента (Rank) ===\n');

  final tree = RBTree<Worker>();

  // Вставить элементы: 10, 5, 15, 3, 7
  print('Вставляем элементы: 10, 5, 15, 3, 7');
  tree.insert(Worker('A', 10));
  tree.insert(Worker('B', 5));
  tree.insert(Worker('C', 15));
  tree.insert(Worker('D', 3));
  tree.insert(Worker('E', 7));
  tree.printTree();

  // Отсортированный ряд: 3, 5, 7, 10, 15
  print('\nОтсортированный ряд: 3, 5, 7, 10, 15');

  // Вызвать getRank(10) -> ожидается 3 (элементы 3, 5, 7 меньше)
  print('\n--- Тест 1: getRank(10) ---');
  final rank10 = tree.getRank(10);
  print('getRank(10) = $rank10');
  print('Ожидается: 3 (элементы 3, 5, 7 меньше)');
  assert(rank10 == 3, 'Ожидался ранг 3 для ключа 10');

  // Вызвать getRank(3) -> ожидается 0
  print('\n--- Тест 2: getRank(3) ---');
  final rank3 = tree.getRank(3);
  print('getRank(3) = $rank3');
  print('Ожидается: 0');
  assert(rank3 == 0, 'Ожидался ранг 0 для ключа 3');

  // Вызвать getRank(100) -> ожидается 5 (все элементы меньше)
  print('\n--- Тест 3: getRank(100) ---');
  final rank100 = tree.getRank(100);
  print('getRank(100) = $rank100');
  print('Ожидается: 5 (все элементы меньше)');
  assert(rank100 == 5, 'Ожидался ранг 5 для ключа 100');

  // Дополнительные тесты
  print('\n--- Дополнительные тесты ---');
  final rank5 = tree.getRank(5);
  print('getRank(5) = $rank5 (ожидается 1)');
  assert(rank5 == 1, 'Ожидался ранг 1 для ключа 5');

  final rank7 = tree.getRank(7);
  print('getRank(7) = $rank7 (ожидается 2)');
  assert(rank7 == 2, 'Ожидался ранг 2 для ключа 7');

  final rank15 = tree.getRank(15);
  print('getRank(15) = $rank15 (ожидается 4)');
  assert(rank15 == 4, 'Ожидался ранг 4 для ключа 15');

  print('\n✓ Все тесты пройдены успешно!');
}

