class Cat implements Comparable<Cat> {
  final String name;
  final int age;

  Cat(this.name, this.age);

  @override
  int compareTo(Cat other) {
    final nameCompare = name.compareTo(other.name);
    if (nameCompare != 0) return nameCompare;
    return age.compareTo(other.age);
  }

  @override
  String toString() {
    return '{name: $name, age: $age}';
  }
}

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? nextPtr;
  _Node<T>? prevPtr;

  _Node(this.data);
}

class CyclicLinkedList<T extends Comparable<dynamic>> extends Iterable<T> {
  int _length = 0;
  _Node<T>? _head;

  CyclicLinkedList();

  CyclicLinkedList.from(Iterable<T> list) {
    for (var element in list) {
      add(element);
    }
  }

  int get size => _length;

  @override
  int get length => _length;

  @override
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

  @override
  Iterator<T> get iterator => _CyclicLinkedListIterator<T>(this);
}

class _CyclicLinkedListIterator<T extends Comparable<dynamic>>
    implements Iterator<T> {
  final CyclicLinkedList<T> _list;
  _Node<T>? _currentNode;
  int _count = 0;

  _CyclicLinkedListIterator(this._list) {
    _currentNode = _list._head;
  }

  @override
  T get current => _currentNode!.data;

  @override
  bool moveNext() {
    if (_list.isEmpty || _count >= _list.length) {
      return false;
    }

    if (_count > 0) {
      _currentNode = _currentNode!.nextPtr;
    }

    _count++;
    return true;
  }
}

// Временная сложность: O(n)
// Память: O(1)
extension CyclicLinkedListCount<T extends Comparable<dynamic>>
    on CyclicLinkedList<T> {
  int count(T element) {
    // Обрабатываем случай пустого списка
    if (isEmpty) return 0;

    int counter = 0;
    var current = _head;

    // Проходим по всему циклическому списку ровно один раз
    var startNode = current;
    do {
      if (current!.data.compareTo(element) == 0) {
        counter++;
      }
      current = current.nextPtr;
    // Если текущий узел вернулся к начальному узлу,
    // значит мы прошли весь список
    } while (current != startNode);

    return counter;
  }
}


// Временная сложность: O(n) из-за копирования,
// без копирования O(1)
// Память: O(n)
extension CyclicLinkedListMerge<T extends Comparable<dynamic>> on CyclicLinkedList<T> {
  void merge(CyclicLinkedList<T> otherList) {
    // Обрабатываем граничные случаи
    if (otherList.isEmpty) return; // Нечего объединять
    
    var other = otherList.copy();

    if (isEmpty) {
      // Если текущий список пустой, копируем другой список
      _head = other._head;
      _length = other._length;
      return;
    }
    
    // Сохраняем указатели на ключевые узлы
    var thisHead = _head!;
    // В циклическом списке tail = head.prev
    var thisTail = thisHead.prevPtr!; 
    var otherHead = other._head!;
    var otherTail = otherHead.prevPtr!;
    
    // Разрываем циклические связи в обоих списках

    // Конец первого → начало второго
    thisTail.nextPtr = otherHead;  
    // Начало второго ← конец первого
    otherHead.prevPtr = thisTail;  
    
    // Конец второго → начало первого
    otherTail.nextPtr = thisHead;  
    // Начало первого ← конец второго
    thisHead.prevPtr = otherTail;
    
    // Обновляем длину текущего списка
    _length += other._length;
  }
  
  // Метод для создания копии циклического списка
  CyclicLinkedList<T> copy() {
    var newList = CyclicLinkedList<T>();
    if (isEmpty) return newList;
    
    var current = _head;
    for (int i = 0; i < length; i++) {
      newList.add(current!.data);
      current = current.nextPtr;
    }
    
    return newList;
  }
}

void main() {
  final cLinkedList = CyclicLinkedList<Cat>();
  cLinkedList.add(Cat("Max", 4));
  cLinkedList.add(Cat("Alex", 5));
  cLinkedList.add(Cat("Tom", 7));
  cLinkedList.add(Cat("Tommy", 1));

  print("List size: ${cLinkedList.size}");

  cLinkedList.forEach((data) {
    print(data.toString());
  });

  print("--Remove data--");
  cLinkedList.remove();

  cLinkedList.forEach((data) {
    print(data.toString());
  });

  print("--Rotate--");
  try {
    final data = cLinkedList.value();
    print("Head data before rotate: ${data.toString()}");
    cLinkedList.rotate(-1);
    final newData = cLinkedList.value();
    print("Head data after rotate: ${newData.toString()}");
  } catch (e) {
    print(e);
  }

  print("--ReverseForEach--");
  cLinkedList.reverseForEach((data) {
    print(data.toString());
  });

  print("--Iterable for-in loop--");
  for (final cat in cLinkedList) {
    print(cat.toString());
  }
}
