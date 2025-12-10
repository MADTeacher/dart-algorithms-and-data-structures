// Задача 1: Вставка в середину (Метод insertAt)
// Уровень по таксономии Блума: Применение.
//
// Добавьте в класс CyclicLinkedList<T> новый публичный метод insertAt(T data, int index),
// который вставляет новый узел с данными data по указанному index.

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? nextPtr;
  _Node<T>? prevPtr;

  _Node(this.data);
}

class CyclicLinkedList<T extends Comparable<dynamic>> {
  int _length = 0;
  _Node<T>? _head;

  CyclicLinkedList();

  CyclicLinkedList.from(Iterable<T> list) {
    for (var element in list) {
      add(element);
    }
  }

  int get size => _length;

  int get length => _length;

  bool get isEmpty => _length == 0;

  void add(T data) {
    final node = _Node(data);
    if (isEmpty) {
      node.prevPtr = node;
      node.nextPtr = node;
      _head = node;
    } else {
      node.prevPtr = _head!.prevPtr;
      node.nextPtr = _head;
      _head!.prevPtr!.nextPtr = node;
      _head!.prevPtr = node;
      _head = node;
    }
    _length++;
  }

  void forEach(void Function(T) action) {
    if (_head == null) return;

    _Node<T> node = _head!;
    action(node.data);

    for (int i = 0; i < _length - 1; i++) {
      node = node.nextPtr!;
      action(node.data);
    }
  }

  void reverseForEach(void Function(T) action) {
    if (_head == null) return;

    _Node<T> node = _head!;
    action(node.data);

    for (int i = 0; i < _length - 1; i++) {
      node = node.prevPtr!;
      action(node.data);
    }
  }

  void rotate(int delta) {
    if (_length > 0) {
      if (delta < 0) {
        final scalingCoef = (_length - 1 - delta / _length).toInt();
        delta += scalingCoef * _length;
      }
      delta %= _length;

      if (delta > _length / 2) {
        delta = _length - delta;
        for (int i = 0; i < delta; i++) {
          _head = _head!.prevPtr;
        }
      } else if (delta == 0) {
        return;
      } else {
        for (int i = 0; i < delta; i++) {
          _head = _head!.nextPtr;
        }
      }
    }
  }

  bool remove() {
    if (isEmpty) {
      return false;
    }

    final currentNode = _head;
    final nextNode = currentNode!.nextPtr;
    final prevNode = currentNode.prevPtr;

    if (_length == 1) {
      _head = null;
    } else {
      _head = nextNode;
      nextNode!.prevPtr = prevNode;
      prevNode!.nextPtr = nextNode;
    }
    _length--;

    return true;
  }

  void removeAll() {
    while (remove()) {}
  }

  T value() {
    if (isEmpty) {
      throw StateError('List is empty');
    }
    return _head!.data;
  }

  // Временная сложность: O(n) для rotate, O(1) для вставки
  // Память: O(1)
  void insertAt(T data, int index) {
    // Проверка границ
    if (index < 0 || index > _length) {
      throw RangeError('Index out of range: $index, length: $_length');
    }

    // Если вставка в конец (index == _length), используем add
    if (index == _length) {
      add(data);
      return;
    }

    // Если список пустой и index == 0, используем add
    if (isEmpty && index == 0) {
      add(data);
      return;
    }

    // Вращаем список так, чтобы _head был на позиции index
    // После rotate(index) элемент на позиции index станет _head
    rotate(index);

    // Теперь вставляем новый узел перед текущим _head
    final newNode = _Node(data);
    final prevNode = _head!.prevPtr!;
    final nextNode = _head!;

    // Устанавливаем связи нового узла
    newNode.prevPtr = prevNode;
    newNode.nextPtr = nextNode;

    // Обновляем связи соседних узлов
    prevNode.nextPtr = newNode;
    nextNode.prevPtr = newNode;

    // Обновляем _head на новый узел
    _head = newNode;
    _length++;
  }

}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = CyclicLinkedList<int>();
  listA.add(10);
  listA.add(20);
  listA.add(30);
  print('Исходный список A:');
  listA.forEach((data) => print(data));
  print('_head.data: ${listA.value()}');
  
  listA.insertAt(15, 1);
  print('\nПосле insertAt(15, 1):');
  listA.forEach((data) => print(data));
  print('_head.data: ${listA.value()}');
  
  listA.insertAt(5, 0);
  print('\nПосле insertAt(5, 0):');
  listA.forEach((data) => print(data));
  print('_head.data: ${listA.value()}');
  print('Длина списка: ${listA.length}');
  
  // Тест 2: Вставка в конец
  var listB = CyclicLinkedList<int>();
  listB.add(1);
  listB.add(2);
  print('\nСписок B:');
  listB.forEach((data) => print(data));
  listB.insertAt(3, 2);
  print('После insertAt(3, 2):');
  listB.forEach((data) => print(data));
  print('Длина: ${listB.length}');
  
  // Тест 3: Проверка исключения
  try {
    listB.insertAt(99, 10);
  } catch (e) {
    print('\nОжидаемое исключение при index > length: $e');
  }
  
  try {
    listB.insertAt(99, -1);
  } catch (e) {
    print('Ожидаемое исключение при index < 0: $e');
  }
  
  // Тест 4: Вставка в пустой список
  var emptyList = CyclicLinkedList<int>();
  emptyList.insertAt(42, 0);
  print('\nПустой список после insertAt(42, 0):');
  emptyList.forEach((data) => print(data));
  print('Длина: ${emptyList.length}');
}

