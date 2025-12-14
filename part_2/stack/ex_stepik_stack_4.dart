class StackArray<T> {
  final List<T?> _items;
  final int _capacity;
  int _top = -1;

  // если fixedSize не задано, стек - динамический
  StackArray({int fixedSize = 0})
    : _capacity = fixedSize,
      _items = List<T?>.filled(fixedSize, null, growable: fixedSize == 0);

  bool get isFull => _top >= _capacity - 1 && _capacity > 0;
  bool get isEmpty => _top < 0;
  int get length => _top + 1;

  void push(T element) {
    if (_capacity == 0) {
      _items.add(element);
      _top++;
    } else {
      if (isFull) {
        throw StackOverflowError();
      } else {
        _items[++_top] = element;
      }
    }
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop from an empty stack.");
    } else {
      T? poppedElement;
      if (_capacity == 0) {
        // Для динамического стека используем removeLast()
        poppedElement = _items.removeLast();
        _top--;
      } else {
        // Для фиксированного стека устанавливаем null
        poppedElement = _items[_top];
        _items[_top--] = null;
      }
      if (poppedElement == null) {
        throw StateError("Cannot pop null element from stack.");
      }
      return poppedElement;
    }
  }

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek from an empty stack.");
    } else {
      return _items[_top]!;
    }
  }

  void clear() {
    _items.clear();
    _top = -1;
  }

  /// Удаляет элементы с вершины стека до тех пор, пока не встретит указанный element.
  /// Сам element также удаляется.
  /// Если элемент не найден, стек полностью очищается.
  /// Возвращает количество удаленных элементов.
  int popUntil(T element) {
    int removedCount = 0;
    bool found = false;

    // Ищем элемент, начиная с вершины
    while (!isEmpty && !found) {
      final current = _items[_top];
      if (_capacity == 0) {
        _items.removeLast();
        _top--;
      } else {
        _items[_top--] = null;
      }
      removedCount++;
      if (current == element) {
        found = true;
      }
    }

    // Если элемент не найден, стек уже очищен в цикле выше
    return removedCount;
  }

  @override
  String toString() {
    if (isEmpty) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    for (int i = 0; i <= _top; i++) {
      if (i > 0) buffer.write(', ');
      buffer.write(_items[i]);
    }
    buffer.write(']');
    return buffer.toString();
  }
}

void main() {
  print('=== Тест 1: Базовый popUntil ===');
  final stack = StackArray<int>();
  stack.push(10);
  stack.push(20);
  stack.push(30);
  print('Стек до popUntil: $stack');
  int count = stack.popUntil(20);
  print('Удалено элементов: $count'); // 2
  print('Стек после popUntil: $stack'); // [10]
  print('');

  print('=== Тест 2: Элемент не найден ===');
  final stack2 = StackArray<int>();
  stack2.push(1);
  stack2.push(2);
  stack2.push(3);
  print('Стек до popUntil (элемент не найден): $stack2');
  int count2 = stack2.popUntil(99);
  print('Удалено элементов: $count2'); // 3
  print('Стек после popUntil: $stack2'); // []
  print('isEmpty: ${stack2.isEmpty}'); // true
  print('');

  print('=== Тест 3: Элемент на вершине ===');
  final stack3 = StackArray<int>();
  stack3.push(5);
  stack3.push(6);
  stack3.push(7);
  print('Стек до popUntil: $stack3');
  int count3 = stack3.popUntil(7);
  print('Удалено элементов: $count3'); // 1
  print('Стек после popUntil: $stack3'); // [5, 6]
  print('');

  print('=== Тест 4: Элемент внизу ===');
  final stack4 = StackArray<int>();
  stack4.push(100);
  stack4.push(200);
  stack4.push(300);
  print('Стек до popUntil: $stack4');
  int count4 = stack4.popUntil(100);
  print('Удалено элементов: $count4'); // 3
  print('Стек после popUntil: $stack4'); // []
  print('');

  print('=== Тест 5: Несколько одинаковых элементов ===');
  final stack5 = StackArray<int>();
  stack5.push(1);
  stack5.push(2);
  stack5.push(2);
  stack5.push(3);
  print('Стек до popUntil: $stack5');
  int count5 = stack5.popUntil(2);
  print('Удалено элементов: $count5'); // 2 (удалит 3 и первый 2)
  print('Стек после popUntil: $stack5'); // [1, 2]
}

