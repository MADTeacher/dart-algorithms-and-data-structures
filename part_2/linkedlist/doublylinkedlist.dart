class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? next;
  _Node<T>? prev;

  _Node(this.data, {this.next, this.prev});
}

class DoublyLinkedList<T extends Comparable<dynamic>> extends Iterable<T> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _length = 0;

  DoublyLinkedList();

  DoublyLinkedList.from(Iterable<T> list) {
    for (var element in list) {
      push(element);
    }
  }

  @override
  bool get isEmpty => _head == null;

  @override
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

  @override
  Iterator<T> get iterator => _DoublyLinkedListIterator<T>(this);

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
}

class _DoublyLinkedListIterator<T extends Comparable<dynamic>>
    implements Iterator<T> {
  final DoublyLinkedList<T> _list;
  _Node<T>? _currentNode;
  bool _isIterationStart = true;

  _DoublyLinkedListIterator(this._list);

  @override
  T get current => _currentNode!.data;

  @override
  bool moveNext() {
    if (_list.isEmpty) return false;
    if (_isIterationStart) {
      _currentNode = _list._head;
      _isIterationStart = false;
    } else {
      _currentNode = _currentNode?.next;
    }
    return _currentNode != null;
  }
}

// Временная сложность: O(n)
// Память: O(1)
extension DoublyLinkedListReverse<T extends Comparable<dynamic>>
    on DoublyLinkedList<T> {
  String toStringReverse() {
    // Обрабатываем случай пустого списка
    if (isEmpty) return '[]';

    StringBuffer buffer = StringBuffer();
    buffer.write('[');

    // Начинаем с хвоста и идем к началу, используя prev указатели
    var current = _tail;
    while (current != null && current.prev != null) {
      buffer.write('${current.data}, ');
      current = current.prev;
    }

    // Добавляем последний элемент (начало списка)
    if (current != null) {
      buffer.write('${current.data}');
    }

    buffer.write(']');
    return buffer.toString();
  }
}

// Временная сложность: O(n)
// Память: O(1)
extension DoublyLinkedListPartition<T extends Comparable<dynamic>>
    on DoublyLinkedList<T> {
  void partition(T pivot) {
    // Обрабатываем граничные случаи
    if (isEmpty || length == 1) return;

    // Создаем указатели для двух частей списка
    _Node<T>? lessHead; // Начало части с элементами < pivot
    _Node<T>? lessTail; // Хвост части с элементами < pivot
    _Node<T>? greaterHead; // Начало части с элементами >= pivot
    _Node<T>? greaterTail; // Хвост части с элементами >= pivot

    var current = _head;

    // Проходим по всему списку и разделяем узлы на две части
    while (current != null) {
      var nextNode = current.next; // Сохраняем следующий узел

      // Отсоединяем текущий узел от списка
      current.next = null;
      current.prev = null;

      if (current.data.compareTo(pivot) < 0) {
        // Элемент меньше pivot - добавляем в левую часть
        if (lessHead == null) {
          lessHead = current;
          lessTail = current;
        } else {
          lessTail!.next = current;
          current.prev = lessTail;
          lessTail = current;
        }
      } else {
        // Элемент больше или равен pivot - добавляем в правую часть
        if (greaterHead == null) {
          greaterHead = current;
          greaterTail = current;
        } else {
          greaterTail!.next = current;
          current.prev = greaterTail;
          greaterTail = current;
        }
      }

      current = nextNode;
    }

    // Соединяем две части списка
    if (lessHead == null) {
      // Если нет элементов меньше pivot
      _head = greaterHead;
      _tail = greaterTail;
    } else if (greaterHead == null) {
      // Если нет элементов больше или равных pivot
      _head = lessHead;
      _tail = lessTail;
    } else {
      // Соединяем обе части
      _head = lessHead;
      _tail = greaterTail;
      lessTail!.next = greaterHead;
      greaterHead.prev = lessTail;
    }
  }
}

// Временная сложность: O(n/2), т.к.проходим до середины списка
// Память: O(1)
extension DoublyLinkedListPalindrome<T extends Comparable<dynamic>>
    on DoublyLinkedList<T> {
  bool isPalindrome() {
    // Обрабатываем граничные случаи
    if (isEmpty || length == 1) return true;

    // Используем два указателя: один от начала, другой с конца
    var leftPointer = _head;
    var rightPointer = _tail;

    // Сравниваем элементы, двигаясь навстречу друг другу
    while (leftPointer != null &&
        rightPointer != null &&
        leftPointer != rightPointer) {
      // Если элементы не равны, список не является палиндромом
      if (leftPointer.data.compareTo(rightPointer.data) != 0) {
        return false;
      }

      // Двигаем указатели навстречу друг другу
      leftPointer = leftPointer.next;
      rightPointer = rightPointer.prev;

      // Проверяем, не пересеклись ли указатели
      // (для четного количества элементов)
      if (leftPointer == rightPointer) {
        break;
      }
    }

    return true;
  }
}

void main() {
  var list = DoublyLinkedList<int>();
  list.push(1);
  list.pushToHead(2);
  list.push(3);
  list.push(5);
  list.push(-43);
  print(list);

  list[1] = 66;
  print(list[1]);

  list.remove(3);
  print(list);

  list.removeAt(2);
  print(list);

  list.insert(4, 2);
  print(list);

  list.reverse();
  print(list);

  print(list.length);
  print(list.first);
  print(list.last);
  print(list.where((it) => it > 0).toList());
}
