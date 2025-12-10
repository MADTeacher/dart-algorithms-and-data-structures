// Задача 1: Создание копии списка (Метод copy)
// Уровень по таксономии Блума: Применение, Анализ.
//
// Добавьте в класс SinglyLinkedList<T> новый публичный метод copy(),
// который создает и возвращает глубокую копию (deep copy) текущего списка.

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

  // РЕАЛИЗАЦИЯ МЕТОДА copy
  /// Создает и возвращает глубокую копию (deep copy) текущего списка.
  /// Копия является совершенно независимым объектом с собственными узлами.
  SinglyLinkedList<T> copy() {
    SinglyLinkedList<T> newList = SinglyLinkedList<T>();
    
    if (_head == null) {
      return newList;
    }
    
    // Проходим по всем узлам исходного списка и создаем новые узлы
    var current = _head;
    while (current != null) {
      newList.push(current.data);
      current = current.next;
    }
    
    return newList;
  }
}

void main() {
  // Тест 1: Базовое копирование
  var listA = SinglyLinkedList<int>();
  listA.push(1);
  listA.push(2);
  listA.push(3);
  listA.push(4);
  listA.push(5);
  
  print('Исходный список A: $listA');
  var listB = listA.copy();
  print('Копия B: $listB');
  print('Длина A: ${listA.length}, Длина B: ${listB.length}');
  
  // Тест 2: Проверка независимости
  listA[0] = 99;
  print('После изменения A[0] = 99:');
  print('Список A: $listA');
  print('Список B: $listB');
  print('B[0] остался прежним: ${listB[0]}');
  
  // Тест 3: Копирование пустого списка
  var emptyList = SinglyLinkedList<int>();
  var emptyCopy = emptyList.copy();
  print('Пустой список: $emptyList');
  print('Копия пустого списка: $emptyCopy');
  print('Длина оригинала: ${emptyList.length}, Длина копии: ${emptyCopy.length}');
  
  // Тест 4: Проверка, что узлы разные
  print('A._head == B._head: ${listA._head == listB._head}'); // Должно быть false
}

