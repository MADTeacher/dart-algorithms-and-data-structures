// Задача 3: Обмен головного и хвостового узлов (Метод swapHeadAndTail)
// Уровень по таксономии Блума: Синтез, Анализ.
//
// Добавьте в класс DoublyLinkedList<T> новый публичный метод swapHeadAndTail(),
// который меняет местами первый (_head) и последний (_tail) узлы списка.

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? next;
  _Node<T>? prev;

  _Node(this.data, {this.next, this.prev});
}

class DoublyLinkedList<T extends Comparable<dynamic>> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _length = 0;

  DoublyLinkedList();

  DoublyLinkedList.from(Iterable<T> list) {
    for (var element in list) {
      push(element);
    }
  }

  bool get isEmpty => _head == null;

  int get length => _length;

  void push(T data) {
    if (_head == null) {
      _head = _Node(data);
      _tail = _head;
    } else {
      _tail!.next = _Node(data, prev: _tail);
      _tail = _tail!.next;
    }
    _length++;
  }

  void pushToHead(T data) {
    if (_head == null) {
      _head = _Node(data);
      _tail = _head;
    } else {
      _head!.prev = _Node(data, next: _head);
      _head = _head!.prev;
    }
    _length++;
  }

  T pop() {
    if (_tail == null) {
      throw UnsupportedError('List is empty');
    }
    var value = _tail!.data;
    _tail = _tail!.prev;
    if (_tail != null) {
      _tail!.next = null;
    }
    _length--;
    return value;
  }

  T popFromHead() {
    if (_head == null) {
      throw UnsupportedError('List is empty');
    }
    var value = _head!.data;
    _head = _head!.next;
    if (_head != null) {
      _head!.prev = null;
    }
    _length--;
    return value;
  }

  void remove(T data) {
    for (int i = 0; i < _length; i++) {
      if (this[i].compareTo(data) == 0) {
        removeAt(i);
        break;
      }
    }
  }

  void removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }

    if (index == 0) {
      _head = _head!.next;
      if (_head != null) {
        _head!.prev = null;
      } else {
        _tail = null;
      }
    } else {
      var current = _getNodeAt(index);
      if (current!.next != null) {
        current.next!.prev = current.prev;
      } else {
        _tail = current.prev;
      }
      if (current.prev != null) {
        current.prev!.next = current.next;
      }
    }
    _length--;
  }

  void insert(T data, int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }

    var newNode = _Node(data);
    if (index == 0) {
      pushToHead(data);
    } else if (index == _length) {
      push(data);
    } else {
      var current = _getNodeAt(index);
      newNode.next = current;
      newNode.prev = current!.prev;
      current.prev!.next = newNode;
      current.prev = newNode;
      _length++;
    }
  }

  T operator [](int index) {
    return _getNodeAt(index)!.data;
  }

  void operator []=(int index, T value) {
    var node = _getNodeAt(index);
    node!.data = value;
  }

  _Node<T>? _getNodeAt(int index) {
    if (index < 0 || index >= _length) {
      throw IndexError.withLength(index, _length);
    }
    var current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    return current;
  }

  void reverse() {
    var current = _head;
    _Node<T>? temp;
    _tail = _head;

    while (current != null) {
      temp = current.prev;
      current.prev = current.next;
      current.next = temp;
      current = current.prev;
    }

    if (temp != null) {
      _head = temp.prev;
    }
  }

  void clear() {
    _head = null;
    _tail = null;
    _length = 0;
  }

  @override
  String toString() {
    if (_head == null) return '[]';

    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    var current = _head;
    while (current!.next != null) {
      buffer.write('${current.data}, ');
      current = current.next;
    }
    buffer.write('${current.data}]');
    return buffer.toString();
  }

  // РЕАЛИЗАЦИЯ МЕТОДА swapHeadAndTail
  /// Меняет местами первый (_head) и последний (_tail) узлы списка.
  /// Обмен выполняется манипуляцией указателями узлов, а не их данными.
  /// Временная сложность: O(1)
  /// Память: O(1)
  void swapHeadAndTail() {
    // Обрабатываем граничные случаи
    if (isEmpty || length == 1) {
      // Пустой список или список из одного элемента - ничего не делаем
      return;
    }

    // Сохраняем ссылки на узлы
    var oldHead = _head;
    var oldTail = _tail;

    // Случай: список из двух элементов
    if (length == 2) {
      // Просто меняем местами _head и _tail
      _head = oldTail;
      _tail = oldHead;
      
      // Обновляем связи
      _head!.next = oldHead;
      _head!.prev = null;
      _tail!.prev = oldTail;
      _tail!.next = null;
      
      oldHead!.next = null;
      oldHead.prev = oldTail;
    } else {
      // Случай: список из трех и более элементов
      
      // Сохраняем соседние узлы
      var headNext = oldHead!.next;
      var tailPrev = oldTail!.prev;

      // Обновляем связи для старого head
      oldHead.next = null;
      oldHead.prev = tailPrev;
      if (tailPrev != null) {
        tailPrev.next = oldHead;
      }

      // Обновляем связи для старого tail
      oldTail.prev = null;
      oldTail.next = headNext;
      if (headNext != null) {
        headNext.prev = oldTail;
      }

      // Обновляем _head и _tail
      _head = oldTail;
      _tail = oldHead;
    }
  }
}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = DoublyLinkedList<int>();
  listA.push(10);
  listA.push(20);
  listA.push(30);
  listA.push(40);
  print('Исходный список A: $listA');
  print('_head.data: ${listA._head!.data}, _tail.data: ${listA._tail!.data}');
  
  listA.swapHeadAndTail();
  print('После swapHeadAndTail(): $listA');
  print('_head.data: ${listA._head!.data}');
  print('_tail.data: ${listA._tail!.data}');
  print('Ожидаемый результат: [40, 20, 30, 10]');
  
  // Проверка связей
  print('Проверка связей:');
  print('_head.next.data: ${listA._head!.next!.data}');
  print('_head.next.prev.data: ${listA._head!.next!.prev!.data}');
  print('_tail.prev.data: ${listA._tail!.prev!.data}');
  print('_tail.prev.next.data: ${listA._tail!.prev!.next!.data}');
  
  // Тест 2: Список из двух элементов
  var listB = DoublyLinkedList<int>();
  listB.push(1);
  listB.push(2);
  print('\nСписок из двух элементов: $listB');
  listB.swapHeadAndTail();
  print('После swapHeadAndTail(): $listB');
  print('Ожидаемый результат: [2, 1]');
  print('_head.data: ${listB._head!.data}');
  print('_tail.data: ${listB._tail!.data}');
  
  // Тест 3: Список из одного элемента
  var singleList = DoublyLinkedList<int>();
  singleList.push(100);
  print('\nСписок из одного элемента: $singleList');
  var headBefore = singleList._head;
  var tailBefore = singleList._tail;
  singleList.swapHeadAndTail();
  print('После swapHeadAndTail(): $singleList');
  print('_head == headBefore: ${singleList._head == headBefore} (должно быть true)');
  print('_tail == tailBefore: ${singleList._tail == tailBefore} (должно быть true)');
  
  // Тест 4: Пустой список
  var emptyList = DoublyLinkedList<int>();
  print('\nПустой список: $emptyList');
  emptyList.swapHeadAndTail();
  print('После swapHeadAndTail(): $emptyList');
  print('Список остался пустым: ${emptyList.isEmpty} (должно быть true)');
  
  // Тест 5: Список из трех элементов
  var listC = DoublyLinkedList<int>();
  listC.push(1);
  listC.push(2);
  listC.push(3);
  print('\nСписок из трех элементов: $listC');
  listC.swapHeadAndTail();
  print('После swapHeadAndTail(): $listC');
  print('Ожидаемый результат: [3, 2, 1]');
  print('_head.data: ${listC._head!.data}');
  print('_tail.data: ${listC._tail!.data}');
}

