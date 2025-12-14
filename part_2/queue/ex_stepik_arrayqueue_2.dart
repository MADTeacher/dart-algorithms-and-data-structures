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

  /// Циклически сдвигает элементы очереди на k позиций вправо.
  /// Если k < 0, сдвиг происходит влево.
  /// Если k == 0 или k == size, очередь не меняется.
  void rotate(int k) {
    if (isEmpty || size < 2) return;

    final queueSize = size;
    final queueLength = _queue.length;

    // Нормализуем k: если k отрицательный, преобразуем в положительный сдвиг влево
    if (k < 0) {
      k = queueSize - ((-k) % queueSize);
    }

    // Если k == 0 или k кратно размеру, ничего не делаем
    k = k % queueSize;
    if (k == 0) return;

    // Собираем все элементы
    final elements = <T>[];
    for (int i = 0; i < queueSize; i++) {
      elements.add(_queue[(_head + i) % queueLength]!);
    }

    // Применяем циклический сдвиг
    final rotated = <T>[];
    for (int i = 0; i < queueSize; i++) {
      rotated.add(elements[(i - k + queueSize) % queueSize]);
    }

    // Записываем обратно
    for (int i = 0; i < queueSize; i++) {
      _queue[(_head + i) % queueLength] = rotated[i];
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
  print('=== Тест 1: Базовый rotate вправо ===');
  var queue = ArrayQueue<int>(fixedSize: 5);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(4);
  queue.enqueue(5);
  print('Очередь до rotate: $queue'); // [1, 2, 3, 4, 5]
  queue.rotate(2);
  print('Очередь после rotate(2): $queue'); // [4, 5, 1, 2, 3]
  print('peek(): ${queue.peek()}'); // 4
  print('');

  print('=== Тест 2: rotate(0) и rotate(size) (не меняется) ===');
  var queue2 = ArrayQueue<int>(fixedSize: 4);
  queue2.enqueue(10);
  queue2.enqueue(20);
  queue2.enqueue(30);
  print('Очередь до rotate: $queue2');
  queue2.rotate(0);
  print('После rotate(0): $queue2 (не изменилась)');
  queue2.rotate(3);
  print('После rotate(3): $queue2 (не изменилась, т.к. size=3)');
  queue2.rotate(6);
  print('После rotate(6): $queue2 (не изменилась, т.к. 6 % 3 = 0)');
  print('');

  print('=== Тест 3: rotate влево (отрицательный k) ===');
  var queue3 = ArrayQueue<int>(fixedSize: 5);
  queue3.enqueue(1);
  queue3.enqueue(2);
  queue3.enqueue(3);
  queue3.enqueue(4);
  queue3.enqueue(5);
  print('Очередь до rotate: $queue3');
  queue3.rotate(-2);
  print('Очередь после rotate(-2): $queue3'); // [3, 4, 5, 1, 2]
  print('peek(): ${queue3.peek()}'); // 3
  print('');

  print('=== Тест 4: rotate(1) ===');
  var queue4 = ArrayQueue<int>(fixedSize: 4);
  queue4.enqueue(1);
  queue4.enqueue(2);
  queue4.enqueue(3);
  queue4.enqueue(4);
  print('Очередь до rotate: $queue4');
  queue4.rotate(1);
  print('Очередь после rotate(1): $queue4'); // [4, 1, 2, 3]
  print('peek(): ${queue4.peek()}'); // 4
  print('');

  print('=== Тест 5: rotate(size - 1) ===');
  var queue5 = ArrayQueue<int>(fixedSize: 5);
  queue5.enqueue(1);
  queue5.enqueue(2);
  queue5.enqueue(3);
  queue5.enqueue(4);
  print('Очередь до rotate: $queue5, размер: ${queue5.size}');
  queue5.rotate(3); // size - 1 = 3
  print('Очередь после rotate(3): $queue5'); // [2, 3, 4, 1]
  print('peek(): ${queue5.peek()}'); // 2
  print('');

  print('=== Тест 6: Несколько rotate подряд ===');
  var queue6 = ArrayQueue<int>(fixedSize: 5);
  queue6.enqueue(1);
  queue6.enqueue(2);
  queue6.enqueue(3);
  queue6.enqueue(4);
  queue6.enqueue(5);
  print('Исходная очередь: $queue6');
  queue6.rotate(2);
  print('После rotate(2): $queue6');
  queue6.rotate(1);
  print('После rotate(1): $queue6');
  queue6.rotate(-1);
  print('После rotate(-1): $queue6');
  print('Размер: ${queue6.size}'); // 5
  print('');

  print('=== Тест 7: Пустая очередь и один элемент ===');
  var queue7 = ArrayQueue<int>();
  print('Пустая очередь: $queue7');
  queue7.rotate(5);
  print('После rotate(5): $queue7 (не изменилась)');
  queue7.enqueue(42);
  queue7.rotate(1);
  print('После добавления 42 и rotate(1): $queue7 (не изменилась)');
  print('');

  print('=== Тест 8: Большой k (нормализация) ===');
  var queue8 = ArrayQueue<int>(fixedSize: 4);
  queue8.enqueue(1);
  queue8.enqueue(2);
  queue8.enqueue(3);
  print('Очередь: $queue8, размер: ${queue8.size}');
  queue8.rotate(10); // 10 % 3 = 1
  print('После rotate(10): $queue8'); // эквивалентно rotate(1)
  print('peek(): ${queue8.peek()}');
}

