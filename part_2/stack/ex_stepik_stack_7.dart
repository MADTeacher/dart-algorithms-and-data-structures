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

  /// Удаляет из стека все узлы, содержащие значение element.
  /// Возвращает количество удаленных элементов.
  /// Корректно "сшивает" список при удалении узлов в середине.
  int removeAll(T element) {
    int removedCount = 0;

    // Удаляем все элементы с вершины, если они равны element
    while (_top != null && _top!.data == element) {
      _top = _top!.next;
      _size--;
      removedCount++;
    }

    // Если стек стал пустым после удаления с вершины
    if (_top == null) {
      return removedCount;
    }

    // Проходим по остальным узлам и удаляем совпадающие
    var current = _top;
    while (current!.next != null) {
      if (current.next!.data == element) {
        // Удаляем следующий узел, "сшивая" список
        current.next = current.next!.next;
        _size--;
        removedCount++;
      } else {
        // Переходим к следующему узлу только если не удалили
        current = current.next;
      }
    }

    return removedCount;
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
  print('=== Тест 1: Базовый removeAll ===');
  final stack = StackLinkedList<int>();
  stack.push(1);
  stack.push(2);
  stack.push(1);
  stack.push(3);
  print('Стек до removeAll: $stack');
  int removed = stack.removeAll(1);
  print('Удалено элементов: $removed'); // 2
  print('Размер стека: ${stack.size}'); // 2
  print('Стек после removeAll: $stack');
  print('peek(): ${stack.peek()}'); // 3
  print('');

  print('=== Тест 2: Элемент не найден ===');
  final stack2 = StackLinkedList<int>();
  stack2.push(10);
  stack2.push(20);
  stack2.push(30);
  print('Стек до removeAll: $stack2');
  int removed2 = stack2.removeAll(99);
  print('Удалено элементов: $removed2'); // 0
  print('Размер стека: ${stack2.size}'); // 3
  print('Стек после removeAll: $stack2');
  print('');

  print('=== Тест 3: Удаление с вершины ===');
  final stack3 = StackLinkedList<int>();
  stack3.push(5);
  stack3.push(5);
  stack3.push(5);
  stack3.push(10);
  print('Стек до removeAll: $stack3');
  int removed3 = stack3.removeAll(5);
  print('Удалено элементов: $removed3'); // 3
  print('Размер стека: ${stack3.size}'); // 1
  print('Стек после removeAll: $stack3');
  print('peek(): ${stack3.peek()}'); // 10
  print('');

  print('=== Тест 4: Удаление с середины ===');
  final stack4 = StackLinkedList<int>();
  stack4.push(1);
  stack4.push(2);
  stack4.push(3);
  stack4.push(2);
  stack4.push(4);
  print('Стек до removeAll: $stack4');
  int removed4 = stack4.removeAll(2);
  print('Удалено элементов: $removed4'); // 2
  print('Размер стека: ${stack4.size}'); // 3
  print('Стек после removeAll: $stack4');
  print('');

  print('=== Тест 5: Удаление всех элементов ===');
  final stack5 = StackLinkedList<int>();
  stack5.push(7);
  stack5.push(7);
  stack5.push(7);
  print('Стек до removeAll: $stack5');
  int removed5 = stack5.removeAll(7);
  print('Удалено элементов: $removed5'); // 3
  print('Размер стека: ${stack5.size}'); // 0
  print('Стек после removeAll: $stack5');
  print('isEmpty: ${stack5.isEmpty}'); // true
}

