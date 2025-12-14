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

  /// Объединяет две очереди, добавляя все элементы из другой очереди в конец текущей.
  /// Вторая очередь (other) остается неизменной.
  /// Выбрасывает StateError, если результат не поместится (с учетом _fixedSize).
  void merge(ArrayQueue<T> other) {
    if (other.isEmpty) return;

    final otherSize = other.size;
    final newSize = size + otherSize;

    // Проверяем, поместится ли результат
    final fixedSize = _fixedSize;
    if (fixedSize != null && newSize > fixedSize) {
      throw StateError('Queue is full: cannot merge, result would exceed fixed size');
    }

    // Если текущая очередь пуста, копируем элементы из other
    if (isEmpty) {
      final queueLength = _queue.length;
      final otherQueueLength = other._queue.length;
      for (int i = 0; i < otherSize; i++) {
        final otherIndex = (other._head + i) % otherQueueLength;
        final targetIndex = (_head + i) % queueLength;
        if (targetIndex >= _queue.length && _fixedSize == null) {
          _queue.length *= 2;
        }
        _queue[targetIndex] = other._queue[otherIndex];
      }
      _tail = _head + otherSize;
      return;
    }

    // Добавляем элементы из other в конец текущей очереди
    final queueLength = _queue.length;
    final otherQueueLength = other._queue.length;
    for (int i = 0; i < otherSize; i++) {
      final otherIndex = (other._head + i) % otherQueueLength;
      final targetIndex = _tail % queueLength;
      
      // Расширяем массив, если нужно
      if (targetIndex >= _queue.length && _fixedSize == null) {
        _queue.length *= 2;
      }
      
      _queue[targetIndex] = other._queue[otherIndex];
      _tail++;
    }
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
  print('=== Тест 1: Базовый merge ===');
  var queue1 = ArrayQueue<int>(fixedSize: 10);
  queue1.enqueue(1);
  queue1.enqueue(2);
  queue1.enqueue(3);

  var queue2 = ArrayQueue<int>(fixedSize: 5);
  queue2.enqueue(4);
  queue2.enqueue(5);
  queue2.enqueue(6);

  print('Очередь 1 до merge: $queue1'); // [1, 2, 3]
  print('Очередь 2: $queue2'); // [4, 5, 6]
  queue1.merge(queue2);
  print('Очередь 1 после merge: $queue1'); // [1, 2, 3, 4, 5, 6]
  print('Очередь 2 после merge (не изменилась): $queue2'); // [4, 5, 6]
  print('Размер очереди 1: ${queue1.size}'); // 6
  print('');

  print('=== Тест 2: merge с пустой другой очередью ===');
  var queue3 = ArrayQueue<int>(fixedSize: 5);
  queue3.enqueue(10);
  queue3.enqueue(20);

  var queue4 = ArrayQueue<int>();
  print('Очередь 3 до merge: $queue3');
  print('Очередь 4 (пустая): $queue4');
  queue3.merge(queue4);
  print('Очередь 3 после merge: $queue3 (не изменилась)');
  print('');

  print('=== Тест 3: merge с пустой текущей очередью ===');
  var queue5 = ArrayQueue<int>(fixedSize: 5);
  var queue6 = ArrayQueue<int>(fixedSize: 3);
  queue6.enqueue(100);
  queue6.enqueue(200);
  queue6.enqueue(300);

  print('Очередь 5 (пустая): $queue5');
  print('Очередь 6: $queue6');
  queue5.merge(queue6);
  print('Очередь 5 после merge: $queue5'); // [100, 200, 300]
  print('Очередь 6 после merge (не изменилась): $queue6'); // [100, 200, 300]
  print('peek() очереди 5: ${queue5.peek()}'); // 100
  print('');

  print('=== Тест 4: Проверка через dequeue ===');
  var queue7 = ArrayQueue<int>(fixedSize: 6);
  queue7.enqueue(1);
  queue7.enqueue(2);

  var queue8 = ArrayQueue<int>(fixedSize: 4);
  queue8.enqueue(3);
  queue8.enqueue(4);
  queue8.enqueue(5);

  queue7.merge(queue8);
  print('Очередь 7 после merge: $queue7');
  print('Элементы через dequeue:');
  while (!queue7.isEmpty) {
    print('  ${queue7.dequeue()}'); // 1, 2, 3, 4, 5
  }
  print('');

  print('=== Тест 5: Ошибка - превышение fixedSize ===');
  var queue9 = ArrayQueue<int>(fixedSize: 4);
  queue9.enqueue(1);
  queue9.enqueue(2);
  queue9.enqueue(3);

  var queue10 = ArrayQueue<int>(fixedSize: 3);
  queue10.enqueue(4);
  queue10.enqueue(5);

  print('Очередь 9: $queue9, размер: ${queue9.size}');
  print('Очередь 10: $queue10, размер: ${queue10.size}');
  try {
    queue9.merge(queue10); // 3 + 2 = 5 > 4
  } on StateError catch (e) {
    print('Поймана ошибка: $e');
  }
  print('Очередь 9 не изменилась: $queue9');
  print('Очередь 10 не изменилась: $queue10');
  print('');

  print('=== Тест 6: Несколько merge подряд ===');
  var queue11 = ArrayQueue<int>(fixedSize: 10);
  queue11.enqueue(1);

  var queue12 = ArrayQueue<int>(fixedSize: 5);
  queue12.enqueue(2);
  queue12.enqueue(3);

  var queue13 = ArrayQueue<int>(fixedSize: 5);
  queue13.enqueue(4);
  queue13.enqueue(5);
  queue13.enqueue(6);

  print('Исходная очередь 11: $queue11');
  queue11.merge(queue12);
  print('После первого merge: $queue11');
  queue11.merge(queue13);
  print('После второго merge: $queue11'); // [1, 2, 3, 4, 5, 6]
  print('Размер: ${queue11.size}'); // 6
  print('');

  print('=== Тест 7: merge с циклическим буфером ===');
  var queue14 = ArrayQueue<int>(fixedSize: 5);
  queue14.enqueue(1);
  queue14.enqueue(2);
  queue14.dequeue(); // head сдвинулся
  queue14.enqueue(3);
  queue14.enqueue(4);

  var queue15 = ArrayQueue<int>(fixedSize: 3);
  queue15.enqueue(5);
  queue15.enqueue(6);

  print('Очередь 14 до merge: $queue14'); // [2, 3, 4]
  print('Очередь 15: $queue15'); // [5, 6]
  queue14.merge(queue15);
  print('Очередь 14 после merge: $queue14'); // [2, 3, 4, 5, 6]
  print('');

  print('=== Тест 8: merge с разными типами данных ===');
  var queue16 = ArrayQueue<String>(fixedSize: 6);
  queue16.enqueue('a');
  queue16.enqueue('b');

  var queue17 = ArrayQueue<String>(fixedSize: 4);
  queue17.enqueue('c');
  queue17.enqueue('d');
  queue17.enqueue('e');

  print('Очередь 16 до merge: $queue16');
  print('Очередь 17: $queue17');
  queue16.merge(queue17);
  print('Очередь 16 после merge: $queue16'); // [a, b, c, d, e]
  print('');

  print('=== Тест 9: Независимость очередей после merge ===');
  var queue18 = ArrayQueue<int>(fixedSize: 8);
  queue18.enqueue(10);
  queue18.enqueue(20);

  var queue19 = ArrayQueue<int>(fixedSize: 5);
  queue19.enqueue(30);
  queue19.enqueue(40);

  queue18.merge(queue19);
  print('Очередь 18 после merge: $queue18');
  
  // Изменяем очередь 19
  queue19.enqueue(50);
  print('Очередь 19 после добавления элемента: $queue19');
  print('Очередь 18 не изменилась: $queue18'); // [10, 20, 30, 40]
  print('Размер очереди 18: ${queue18.size}'); // 4
}

