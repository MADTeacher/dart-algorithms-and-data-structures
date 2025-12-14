class _Node<T> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

class SinglyLinkedQueue<T> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _size = 0;
  final int? _fixedSize;

  SinglyLinkedQueue({int? fixedSize}) : _fixedSize = fixedSize;

  bool get isEmpty => _size == 0;
  bool get isFull => _fixedSize != null && _size >= _fixedSize;
  int get size => _size;

  void enqueue(T value) {
    if (isFull) {
      throw StateError('Queue is full');
    }
    var newNode = _Node(value);
    if (isEmpty) {
      _head = _tail = newNode;
    } else {
      _tail!.next = newNode;
      _tail = newNode;
    }
    _size++;
  }

  T dequeue() {
    if (isEmpty) {
      throw StateError('Queue is empty');
    }
    var value = _head!.data;
    _head = _head!.next;
    if (_head == null) {
      _tail = null;
    }
    _size--;
    return value;
  }

  T peek() {
    if (isEmpty) {
      throw StateError('Queue is empty');
    }
    return _head!.data;
  }

  void clear() {
    _head = _tail = null;
    _size = 0;
  }

  /// Вставляет элемент в очередь по указанному индексу.
  /// Элементы справа от индекса сдвигаются вправо.
  /// Индекс может быть от 0 до size (включительно).
  /// При вставке в конец (index == size) элемент становится последним.
  /// Выбрасывает RangeError, если индекс вне диапазона [0, size].
  /// Выбрасывает StateError, если очередь полна.
  void insertAt(int index, T value) {
    if (index < 0 || index > _size) {
      throw RangeError.range(index, 0, _size, 'index', 'Index out of range');
    }

    if (isFull) {
      throw StateError('Queue is full');
    }

    var newNode = _Node(value);

    // Вставка в начало (index == 0)
    if (index == 0) {
      newNode.next = _head;
      _head = newNode;
      if (_tail == null) {
        _tail = newNode;
      }
      _size++;
      return;
    }

    // Вставка в конец (index == size)
    if (index == _size) {
      if (_tail != null) {
        _tail!.next = newNode;
        _tail = newNode;
      } else {
        _head = _tail = newNode;
      }
      _size++;
      return;
    }

    // Вставка в середину
    var current = _head;
    for (int i = 0; i < index - 1; i++) {
      current = current!.next;
    }
    newNode.next = current!.next;
    current.next = newNode;
    _size++;
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

void main() {
  print('=== Тест 1: Базовый insertAt в середину ===');
  var queue = SinglyLinkedQueue<int>(fixedSize: 6);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(4);
  print('Очередь до insertAt: $queue'); // [1, 2, 3, 4]
  queue.insertAt(2, 99);
  print('Очередь после insertAt(2, 99): $queue'); // [1, 2, 99, 3, 4]
  print('peek(): ${queue.peek()}'); // 1
  print('Размер: ${queue.size}'); // 5
  print('');

  print('=== Тест 2: insertAt в начало (index 0) ===');
  var queue2 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue2.enqueue(10);
  queue2.enqueue(20);
  queue2.enqueue(30);
  print('Очередь до insertAt: $queue2');
  queue2.insertAt(0, 100);
  print('Очередь после insertAt(0, 100): $queue2'); // [100, 10, 20, 30]
  print('peek(): ${queue2.peek()}'); // 100
  print('');

  print('=== Тест 3: insertAt в конец (index == size) ===');
  var queue3 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue3.enqueue(1);
  queue3.enqueue(2);
  queue3.enqueue(3);
  print('Очередь до insertAt: $queue3, размер: ${queue3.size}');
  queue3.insertAt(3, 999);
  print('Очередь после insertAt(3, 999): $queue3'); // [1, 2, 3, 999]
  print('');

  print('=== Тест 4: insertAt в пустую очередь ===');
  var queue4 = SinglyLinkedQueue<int>(fixedSize: 3);
  print('Пустая очередь: $queue4');
  queue4.insertAt(0, 42);
  print('После insertAt(0, 42): $queue4'); // [42]
  print('peek(): ${queue4.peek()}'); // 42
  print('Размер: ${queue4.size}'); // 1
  print('');

  print('=== Тест 5: Несколько insertAt подряд ===');
  var queue5 = SinglyLinkedQueue<int>(fixedSize: 6);
  queue5.enqueue(1);
  queue5.enqueue(2);
  print('Исходная очередь: $queue5');
  queue5.insertAt(1, 10);
  print('После insertAt(1, 10): $queue5');
  queue5.insertAt(0, 20);
  print('После insertAt(0, 20): $queue5');
  queue5.insertAt(4, 30);
  print('После insertAt(4, 30): $queue5');
  print('Размер: ${queue5.size}'); // 5
  print('');

  print('=== Тест 6: Проверка через dequeue ===');
  var queue6 = SinglyLinkedQueue<int>(fixedSize: 4);
  queue6.enqueue(1);
  queue6.enqueue(3);
  queue6.insertAt(1, 2);
  print('Очередь после insertAt(1, 2): $queue6'); // [1, 2, 3]
  print('Элементы через dequeue:');
  print('  ${queue6.dequeue()}'); // 1
  print('  ${queue6.dequeue()}'); // 2
  print('  ${queue6.dequeue()}'); // 3
  print('');

  print('=== Тест 7: Ошибка - отрицательный индекс ===');
  var queue7 = SinglyLinkedQueue<int>();
  queue7.enqueue(1);
  queue7.enqueue(2);
  try {
    queue7.insertAt(-1, 99);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue7');
  print('');

  print('=== Тест 8: Ошибка - индекс > size ===');
  var queue8 = SinglyLinkedQueue<int>();
  queue8.enqueue(1);
  queue8.enqueue(2);
  queue8.enqueue(3);
  try {
    queue8.insertAt(4, 99);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue8');
  print('');

  print('=== Тест 9: Ошибка - очередь полна ===');
  var queue9 = SinglyLinkedQueue<int>(fixedSize: 3);
  queue9.enqueue(1);
  queue9.enqueue(2);
  queue9.enqueue(3);
  try {
    queue9.insertAt(1, 99);
  } on StateError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue9');
  print('');

  print('=== Тест 10: insertAt с разными типами данных ===');
  var queue10 = SinglyLinkedQueue<String>(fixedSize: 5);
  queue10.enqueue('a');
  queue10.enqueue('c');
  print('Очередь до insertAt: $queue10');
  queue10.insertAt(1, 'b');
  print('Очередь после insertAt(1, "b"): $queue10'); // [a, b, c]
  print('');
}

