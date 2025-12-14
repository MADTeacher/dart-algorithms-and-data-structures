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

  /// Проверяет, содержится ли указанный элемент в стеке.
  /// Перебирает узлы от вершины к низу.
  /// Состояние стека после вызова метода не изменяется.
  bool contains(T element) {
    var current = _top;
    while (current != null) {
      if (current.data == element) {
        return true;
      }
      current = current.next;
    }
    return false;
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
  print('=== Тест 1: Базовый contains ===');
  final stack = StackLinkedList<int>();
  stack.push(10);
  stack.push(20);
  print('Стек: $stack');
  print('contains(10): ${stack.contains(10)}'); // true
  print('contains(30): ${stack.contains(30)}'); // false
  print('Стек после contains (не изменился): $stack');
  print('');

  print('=== Тест 2: Пустой стек ===');
  final emptyStack = StackLinkedList<int>();
  print('Пустой стек: $emptyStack');
  print('contains(10): ${emptyStack.contains(10)}'); // false
  print('');

  print('=== Тест 3: Несколько одинаковых элементов ===');
  final stack2 = StackLinkedList<int>();
  stack2.push(5);
  stack2.push(5);
  stack2.push(5);
  stack2.push(10);
  print('Стек: $stack2');
  print('contains(5): ${stack2.contains(5)}'); // true
  print('contains(10): ${stack2.contains(10)}'); // true
  print('contains(99): ${stack2.contains(99)}'); // false
  print('Стек после contains (не изменился): $stack2, размер: ${stack2.size}');
  print('');

  print('=== Тест 4: Проверка что стек не изменился ===');
  final stack3 = StackLinkedList<String>();
  stack3.push('a');
  stack3.push('b');
  stack3.push('c');
  final originalSize = stack3.size;
  final originalString = stack3.toString();
  print('До contains: $stack3, размер: $originalSize');
  final result = stack3.contains('b');
  print('contains(\'b\'): $result');
  print('После contains: $stack3, размер: ${stack3.size}');
  print('Стек не изменился: ${stack3.toString() == originalString && stack3.size == originalSize}');
  print('');

  print('=== Тест 5: Элемент внизу стека ===');
  final stack4 = StackLinkedList<int>();
  stack4.push(1);
  stack4.push(2);
  stack4.push(3);
  stack4.push(4);
  print('Стек: $stack4');
  print('contains(1): ${stack4.contains(1)}'); // true (элемент внизу)
  print('contains(4): ${stack4.contains(4)}'); // true (элемент на вершине)
}

