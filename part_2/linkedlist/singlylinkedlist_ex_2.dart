void main() {
  var list = SinglyLinkedList.fromList([10, 20, 30, 40, 50]);
  print('Оригинальный список: $list');
  
  // Reverse the linked list
  list.reverse();
  print('Развернутый список: $list');
}

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

class SinglyLinkedList<T extends Comparable<dynamic>> extends Iterable<T> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _length = 0;

  SinglyLinkedList();

  SinglyLinkedList.fromList(List<T> list) {
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

  @override
  Iterator<T> get iterator => _SinglyLinkedListIterator<T>(this);
  
  void clear() {
    _head = null;
    _tail = null;
    _length = 0;
  }

  // Временная сложность O(n), т.к. проходим по всему списку
  // Память O(1), т.к. используем только указатели
  void reverse() {
    // Если список пустой или содержит только один 
    // элемент, ничего не делаем
    if (_head == null || _head!.next == null) {
      return;  
    }
    
    // Используем три указателя для разворота списка
    _Node<T>? previous;
    _Node<T>? current = _head;
    _Node<T>? next;
    
    // Обновляем tail - он станет текущим head
    _tail = _head;
    
    // Проходим по списку и разворачиваем связи
    while (current != null) {
      next = current.next;      // Сохраняем следующий узел
      current.next = previous;  // Разворачиваем связь
      previous = current;       // Двигаем previous вперед
      current = next;           // Двигаем current вперед
    }
    
    // Обновляем head - он теперь указывает на последний узел
    _head = previous;
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

class _SinglyLinkedListIterator<T extends Comparable<dynamic>>
    implements Iterator<T> {
  final SinglyLinkedList<T> _list;
  _Node<T>? _currentNode;
  bool _isIterationStart = true;

  _SinglyLinkedListIterator(this._list);

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
