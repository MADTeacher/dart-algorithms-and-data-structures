// Задача 3: Поиск K-го узла с конца (Метод getKthFromEnd)
// Уровень по таксономии Блума: Анализ, Применение.
//
// Добавьте в класс SinglyLinkedList<T> новый публичный метод getKthFromEnd(int k),
// который возвращает данные k-го узла, считая с конца списка.
// Используется метод двух указателей (Two-Pointer Technique).

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

class SinglyLinkedList<T extends Comparable<dynamic>> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _length = 0;

  SinglyLinkedList();

  SinglyLinkedList.from(Iterable<T> list) {
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
      _tail!.next = _Node(data);
      _tail = _tail!.next;
    }
    _length++;
  }

  void pushToHead(T data) {
    if (_head == null) {
      _head = _Node(data);
      _tail = _head;
    } else {
      _head = _Node(data, next: _head);
    }
    _length++;
  }

  T pop() {
    if (_tail == null) {
      throw UnsupportedError('List is empty');
    }
    var value = _tail!.data;
    _tail = _tail!.next;
    _length--;
    return value;
  }

  T popFromHead() {
    if (_head == null) {
      throw UnsupportedError('List is empty');
    }
    var value = _head!.data;
    _head = _head!.next;
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
      RangeError.index(index, this, 'Index out of bounds');
    }

    if (index == 0) {
      _head = _head!.next;
    } else {
      var current = _getNodeAt(index - 1);
      current!.next = current.next!.next;
    }
    _length--;
  }

  void insert(T data, int index) {
    if (index < 0 || index > _length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }

    var newNode = _Node(data);
    if (index == 0) {
      pushToHead(data);
    } else if (index == _length) {
      push(data);
    } else {
      var prevNode = _getNodeAt(index - 1);
      newNode.next = prevNode!.next;
      prevNode.next = newNode;
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
      RangeError.index(index, this, 'Index out of bounds');
    }
    var current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    return current;
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

  // РЕАЛИЗАЦИЯ МЕТОДА getKthFromEnd
  /// Возвращает данные k-го узла, считая с конца списка.
  /// k=1 соответствует последнему элементу, k=2 – предпоследнему и т.д.
  /// Используется метод двух указателей (Two-Pointer Technique) для решения за O(n).
  T getKthFromEnd(int k) {
    if (k < 1 || k > _length) {
      throw RangeError.index(k, this, 'k must be between 1 and length');
    }
    
    if (_head == null) {
      throw UnsupportedError('List is empty');
    }
    
    // Метод двух указателей: fast и slow
    // Сначала перемещаем fast на k позиций вперед
    var fast = _head;
    for (int i = 0; i < k; i++) {
      fast = fast!.next;
    }
    
    // Теперь перемещаем оба указателя одновременно
    // Когда fast достигнет конца, slow будет указывать на k-й элемент с конца
    var slow = _head;
    while (fast != null) {
      fast = fast.next;
      slow = slow!.next;
    }
    
    return slow!.data;
  }
}

void main() {
  // Тест 1: Базовые случаи
  var list = SinglyLinkedList<int>();
  list.push(10);
  list.push(20);
  list.push(30);
  list.push(40);
  list.push(50);
  list.push(60);
  
  print('Список: $list');
  print('getKthFromEnd(1): ${list.getKthFromEnd(1)}'); // Ожидается 60
  print('getKthFromEnd(4): ${list.getKthFromEnd(4)}'); // Ожидается 30
  print('getKthFromEnd(6): ${list.getKthFromEnd(6)}'); // Ожидается 10
  
  // Тест 2: Проверка граничных случаев
  print('\nГраничные случаи:');
  print('getKthFromEnd(2): ${list.getKthFromEnd(2)}'); // Ожидается 50
  print('getKthFromEnd(3): ${list.getKthFromEnd(3)}'); // Ожидается 40
  print('getKthFromEnd(5): ${list.getKthFromEnd(5)}'); // Ожидается 20
  
  // Тест 3: Проверка исключений
  print('\nПроверка исключений:');
  try {
    list.getKthFromEnd(7); // Должно выбросить исключение
    print('ОШИБКА: Исключение не было выброшено для k=7');
  } catch (e) {
    print('Исключение для k=7: $e');
  }
  
  try {
    list.getKthFromEnd(0); // Должно выбросить исключение
    print('ОШИБКА: Исключение не было выброшено для k=0');
  } catch (e) {
    print('Исключение для k=0: $e');
  }
  
  // Тест 4: Список из одного элемента
  var singleList = SinglyLinkedList<int>();
  singleList.push(42);
  print('\nСписок из одного элемента: $singleList');
  print('getKthFromEnd(1): ${singleList.getKthFromEnd(1)}'); // Ожидается 42
}

