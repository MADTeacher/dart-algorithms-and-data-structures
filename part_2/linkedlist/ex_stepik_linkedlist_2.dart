// Задача 2: Разделение списка на две части (Метод splitAt)
// Уровень по таксономии Блума: Синтез, Применение.
//
// Добавьте в класс SinglyLinkedList<T> новый публичный метод splitAt(int index),
// который разделяет текущий список на два отдельных списка в указанной позиции.

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

  // РЕАЛИЗАЦИЯ МЕТОДА splitAt
  /// Разделяет текущий список на два отдельных списка в указанной позиции.
  /// Список-источник содержит элементы до указанного индекса.
  /// Возвращает новый список, который содержит элементы от указанного индекса до конца.
  SinglyLinkedList<T> splitAt(int index) {
    if (index < 0 || index > _length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    
    SinglyLinkedList<T> secondList = SinglyLinkedList<T>();
    
    // Граничные случаи
    if (index == 0) {
      // Весь список уходит во второй список
      secondList._head = _head;
      secondList._tail = _tail;
      secondList._length = _length;
      
      _head = null;
      _tail = null;
      _length = 0;
      
      return secondList;
    }
    
    if (index == _length) {
      // Второй список пустой
      return secondList;
    }
    
    // Находим узел перед точкой разделения
    var prevNode = _getNodeAt(index - 1);
    var splitNode = prevNode!.next;
    
    // Создаем второй список, начиная с splitNode
    secondList._head = splitNode;
    secondList._tail = _tail;
    
    // Подсчитываем длину второго списка
    int secondLength = 0;
    var current = splitNode;
    while (current != null) {
      secondLength++;
      current = current.next;
    }
    secondList._length = secondLength;
    
    // Обновляем первый список
    prevNode.next = null; // Разрываем связь
    _tail = prevNode;
    _length = index;
    
    return secondList;
  }
}

void main() {
  // Тест 1: Базовое разделение
  var listA = SinglyLinkedList<int>();
  listA.push(1);
  listA.push(2);
  listA.push(3);
  listA.push(4);
  listA.push(5);
  listA.push(6);
  
  print('Исходный список A: $listA');
  var listB = listA.splitAt(3);
  print('После splitAt(3):');
  print('Список A: $listA (длина: ${listA.length})');
  print('Список B: $listB (длина: ${listB.length})');
  
  // Тест 2: Разделение в начале (index = 0)
  var listC = SinglyLinkedList<int>();
  listC.push(10);
  listC.push(20);
  listC.push(30);
  print('\nИсходный список C: $listC');
  var listD = listC.splitAt(0);
  print('После splitAt(0):');
  print('Список C: $listC (длина: ${listC.length})');
  print('Список D: $listD (длина: ${listD.length})');
  
  // Тест 3: Разделение в конце (index = length)
  var listE = SinglyLinkedList<int>();
  listE.push(100);
  listE.push(200);
  listE.push(300);
  print('\nИсходный список E: $listE');
  var listF = listE.splitAt(3);
  print('После splitAt(3):');
  print('Список E: $listE (длина: ${listE.length})');
  print('Список F: $listF (длина: ${listF.length})');
  
  // Тест 4: Проверка связи
  print('\nПроверка связей:');
  print('A._tail.next == null: ${listA._tail?.next == null}');
  print('B._head.data == 4: ${listB._head?.data == 4}');
}

