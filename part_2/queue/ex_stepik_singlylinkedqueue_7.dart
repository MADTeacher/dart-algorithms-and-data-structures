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

  /// Объединяет две очереди, добавляя все элементы из другой очереди в конец текущей.
  /// Вторая очередь (other) остается неизменной.
  /// Выбрасывает StateError, если результат не поместится (с учетом _fixedSize).
  void merge(SinglyLinkedQueue<T> other) {
    if (other.isEmpty) return;

    // Проверяем, поместится ли результат
    final newSize = _size + other._size;
    final fixedSize = _fixedSize;
    if (fixedSize != null && newSize > fixedSize) {
      throw StateError('Queue is full: cannot merge, result would exceed fixed size');
    }

    // Если текущая очередь пуста, просто копируем ссылки
    if (isEmpty) {
      _head = other._head;
      _tail = other._tail;
      _size = other._size;
      return;
    }

    // Создаем копии узлов из other, чтобы не изменять исходную очередь
    var current = other._head;
    while (current != null) {
      var newNode = _Node(current.data);
      _tail!.next = newNode;
      _tail = newNode;
      _size++;
      current = current.next;
    }
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
  print('=== Тест 1: Базовый merge ===');
  var queue1 = SinglyLinkedQueue<int>(fixedSize: 10);
  queue1.enqueue(1);
  queue1.enqueue(2);
  queue1.enqueue(3);

  var queue2 = SinglyLinkedQueue<int>(fixedSize: 5);
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
  var queue3 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue3.enqueue(10);
  queue3.enqueue(20);

  var queue4 = SinglyLinkedQueue<int>();
  print('Очередь 3 до merge: $queue3');
  print('Очередь 4 (пустая): $queue4');
  queue3.merge(queue4);
  print('Очередь 3 после merge: $queue3 (не изменилась)');
  print('');

  print('=== Тест 3: merge с пустой текущей очередью ===');
  var queue5 = SinglyLinkedQueue<int>(fixedSize: 5);
  var queue6 = SinglyLinkedQueue<int>(fixedSize: 3);
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
  var queue7 = SinglyLinkedQueue<int>(fixedSize: 6);
  queue7.enqueue(1);
  queue7.enqueue(2);

  var queue8 = SinglyLinkedQueue<int>(fixedSize: 4);
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
  var queue9 = SinglyLinkedQueue<int>(fixedSize: 4);
  queue9.enqueue(1);
  queue9.enqueue(2);
  queue9.enqueue(3);

  var queue10 = SinglyLinkedQueue<int>(fixedSize: 3);
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
  print('Очередь 10 не изменилась: $queue2');
  print('');

  print('=== Тест 6: Несколько merge подряд ===');
  var queue11 = SinglyLinkedQueue<int>(fixedSize: 10);
  queue11.enqueue(1);

  var queue12 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue12.enqueue(2);
  queue12.enqueue(3);

  var queue13 = SinglyLinkedQueue<int>(fixedSize: 5);
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

  print('=== Тест 7: merge с разными типами данных ===');
  var queue14 = SinglyLinkedQueue<String>(fixedSize: 6);
  queue14.enqueue('a');
  queue14.enqueue('b');

  var queue15 = SinglyLinkedQueue<String>(fixedSize: 4);
  queue15.enqueue('c');
  queue15.enqueue('d');
  queue15.enqueue('e');

  print('Очередь 14 до merge: $queue14');
  print('Очередь 15: $queue15');
  queue14.merge(queue15);
  print('Очередь 14 после merge: $queue14'); // [a, b, c, d, e]
  print('');

  print('=== Тест 8: Независимость очередей после merge ===');
  var queue16 = SinglyLinkedQueue<int>(fixedSize: 8);
  queue16.enqueue(10);
  queue16.enqueue(20);

  var queue17 = SinglyLinkedQueue<int>(fixedSize: 5);
  queue17.enqueue(30);
  queue17.enqueue(40);

  queue16.merge(queue17);
  print('Очередь 16 после merge: $queue16');
  
  // Изменяем очередь 17
  queue17.enqueue(50);
  print('Очередь 17 после добавления элемента: $queue17');
  print('Очередь 16 не изменилась: $queue16'); // [10, 20, 30, 40]
  print('Размер очереди 16: ${queue16.size}'); // 4
}

