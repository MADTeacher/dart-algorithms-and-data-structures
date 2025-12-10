// Задача 2: Удаление K-го элемента с конца (Метод removeKthFromEnd)
// Уровень по таксономии Блума: Применение, Анализ.
//
// Добавьте в класс DoublyLinkedList<T> новый публичный метод removeKthFromEnd(int k),
// который удаляет k-й элемент, считая с конца списка, и возвращает его данные.

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

  // РЕАЛИЗАЦИЯ МЕТОДА removeKthFromEnd
  /// Удаляет k-й элемент с конца списка и возвращает его данные.
  /// k=1 соответствует последнему элементу.
  /// Использует _tail для быстрого доступа, сложность O(k).
  /// Временная сложность: O(k), где k - позиция с конца
  /// Память: O(1)
  T removeKthFromEnd(int k) {
    // Проверяем граничные случаи
    if (isEmpty) {
      throw UnsupportedError('List is empty');
    }
    
    if (k < 1 || k > _length) {
      throw RangeError.index(k, this, 'k is out of bounds. Must be between 1 and $_length');
    }

    // Начинаем с _tail и идем назад на k-1 позиций
    // k=1 означает последний элемент (_tail)
    var current = _tail;
    for (int i = 1; i < k; i++) {
      current = current!.prev;
    }

    // Сохраняем данные для возврата
    T data = current!.data;

    // Удаляем узел, обновляя связи
    if (current.prev != null) {
      // Если есть предыдущий узел
      current.prev!.next = current.next;
    } else {
      // Если это первый элемент (k == _length), обновляем _head
      _head = current.next;
    }

    if (current.next != null) {
      // Если есть следующий узел
      current.next!.prev = current.prev;
    } else {
      // Если это последний элемент (k == 1), обновляем _tail
      _tail = current.prev;
    }

    _length--;
    return data;
  }
}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = DoublyLinkedList<int>();
  listA.push(10);
  listA.push(20);
  listA.push(30);
  listA.push(40);
  listA.push(50);
  print('Исходный список A: $listA');
  
  var result1 = listA.removeKthFromEnd(1);
  print('После removeKthFromEnd(1): $listA');
  print('Удаленный элемент: $result1');
  print('_tail.data: ${listA._tail!.data}');
  print('Ожидаемый результат: [10, 20, 30, 40]');
  
  var result2 = listA.removeKthFromEnd(4);
  print('После removeKthFromEnd(4): $listA');
  print('Удаленный элемент: $result2');
  print('_head.data: ${listA._head!.data}');
  print('Ожидаемый результат: [20, 30, 40]');
  
  // Тест 2: Удаление из середины
  var listB = DoublyLinkedList<int>();
  listB.push(1);
  listB.push(2);
  listB.push(3);
  listB.push(4);
  listB.push(5);
  print('\nСписок B: $listB');
  var result3 = listB.removeKthFromEnd(3);
  print('После removeKthFromEnd(3): $listB');
  print('Удаленный элемент: $result3');
  print('Ожидаемый результат: [1, 2, 4, 5]');
  
  // Тест 3: Удаление из списка с одним элементом
  var singleList = DoublyLinkedList<int>();
  singleList.push(100);
  print('\nСписок из одного элемента: $singleList');
  var result4 = singleList.removeKthFromEnd(1);
  print('После removeKthFromEnd(1): $singleList');
  print('Удаленный элемент: $result4');
  print('Список пуст: ${singleList.isEmpty}');
  
  // Тест 4: Проверка граничных случаев (должны выбрасывать исключение)
  try {
    var emptyList = DoublyLinkedList<int>();
    emptyList.removeKthFromEnd(1);
  } catch (e) {
    print('\nОжидаемое исключение для пустого списка: $e');
  }
  
  try {
    var testList = DoublyLinkedList<int>();
    testList.push(1);
    testList.push(2);
    testList.removeKthFromEnd(0); // k < 1
  } catch (e) {
    print('Ожидаемое исключение для k=0: $e');
  }
  
  try {
    var testList = DoublyLinkedList<int>();
    testList.push(1);
    testList.push(2);
    testList.removeKthFromEnd(5); // k > length
  } catch (e) {
    print('Ожидаемое исключение для k > length: $e');
  }
}

