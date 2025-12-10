// Задача 4: Циклический сдвиг (Метод rotate)
// Уровень по таксономии Блума: Анализ, Синтез.
//
// Добавьте в класс DoublyLinkedList<T> новый публичный метод rotate(int k),
// который выполняет циклический сдвиг списка вправо на k позиций.

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

  // РЕАЛИЗАЦИЯ МЕТОДА rotate
  /// Выполняет циклический сдвиг списка вправо на k позиций.
  /// Сдвиг выполняется in-place путем манипулирования указателями.
  /// Если k больше длины списка, берется k % length.
  /// Временная сложность: O(n), где n - длина списка
  /// Память: O(1)
  void rotate(int k) {
    // Обрабатываем граничные случаи
    if (isEmpty || length <= 1) {
      return;
    }

    // Берем k по модулю длины списка
    k = k % _length;
    
    // Если k == 0 или k == length, сдвиг не нужен
    if (k == 0) {
      return;
    }

    // Находим новый хвост (элемент, который станет последним после сдвига)
    // Новый хвост находится на позиции (length - k - 1) от начала
    // или на позиции k от конца
    int newTailIndex = _length - k - 1;
    var newTail = _getNodeAt(newTailIndex);
    var newHead = newTail!.next; // Новый head - это следующий после newTail

    // Сначала соединяем старый хвост с старым головой (делаем список циклическим)
    // Это нужно сделать до разрыва связи между newTail и newHead
    _tail!.next = _head;
    _head!.prev = _tail;

    // Теперь разрываем связь между newTail и newHead
    // Это разрывает цикл в нужном месте
    newTail.next = null;
    newHead!.prev = null;

    // Обновляем _head и _tail
    _head = newHead;
    _tail = newTail;
  }
}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = DoublyLinkedList<int>();
  listA.push(1);
  listA.push(2);
  listA.push(3);
  listA.push(4);
  listA.push(5);
  print('Исходный список A: $listA');
  
  listA.rotate(2);
  print('После rotate(2): $listA');
  print('Ожидаемый результат: [4, 5, 1, 2, 3]');
  print('_head.data: ${listA._head!.data} (должно быть 4)');
  print('_tail.data: ${listA._tail!.data} (должно быть 3)');
  
  // Тест 2: k больше длины списка
  var listB = DoublyLinkedList<int>();
  listB.push(1);
  listB.push(2);
  listB.push(3);
  listB.push(4);
  listB.push(5);
  print('\nИсходный список B: $listB');
  listB.rotate(7); // 7 % 5 = 2, эквивалентно rotate(2)
  print('После rotate(7): $listB');
  print('Ожидаемый результат: [4, 5, 1, 2, 3] (эквивалентно rotate(2))');
  print('_head.data: ${listB._head!.data} (должно быть 4)');
  print('_tail.data: ${listB._tail!.data} (должно быть 3)');
  
  // Тест 3: k равно длине списка (k % length == 0)
  var listC = DoublyLinkedList<int>();
  listC.push(1);
  listC.push(2);
  listC.push(3);
  print('\nИсходный список C: $listC');
  var headBefore = listC._head;
  var tailBefore = listC._tail;
  listC.rotate(3); // 3 % 3 = 0, список не должен измениться
  print('После rotate(3): $listC');
  print('Ожидаемый результат: [1, 2, 3] (без изменений)');
  print('_head == headBefore: ${listC._head == headBefore} (должно быть true)');
  print('_tail == tailBefore: ${listC._tail == tailBefore} (должно быть true)');
  
  // Тест 4: rotate(1) - сдвиг на одну позицию
  var listD = DoublyLinkedList<int>();
  listD.push(10);
  listD.push(20);
  listD.push(30);
  print('\nИсходный список D: $listD');
  listD.rotate(1);
  print('После rotate(1): $listD');
  print('Ожидаемый результат: [30, 10, 20]');
  print('_head.data: ${listD._head!.data} (должно быть 30)');
  print('_tail.data: ${listD._tail!.data} (должно быть 20)');
  
  // Тест 5: Список из одного элемента
  var singleList = DoublyLinkedList<int>();
  singleList.push(100);
  print('\nСписок из одного элемента: $singleList');
  singleList.rotate(5);
  print('После rotate(5): $singleList');
  print('Ожидаемый результат: [100] (без изменений)');
  
  // Тест 6: Пустой список
  var emptyList = DoublyLinkedList<int>();
  print('\nПустой список: $emptyList');
  emptyList.rotate(10);
  print('После rotate(10): $emptyList');
  print('Список остался пустым: ${emptyList.isEmpty} (должно быть true)');
  
  // Тест 7: Отрицательный k (будет обработан как положительный после модуля)
  var listE = DoublyLinkedList<int>();
  listE.push(1);
  listE.push(2);
  listE.push(3);
  print('\nИсходный список E: $listE');
  // Для отрицательного k нужно взять модуль, но в задании не указано,
  // поэтому просто проверим, что метод работает с k=0
  listE.rotate(0);
  print('После rotate(0): $listE');
  print('Ожидаемый результат: [1, 2, 3] (без изменений)');
}

