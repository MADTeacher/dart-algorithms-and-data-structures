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

  /// Разделяет очередь на две по указанному индексу.
  /// Текущая очередь содержит элементы [0, index).
  /// Новая очередь содержит элементы [index, size).
  /// Индекс может быть от 0 до size (включительно).
  /// Новая очередь сохраняет _fixedSize исходной очереди.
  /// Выбрасывает RangeError, если индекс вне диапазона [0, size].
  SinglyLinkedQueue<T> split(int index) {
    if (index < 0 || index > _size) {
      throw RangeError.range(index, 0, _size, 'index', 'Index out of range');
    }

    final newQueue = SinglyLinkedQueue<T>(fixedSize: _fixedSize);

    // Если index == 0, текущая очередь становится пустой, новая содержит все
    if (index == 0) {
      newQueue._head = _head;
      newQueue._tail = _tail;
      newQueue._size = _size;
      _head = _tail = null;
      _size = 0;
      return newQueue;
    }

    // Если index == size, новая очередь пустая, текущая не меняется
    if (index == _size) {
      return newQueue;
    }

    // Находим узел перед индексом разделения
    var current = _head;
    for (int i = 0; i < index - 1; i++) {
      current = current!.next;
    }

    // Разделяем: current.next становится началом новой очереди
    newQueue._head = current!.next;
    newQueue._tail = _tail;
    newQueue._size = _size - index;

    // Обрезаем текущую очередь
    current.next = null;
    _tail = current;
    _size = index;

    return newQueue;
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
  print('=== Тест 1: Базовый split в середине ===');
  var queue = SinglyLinkedQueue<int>(fixedSize: 8);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(4);
  queue.enqueue(5);
  print('Исходная очередь: $queue'); // [1, 2, 3, 4, 5]
  var newQueue = queue.split(2);
  print('Текущая очередь после split(2): $queue'); // [1, 2]
  print('Новая очередь: $newQueue'); // [3, 4, 5]
  print('Размер текущей: ${queue.size}'); // 2
  print('Размер новой: ${newQueue.size}'); // 3
  print('');

  print('=== Тест 2: split в начале (index 0) ===');
  var queue2 = SinglyLinkedQueue<int>(fixedSize: 6);
  queue2.enqueue(10);
  queue2.enqueue(20);
  queue2.enqueue(30);
  print('Исходная очередь: $queue2');
  var newQueue2 = queue2.split(0);
  print('Текущая очередь после split(0): $queue2'); // []
  print('Новая очередь: $newQueue2'); // [10, 20, 30]
  print('Текущая пустая: ${queue2.isEmpty}'); // true
  print('peek() новой очереди: ${newQueue2.peek()}'); // 10
  print('');

  print('=== Тест 3: split в конце (index == size) ===');
  var queue3 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue3.enqueue(1);
  queue3.enqueue(2);
  queue3.enqueue(3);
  print('Исходная очередь: $queue3, размер: ${queue3.size}');
  var newQueue3 = queue3.split(3);
  print('Текущая очередь после split(3): $queue3'); // [1, 2, 3]
  print('Новая очередь: $newQueue3'); // []
  print('Новая пустая: ${newQueue3.isEmpty}'); // true
  print('Текущая не изменилась: ${queue3.size}'); // 3
  print('');

  print('=== Тест 4: split(1) ===');
  var queue4 = SinglyLinkedQueue<int>(fixedSize: 6);
  queue4.enqueue(1);
  queue4.enqueue(2);
  queue4.enqueue(3);
  queue4.enqueue(4);
  print('Исходная очередь: $queue4');
  var newQueue4 = queue4.split(1);
  print('Текущая очередь после split(1): $queue4'); // [1]
  print('Новая очередь: $newQueue4'); // [2, 3, 4]
  print('');

  print('=== Тест 5: Проверка через dequeue ===');
  var queue5 = SinglyLinkedQueue<int>(fixedSize: 7);
  queue5.enqueue(1);
  queue5.enqueue(2);
  queue5.enqueue(3);
  queue5.enqueue(4);
  queue5.enqueue(5);
  var newQueue5 = queue5.split(2);
  print('Текущая очередь: $queue5');
  print('Новая очередь: $newQueue5');
  print('Элементы текущей через dequeue:');
  while (!queue5.isEmpty) {
    print('  ${queue5.dequeue()}'); // 1, 2
  }
  print('Элементы новой через dequeue:');
  while (!newQueue5.isEmpty) {
    print('  ${newQueue5.dequeue()}'); // 3, 4, 5
  }
  print('');

  print('=== Тест 6: Ошибка - отрицательный индекс ===');
  var queue6 = SinglyLinkedQueue<int>();
  queue6.enqueue(1);
  queue6.enqueue(2);
  try {
    queue6.split(-1);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue6');
  print('');

  print('=== Тест 7: Ошибка - индекс > size ===');
  var queue7 = SinglyLinkedQueue<int>();
  queue7.enqueue(1);
  queue7.enqueue(2);
  queue7.enqueue(3);
  try {
    queue7.split(4);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  try {
    queue7.split(10);
  } on RangeError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь не изменилась: $queue7');
  print('');

  print('=== Тест 8: Сохранение _fixedSize ===');
  var queue8 = SinglyLinkedQueue<int>(fixedSize: 10);
  queue8.enqueue(1);
  queue8.enqueue(2);
  queue8.enqueue(3);
  queue8.enqueue(4);
  queue8.enqueue(5);
  var newQueue8 = queue8.split(2);
  print('Исходная очередь имела fixedSize: 10');
  print('Текущая очередь после split: $queue8');
  print('Новая очередь после split: $newQueue8');
  // Проверяем, что можно добавить элементы в новую очередь с учетом fixedSize
  newQueue8.enqueue(6);
  newQueue8.enqueue(7);
  newQueue8.enqueue(8);
  print('Новая очередь после добавления элементов: $newQueue8');
  print('Размер новой очереди: ${newQueue8.size}'); // 6 (3 исходных + 3 новых)
  print('');

  print('=== Тест 9: split с одним элементом ===');
  var queue9 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue9.enqueue(42);
  print('Очередь с одним элементом: $queue9');
  var newQueue9 = queue9.split(1);
  print('Текущая очередь после split(1): $queue9'); // [42] (не изменилась, т.к. index == size)
  print('Новая очередь: $newQueue9'); // [] (пустая, т.к. index == size)
  print('');

  print('=== Тест 10: split с разными типами данных ===');
  var queue10 = SinglyLinkedQueue<String>(fixedSize: 6);
  queue10.enqueue('a');
  queue10.enqueue('b');
  queue10.enqueue('c');
  queue10.enqueue('d');
  print('Исходная очередь: $queue10');
  var newQueue10 = queue10.split(2);
  print('Текущая очередь: $queue10'); // [a, b]
  print('Новая очередь: $newQueue10'); // [c, d]
  print('');
}

