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
    _queue = List<T?>.filled(_queue.length, null, growable: _fixedSize == null);
    _head = 0;
    _tail = 0;
  }

  /// Разворачивает очередь in-place, меняя порядок элементов на противоположный.
  /// Временная сложность: O(n), пространственная: O(1)
  void reverse() {
    if (size < 2) return;

    final queueSize = size;
    final queueLength = _queue.length;

    // Собираем все элементы в правильном порядке
    final elements = <T>[];
    for (int i = 0; i < queueSize; i++) {
      elements.add(_queue[(_head + i) % queueLength]!);
    }

    // Записываем элементы в обратном порядке
    for (int i = 0; i < queueSize; i++) {
      _queue[(_head + i) % queueLength] = elements[queueSize - 1 - i];
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
  print('=== Тест 1: Базовый reverse ===');
  var queue = ArrayQueue<int>(fixedSize: 5);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(4);
  print('Очередь до reverse: $queue'); // [1, 2, 3, 4]
  queue.reverse();
  print('Очередь после reverse: $queue'); // [4, 3, 2, 1]
  print('peek(): ${queue.peek()}'); // 4
  print('');

  print('=== Тест 2: Пустая очередь ===');
  var queue2 = ArrayQueue<int>();
  print('Пустая очередь: $queue2');
  queue2.reverse();
  print('После reverse: $queue2');
  print('');

  print('=== Тест 3: Один элемент ===');
  var queue3 = ArrayQueue<int>();
  queue3.enqueue(42);
  print('Очередь до reverse: $queue3');
  queue3.reverse();
  print('Очередь после reverse: $queue3');
  print('');

  print('=== Тест 4: Проверка порядка элементов через dequeue ===');
  var queue4 = ArrayQueue<int>(fixedSize: 6);
  queue4.enqueue(10);
  queue4.enqueue(20);
  queue4.enqueue(30);
  queue4.enqueue(40);
  queue4.enqueue(50);
  print('Очередь до reverse: $queue4');
  queue4.reverse();
  print('Очередь после reverse: $queue4');
  print('Элементы через dequeue:');
  while (!queue4.isEmpty) {
    print('  ${queue4.dequeue()}'); // 50, 40, 30, 20, 10
  }
  print('');

  print('=== Тест 5: Очередь с циклическим буфером ===');
  var queue5 = ArrayQueue<int>(fixedSize: 4);
  queue5.enqueue(1);
  queue5.enqueue(2);
  queue5.dequeue(); // удаляем 1, теперь head сдвинут
  queue5.enqueue(3);
  queue5.enqueue(4);
  queue5.enqueue(5);
  print('Очередь до reverse: $queue5'); // [2, 3, 4, 5]
  queue5.reverse();
  print('Очередь после reverse: $queue5'); // [5, 4, 3, 2]
  print('peek(): ${queue5.peek()}'); // 5
  print('');

  print('=== Тест 6: Несколько reverse подряд ===');
  var queue6 = ArrayQueue<int>(fixedSize: 5);
  queue6.enqueue(1);
  queue6.enqueue(2);
  queue6.enqueue(3);
  print('Исходная очередь: $queue6');
  queue6.reverse();
  print('После первого reverse: $queue6');
  queue6.reverse();
  print('После второго reverse: $queue6');
  print('Размер: ${queue6.size}'); // 3
}
