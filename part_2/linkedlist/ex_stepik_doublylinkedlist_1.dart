// Задача 1: Вставка узла перед заданным (Метод insertBefore)
// Уровень по таксономии Блума: Применение.
//
// Добавьте в класс DoublyLinkedList<T> новый публичный метод insertBefore(T targetData, T newData).
// Этот метод должен найти первый узел, содержащий данные targetData, и вставить новый узел
// с данными newData непосредственно перед ним.

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

  // РЕАЛИЗАЦИЯ МЕТОДА insertBefore
  /// Находит первый узел с данными targetData и вставляет новый узел с данными newData перед ним.
  /// Возвращает true, если вставка была успешной, и false, если targetData не был найден.
  /// Временная сложность: O(n)
  /// Память: O(1)
  bool insertBefore(T targetData, T newData) {
    // Если список пуст, targetData не может быть найден
    if (isEmpty) {
      return false;
    }

    // Ищем узел с targetData
    var current = _head;
    while (current != null) {
      if (current.data.compareTo(targetData) == 0) {
        // Найден узел с targetData, вставляем новый узел перед ним
        var newNode = _Node(newData);
        
        // Устанавливаем связи нового узла
        newNode.next = current;
        newNode.prev = current.prev;
        
        // Обновляем связи соседних узлов
        if (current.prev != null) {
          // Если есть предыдущий узел, обновляем его next
          current.prev!.next = newNode;
        } else {
          // Если current - это _head, обновляем _head
          _head = newNode;
        }
        
        // Обновляем prev текущего узла
        current.prev = newNode;
        
        _length++;
        return true;
      }
      current = current.next;
    }

    // targetData не найден
    return false;
  }
}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = DoublyLinkedList<int>();
  listA.push(10);
  listA.push(20);
  listA.push(30);
  print('Исходный список A: $listA');
  
  var result1 = listA.insertBefore(20, 15);
  print('После insertBefore(20, 15): $listA');
  print('Результат: $result1 (должно быть true)');
  print('_head.data: ${listA._head!.data} (должно быть 10)');
  
  var result2 = listA.insertBefore(10, 5);
  print('После insertBefore(10, 5): $listA');
  print('Результат: $result2 (должно быть true)');
  print('_head.data: ${listA._head!.data} (должно быть 5)');
  print('Ожидаемый результат: [5, 10, 15, 20, 30]');
  
  // Тест 2: Попытка вставить перед несуществующим элементом
  var result3 = listA.insertBefore(999, 100);
  print('После insertBefore(999, 100): $listA');
  print('Результат: $result3 (должно быть false)');
  
  // Тест 3: Вставка в пустой список
  var emptyList = DoublyLinkedList<int>();
  var result4 = emptyList.insertBefore(10, 5);
  print('Пустой список, insertBefore(10, 5): $result4 (должно быть false)');
  
  // Тест 4: Вставка перед первым элементом (когда он единственный)
  var singleList = DoublyLinkedList<int>();
  singleList.push(10);
  var result5 = singleList.insertBefore(10, 5);
  print('Список из одного элемента: $singleList');
  print('Результат: $result5 (должно быть true)');
  print('_head.data: ${singleList._head!.data} (должно быть 5)');
}

