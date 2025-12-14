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

  /// Устанавливает значение элемента по указанному индексу.
  /// Индекс 0 соответствует первому элементу (head), индекс size-1 - последнему (tail).
  /// Выбрасывает RangeError, если индекс вне диапазона [0, size-1].
  void setAt(int index, T value) {
    if (index < 0 || index >= _size) {
      throw RangeError.range(index, 0, _size - 1, 'index', 'Index out of range');
    }

    var current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    current!.data = value;
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
  print('=== Тест 1: Базовый setAt ===');
  var queue = SinglyLinkedQueue<int>(fixedSize: 5);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(4);
  print('Очередь до setAt: $queue'); // [1, 2, 3, 4]
  queue.setAt(1, 99);
  print('Очередь после setAt(1, 99): $queue'); // [1, 99, 3, 4]
  print('peek(): ${queue.peek()}'); // 1
  print('');

  print('=== Тест 2: setAt в начале (index 0) ===');
  var queue2 = SinglyLinkedQueue<int>(fixedSize: 4);
  queue2.enqueue(10);
  queue2.enqueue(20);
  queue2.enqueue(30);
  print('Очередь до setAt: $queue2');
  queue2.setAt(0, 100);
  print('Очередь после setAt(0, 100): $queue2'); // [100, 20, 30]
  print('peek(): ${queue2.peek()}'); // 100
  print('');

  print('=== Тест 3: setAt в конце (index size-1) ===');
  var queue3 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue3.enqueue(1);
  queue3.enqueue(2);
  queue3.enqueue(3);
  queue3.enqueue(4);
  queue3.enqueue(5);
  print('Очередь до setAt: $queue3, размер: ${queue3.size}');
  queue3.setAt(4, 999);
  print('Очередь после setAt(4, 999): $queue3'); // [1, 2, 3, 4, 999]
  print('');

  print('=== Тест 4: Несколько setAt подряд ===');
  var queue4 = SinglyLinkedQueue<int>(fixedSize: 4);
  queue4.enqueue(1);
  queue4.enqueue(2);
  queue4.enqueue(3);
  queue4.enqueue(4);
  print('Исходная очередь: $queue4');
  queue4.setAt(0, 10);
  queue4.setAt(1, 20);
  queue4.setAt(2, 30);
  queue4.setAt(3, 40);
  print('После всех setAt: $queue4'); // [10, 20, 30, 40]
  print('Размер: ${queue4.size}'); // 4
  print('');

  print('=== Тест 5: Проверка через dequeue ===');
  var queue5 = SinglyLinkedQueue<int>(fixedSize: 3);
  queue5.enqueue(1);
  queue5.enqueue(2);
  queue5.enqueue(3);
  queue5.setAt(1, 99);
  print('Очередь после setAt(1, 99): $queue5');
  print('Элементы через dequeue:');
  print('  ${queue5.dequeue()}'); // 1
  print('  ${queue5.dequeue()}'); // 99
  print('  ${queue5.dequeue()}'); // 3
  print('');

  print('=== Тест 6: Ошибка - отрицательный индекс ===');
  var queue6 = SinglyLinkedQueue<int>();
  queue6.enqueue(1);
  queue6.enqueue(2);
  try {
    queue6.setAt(-1, 99);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue6');
  print('');

  print('=== Тест 7: Ошибка - индекс >= size ===');
  var queue7 = SinglyLinkedQueue<int>();
  queue7.enqueue(1);
  queue7.enqueue(2);
  queue7.enqueue(3);
  try {
    queue7.setAt(3, 99);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  try {
    queue7.setAt(10, 99);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue7');
  print('');

  print('=== Тест 8: setAt с разными типами данных ===');
  var queue8 = SinglyLinkedQueue<String>(fixedSize: 3);
  queue8.enqueue('a');
  queue8.enqueue('b');
  queue8.enqueue('c');
  print('Очередь до setAt: $queue8');
  queue8.setAt(1, 'X');
  print('Очередь после setAt(1, "X"): $queue8'); // [a, X, c]
  print('');
}

