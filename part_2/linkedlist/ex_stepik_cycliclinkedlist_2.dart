// Задача 2: Создание глубокой копии (Метод copy)
// Уровень по таксономии Блума: Применение, Анализ.
//
// Добавьте в класс CyclicLinkedList<T> новый публичный метод CyclicLinkedList<T> copy(),
// который создает и возвращает глубокую копию текущего списка.

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

  // Временная сложность: O(n)
  // Память: O(n)
  CyclicLinkedList<T> copy() {
    var newList = CyclicLinkedList<T>();
    if (isEmpty) return newList;

    // Проходим по всему списку и создаем новые узлы
    var current = _head;
    for (int i = 0; i < _length; i++) {
      newList.add(current!.data);
      current = current.nextPtr;
    }

    return newList;
  }

}

void main() {
  // Тест 1: Базовое копирование
  var listA = CyclicLinkedList<int>();
  listA.add(10);
  listA.add(20);
  listA.add(30);
  print('Исходный список A:');
  listA.forEach((data) => print(data));
  print('Длина A: ${listA.length}');
  
  var listB = listA.copy();
  print('\nКопия B:');
  listB.forEach((data) => print(data));
  print('Длина B: ${listB.length}');
  print('Длины равны: ${listA.length == listB.length}');
  
  // Тест 2: Проверка независимости
  print('\nПроверка независимости:');
  print('A._head == B._head: ${listA._head == listB._head}');
  
  // Изменяем список A
  listA.add(40);
  print('\nПосле добавления 40 в A:');
  print('Длина A: ${listA.length}');
  print('Длина B: ${listB.length}');
  
  // Тест 3: Проверка корректности цикла в копии
  print('\nПроверка корректности цикла в B:');
  print('B._head != null: ${listB._head != null}');
  if (listB._head != null) {
    print('B._head!.prevPtr!.nextPtr == B._head: ${listB._head!.prevPtr!.nextPtr == listB._head}');
    print('B._head!.nextPtr!.prevPtr == B._head: ${listB._head!.nextPtr!.prevPtr == listB._head}');
  }
  
  // Тест 4: Копирование пустого списка
  var emptyList = CyclicLinkedList<int>();
  var emptyCopy = emptyList.copy();
  print('\nПустой список:');
  print('Длина оригинала: ${emptyList.length}');
  print('Длина копии: ${emptyCopy.length}');
  print('Копия пустая: ${emptyCopy.isEmpty}');
  
  // Тест 5: Копирование списка с одним элементом
  var singleList = CyclicLinkedList<int>();
  singleList.add(42);
  var singleCopy = singleList.copy();
  print('\nСписок с одним элементом:');
  print('Оригинал: ${singleList.value()}');
  print('Копия: ${singleCopy.value()}');
  print('singleList._head == singleCopy._head: ${singleList._head == singleCopy._head}');
}

