class ArrayQueue<T> {
  List<T?> _queue;
  int _head = 0;
  int _tail = 0;
  final int? _fixedSize;

  ArrayQueue({int? fixedSize})
      : _fixedSize = fixedSize,
        _queue = List<T?>.filled(
          fixedSize ?? 16,
          null,
          growable: fixedSize == null,
        );

  void enqueue(T element) {
    if (_tail == _queue.length && _fixedSize == null) {
      _queue.length *= 2; // увеличиваем длину массива
    }
    if (_tail - _head == _fixedSize) {
      throw StateError('Queue is full');
    }
    _queue[_tail++ % _queue.length] = element;
  }

  T dequeue() {
    if (_head == _tail) {
      throw StateError('Queue is empty');
    }
    var element = _queue[_head % _queue.length];
    _queue[_head++ % _queue.length] = null;
    if (_fixedSize == null &&
        _tail - _head > 16 &&
        (_tail - _head) * 4 < _queue.length) {
      _tail -= _head;
      _head = 0;
      _queue = _queue.sublist(_head, _tail);
    }
    return element!;
  }

  T peek() {
    if (_head == _tail) {
      throw StateError('Queue is empty');
    }
    return _queue[_head % _queue.length]!;
  }

  bool get isEmpty => _head == _tail;
  bool get isFull => _tail - _head == _fixedSize;
  int get size => _tail - _head;

  void clear() {
    _queue = List<T?>.filled(
      _queue.length,
      null,
      growable: _fixedSize == null,
    );
    _head = 0;
    _tail = 0;
  }

  /// Разделяет очередь на две по указанному индексу.
  /// Текущая очередь содержит элементы [0, index).
  /// Новая очередь содержит элементы [index, size).
  /// Индекс может быть от 0 до size (включительно).
  /// Новая очередь сохраняет _fixedSize исходной очереди.
  /// Выбрасывает RangeError, если индекс вне диапазона [0, size].
  ArrayQueue<T> split(int index) {
    if (index < 0 || index > size) {
      throw RangeError.range(index, 0, size, 'index', 'Index out of range');
    }

    final newQueue = ArrayQueue<T>(fixedSize: _fixedSize);

    // Если index == 0, текущая очередь становится пустой, новая содержит все
    if (index == 0) {
      final queueSize = size;
      final queueLength = _queue.length;
      final newQueueLength = _fixedSize ?? 16;
      newQueue._queue = List<T?>.filled(newQueueLength, null, growable: _fixedSize == null);
      
      for (int i = 0; i < queueSize; i++) {
        final sourceIndex = (_head + i) % queueLength;
        final targetIndex = i % newQueueLength;
        if (targetIndex >= newQueue._queue.length && _fixedSize == null) {
          newQueue._queue.length *= 2;
        }
        newQueue._queue[targetIndex] = _queue[sourceIndex];
      }
      
      newQueue._head = 0;
      newQueue._tail = queueSize;
      
      // Очищаем текущую очередь
      clear();
      return newQueue;
    }

    // Если index == size, новая очередь пустая, текущая не меняется
    if (index == size) {
      return newQueue;
    }

    // Разделяем очередь
    final queueSize = size;
    final queueLength = _queue.length;
    final newQueueLength = _fixedSize ?? 16;
    newQueue._queue = List<T?>.filled(newQueueLength, null, growable: _fixedSize == null);
    
    // Копируем элементы [index, size) в новую очередь
    final newSize = queueSize - index;
    for (int i = 0; i < newSize; i++) {
      final sourceIndex = (_head + index + i) % queueLength;
      final targetIndex = i % newQueueLength;
      if (targetIndex >= newQueue._queue.length && _fixedSize == null) {
        newQueue._queue.length *= 2;
      }
      newQueue._queue[targetIndex] = _queue[sourceIndex];
      // Очищаем исходный элемент
      _queue[sourceIndex] = null;
    }
    
    newQueue._head = 0;
    newQueue._tail = newSize;
    
    // Обновляем текущую очередь
    _tail = _head + index;
    
    return newQueue;
  }

  @override
  String toString() {
    if (isEmpty) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    final queueSize = size;
    final queueLength = _queue.length;
    for (int i = 0; i < queueSize; i++) {
      if (i > 0) buffer.write(', ');
      buffer.write(_queue[(_head + i) % queueLength]);
    }
    buffer.write(']');
    return buffer.toString();
  }
}

void main() {
  print('=== Тест 1: Базовый split в середине ===');
  var queue = ArrayQueue<int>(fixedSize: 8);
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
  var queue2 = ArrayQueue<int>(fixedSize: 6);
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
  var queue3 = ArrayQueue<int>(fixedSize: 5);
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
  var queue4 = ArrayQueue<int>(fixedSize: 6);
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
  var queue5 = ArrayQueue<int>(fixedSize: 7);
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
  var queue6 = ArrayQueue<int>();
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
  var queue7 = ArrayQueue<int>();
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
  var queue8 = ArrayQueue<int>(fixedSize: 10);
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
  var queue9 = ArrayQueue<int>(fixedSize: 5);
  queue9.enqueue(42);
  print('Очередь с одним элементом: $queue9');
  var newQueue9 = queue9.split(1);
  print('Текущая очередь после split(1): $queue9'); // []
  print('Новая очередь: $newQueue9'); // [42]
  print('');

  print('=== Тест 10: split с циклическим буфером ===');
  var queue10 = ArrayQueue<int>(fixedSize: 5);
  queue10.enqueue(1);
  queue10.enqueue(2);
  queue10.dequeue(); // head сдвинулся
  queue10.enqueue(3);
  queue10.enqueue(4);
  queue10.enqueue(5);
  print('Очередь до split: $queue10'); // [2, 3, 4, 5]
  var newQueue10 = queue10.split(2);
  print('Текущая очередь после split(2): $queue10'); // [2, 3]
  print('Новая очередь: $newQueue10'); // [4, 5]
  print('');

  print('=== Тест 11: split с разными типами данных ===');
  var queue11 = ArrayQueue<String>(fixedSize: 6);
  queue11.enqueue('a');
  queue11.enqueue('b');
  queue11.enqueue('c');
  queue11.enqueue('d');
  print('Исходная очередь: $queue11');
  var newQueue11 = queue11.split(2);
  print('Текущая очередь: $queue11'); // [a, b]
  print('Новая очередь: $newQueue11'); // [c, d]
  print('');
}

