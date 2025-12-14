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

  /// Меняет местами два верхних элемента стека.
  /// Выбрасывает StateError, если в стеке менее двух элементов.
  void swap() {
    if (length < 2) {
      throw StateError("Cannot swap: stack has less than 2 elements.");
    }
    final temp = _items[_top];
    _items[_top] = _items[_top - 1];
    _items[_top - 1] = temp;
  }

  @override
  String toString() {
    return _items.toString();
  }
}

void main() {
  print('=== Тест 1: Базовый swap ===');
  final stack = StackArray<int>();
  stack.push(1);
  stack.push(2);
  print('До swap: $stack');
  stack.swap();
  print('После swap: $stack');
  print('pop(): ${stack.pop()}'); // Должно вывести 1
  print('pop(): ${stack.pop()}'); // Должно вывести 2
  print('');

  print('=== Тест 2: Swap с пустым стеком ===');
  final emptyStack = StackArray<int>();
  try {
    emptyStack.swap();
  } on StateError catch (e) {
    print('Ошибка (ожидаемая): $e');
  }
  print('');

  print('=== Тест 3: Swap с одним элементом ===');
  final singleStack = StackArray<int>();
  singleStack.push(1);
  try {
    singleStack.swap();
  } on StateError catch (e) {
    print('Ошибка (ожидаемая): $e');
  }
  print('');

  print('=== Тест 4: Swap после нескольких операций ===');
  final stack2 = StackArray<int>();
  stack2.push(10);
  stack2.push(20);
  stack2.push(30);
  stack2.push(40);
  print('До swap: $stack2, длина: ${stack2.length}');
  stack2.swap();
  print('После swap: $stack2');
  print('peek(): ${stack2.peek()}'); // 30
  print('pop(): ${stack2.pop()}'); // 30
  print('pop(): ${stack2.pop()}'); // 40
  print('');

  print('=== Тест 5: Swap с фиксированным стеком ===');
  final fixedStack = StackArray<int>(fixedSize: 5);
  fixedStack.push(100);
  fixedStack.push(200);
  print('До swap: $fixedStack');
  fixedStack.swap();
  print('После swap: $fixedStack');
  print('pop(): ${fixedStack.pop()}'); // 100
  print('pop(): ${fixedStack.pop()}'); // 200
}

