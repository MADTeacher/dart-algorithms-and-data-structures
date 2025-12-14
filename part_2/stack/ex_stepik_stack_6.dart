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

  /// Разворачивает стек задом наперед, изменяя направления ссылок.
  /// Не использует дополнительные структуры данных и не меняет значения data.
  void reverse() {
    if (_top == null || _top!.next == null) {
      return; // Пустой стек или один элемент - нечего разворачивать
    }

    _StackNode<T>? previous = null;
    var current = _top;

    while (current != null) {
      final next = current.next;
      current.next = previous;
      previous = current;
      current = next;
    }

    _top = previous;
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
  print('=== Тест 1: Базовый reverse ===');
  final stack = StackLinkedList<int>();
  stack.push(10);
  stack.push(20);
  stack.push(30);
  print('Стек до reverse: $stack');
  stack.reverse();
  print('Стек после reverse: $stack');
  print('pop(): ${stack.pop()}'); // 10
  print('pop(): ${stack.pop()}'); // 20
  print('pop(): ${stack.pop()}'); // 30
  print('');

  print('=== Тест 2: Пустой стек ===');
  final emptyStack = StackLinkedList<int>();
  print('Пустой стек: $emptyStack');
  emptyStack.reverse();
  print('После reverse: $emptyStack');
  print('isEmpty: ${emptyStack.isEmpty}'); // true
  print('');

  print('=== Тест 3: Один элемент ===');
  final singleStack = StackLinkedList<int>();
  singleStack.push(42);
  print('Стек до reverse: $singleStack');
  singleStack.reverse();
  print('Стек после reverse: $singleStack');
  print('pop(): ${singleStack.pop()}'); // 42
  print('');

  print('=== Тест 4: Reverse дважды (возврат к исходному) ===');
  final stack2 = StackLinkedList<int>();
  stack2.push(1);
  stack2.push(2);
  stack2.push(3);
  stack2.push(4);
  print('Исходный стек: $stack2');
  stack2.reverse();
  print('После первого reverse: $stack2');
  stack2.reverse();
  print('После второго reverse: $stack2');
  print('pop(): ${stack2.pop()}'); // 4
  print('pop(): ${stack2.pop()}'); // 3
  print('');

  print('=== Тест 5: Reverse большого стека ===');
  final stack3 = StackLinkedList<int>();
  for (int i = 1; i <= 5; i++) {
    stack3.push(i);
  }
  print('Стек до reverse: $stack3');
  stack3.reverse();
  print('Стек после reverse: $stack3');
  print('Размер: ${stack3.size}'); // 5
  for (int i = 0; i < 5; i++) {
    print('pop(): ${stack3.pop()}'); // 1, 2, 3, 4, 5
  }
}

