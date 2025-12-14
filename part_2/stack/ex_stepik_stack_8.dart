class _StackNode<T> {
  T data;
  _StackNode<T>? next;

  _StackNode(this.data);
}

class StackLinkedList<T> {
  _StackNode<T>? _top;
  final int _capacity;
  int _size = 0;

  StackLinkedList({int fixedSize = 0}) : _capacity = fixedSize;

  bool get isFull => _size >= _capacity && _capacity > 0;
  bool get isEmpty => _top == null;
  int get size => _size;

  void push(T element) {
    if (isFull) {
      throw StackOverflowError();
    }
    _top = _StackNode<T>(element)..next = _top;
    _size++;
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop from an empty stack.");
    }
    final poppedValue = _top!.data;
    _top = _top!.next;
    _size--;
    return poppedValue;
  }

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek from an empty stack.");
    }
    return _top!.data;
  }

  void clear() {
    _top = null;
    _size = 0;
  }

  /// Перемещает k верхних элементов в низ стека, сохраняя их относительный порядок.
  /// Если k <= 0 или k >= size, стек не меняется.
  void rotate(int k) {
    if (k <= 0 || k >= _size || _size < 2) {
      return; // Нечего вращать
    }

    // Находим узел, который станет новой вершиной (k-й элемент сверху)
    // Нужно пройти (size - k) элементов от вершины
    var current = _top;
    for (int i = 0; i < _size - k - 1; i++) {
      current = current!.next;
    }

    // current теперь указывает на узел перед новой вершиной
    // Сохраняем новую вершину и хвост
    final newTop = current!.next;
    final tail = current;

    // Находим конец стека (последний узел)
    var lastNode = newTop;
    while (lastNode!.next != null) {
      lastNode = lastNode.next;
    }

    // "Отрезаем" k элементов от вершины
    tail.next = null;

    // Приклеиваем старую вершину к низу
    lastNode.next = _top;

    // Устанавливаем новую вершину
    _top = newTop;
  }

  @override
  String toString() {
    if (_top == null) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    var current = _top;
    while (current!.next != null) {
      buffer.write('${current.data}, ');
      current = current.next;
    }
    buffer.write('${current.data}]');
    return buffer.toString();
  }
}

void main() {
  print('=== Тест 1: Базовый rotate ===');
  final stack = StackLinkedList<int>();
  stack.push(1); // Дно
  stack.push(2);
  stack.push(3);
  stack.push(4);
  stack.push(5); // Вершина
  print('Стек до rotate: $stack'); // [5, 4, 3, 2, 1]
  
  // Вращаем 2 элемента (5 и 4) вниз
  stack.rotate(2);
  print('Стек после rotate(2): $stack'); // [3, 2, 1, 5, 4]
  print('peek(): ${stack.peek()}'); // 3
  print('');

  print('=== Тест 2: k = 0 или k >= size (не меняется) ===');
  final stack2 = StackLinkedList<int>();
  stack2.push(10);
  stack2.push(20);
  stack2.push(30);
  print('Стек до rotate: $stack2');
  stack2.rotate(0);
  print('После rotate(0): $stack2 (не изменился)');
  stack2.rotate(3);
  print('После rotate(3): $stack2 (не изменился)');
  stack2.rotate(5);
  print('После rotate(5): $stack2 (не изменился)');
  print('');

  print('=== Тест 3: k = 1 ===');
  final stack3 = StackLinkedList<int>();
  stack3.push(1);
  stack3.push(2);
  stack3.push(3);
  print('Стек до rotate: $stack3');
  stack3.rotate(1);
  print('Стек после rotate(1): $stack3');
  print('peek(): ${stack3.peek()}'); // 2
  print('');

  print('=== Тест 4: k = size - 1 ===');
  final stack4 = StackLinkedList<int>();
  stack4.push(1);
  stack4.push(2);
  stack4.push(3);
  stack4.push(4);
  print('Стек до rotate: $stack4, размер: ${stack4.size}');
  stack4.rotate(3); // size - 1 = 3
  print('Стек после rotate(3): $stack4');
  print('peek(): ${stack4.peek()}'); // 1
  print('');

  print('=== Тест 5: Несколько rotate подряд ===');
  final stack5 = StackLinkedList<int>();
  stack5.push(1);
  stack5.push(2);
  stack5.push(3);
  stack5.push(4);
  stack5.push(5);
  print('Исходный стек: $stack5');
  stack5.rotate(2);
  print('После rotate(2): $stack5');
  stack5.rotate(1);
  print('После rotate(1): $stack5');
  stack5.rotate(2);
  print('После rotate(2): $stack5');
  print('Размер: ${stack5.size}'); // 5
}

