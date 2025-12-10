// Задача 4: Проверка на палиндром (Метод isPalindrome)
// Уровень по таксономии Блума: Анализ, Синтез.
//
// Добавьте в класс SinglyLinkedList<T> новый публичный метод isPalindrome(),
// который определяет, является ли список палиндромом.
// Решение за время O(n) и с использованием дополнительной памяти O(1).

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

  // РЕАЛИЗАЦИЯ МЕТОДА isPalindrome
  /// Определяет, является ли список палиндромом.
  /// Решение за время O(n) и с использованием дополнительной памяти O(1).
  /// Алгоритм: находим середину, переворачиваем вторую половину,
  /// сравниваем, затем восстанавливаем структуру.
  bool isPalindrome() {
    if (_head == null || _head!.next == null) {
      return true; // Пустой список или список из одного элемента - палиндром
    }
    
    // Шаг 1: Находим середину списка методом двух указателей
    var slow = _head;
    var fast = _head;
    
    while (fast!.next != null && fast.next!.next != null) {
      slow = slow!.next;
      fast = fast.next!.next;
    }
    
    // slow теперь указывает на узел перед серединой (для четного количества)
    // или на средний узел (для нечетного количества)
    
    // Шаг 2: Переворачиваем вторую половину списка
    var secondHalf = slow!.next;
    var prev = null as _Node<T>?;
    var current = secondHalf;
    
    while (current != null) {
      var next = current.next;
      current.next = prev;
      prev = current;
      current = next;
    }
    
    // Теперь prev указывает на начало перевернутой второй половины
    // Сохраняем указатель для восстановления
    var reversedHead = prev;
    
    // Шаг 3: Сравниваем первую и перевернутую вторую половины
    var firstHalf = _head;
    var isPal = true;
    
    while (prev != null && firstHalf != null) {
      if (firstHalf.data.compareTo(prev.data) != 0) {
        isPal = false;
        break;
      }
      firstHalf = firstHalf.next;
      prev = prev.next;
    }
    
    // Шаг 4: Восстанавливаем исходную структуру списка
    // Переворачиваем вторую половину обратно
    prev = null;
    current = reversedHead;
    
    while (current != null) {
      var next = current.next;
      current.next = prev;
      prev = current;
      current = next;
    }
    
    // Восстанавливаем связь между первой и второй половинами
    slow.next = prev;
    
    return isPal;
  }
}

void main() {
  // Тест 1: Палиндром с нечетным количеством элементов
  var listA = SinglyLinkedList<int>();
  listA.push(1);
  listA.push(2);
  listA.push(3);
  listA.push(2);
  listA.push(1);
  
  print('Список A: $listA');
  print('isPalindrome(): ${listA.isPalindrome()}'); // Ожидается true
  print('После проверки список A: $listA'); // Структура должна быть восстановлена
  
  // Тест 2: Палиндром с четным количеством элементов
  var listB = SinglyLinkedList<int>();
  listB.push(1);
  listB.push(2);
  listB.push(3);
  listB.push(3);
  listB.push(2);
  listB.push(1);
  
  print('\nСписок B: $listB');
  print('isPalindrome(): ${listB.isPalindrome()}'); // Ожидается true
  print('После проверки список B: $listB');
  
  // Тест 3: Не палиндром
  var listC = SinglyLinkedList<int>();
  listC.push(1);
  listC.push(2);
  listC.push(3);
  listC.push(4);
  listC.push(5);
  
  print('\nСписок C: $listC');
  print('isPalindrome(): ${listC.isPalindrome()}'); // Ожидается false
  print('После проверки список C: $listC');
  
  // Тест 4: Пустой список
  var listD = SinglyLinkedList<int>();
  print('\nПустой список D: $listD');
  print('isPalindrome(): ${listD.isPalindrome()}'); // Ожидается true
  
  // Тест 5: Список из одного элемента
  var listE = SinglyLinkedList<int>();
  listE.push(42);
  print('\nСписок из одного элемента E: $listE');
  print('isPalindrome(): ${listE.isPalindrome()}'); // Ожидается true
  
  // Тест 6: Палиндром из двух элементов
  var listF = SinglyLinkedList<int>();
  listF.push(5);
  listF.push(5);
  print('\nСписок из двух одинаковых элементов F: $listF');
  print('isPalindrome(): ${listF.isPalindrome()}'); // Ожидается true
  print('После проверки список F: $listF');
}

