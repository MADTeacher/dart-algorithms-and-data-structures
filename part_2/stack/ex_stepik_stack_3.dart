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

  /// Безопасное извлечение элемента без исключений.
  /// Возвращает null, если стек пуст, иначе возвращает верхний элемент.
  T? tryPop() {
    if (isEmpty) {
      return null;
    }
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
    return poppedElement;
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

  @override
  String toString() {
    return _items.toString();
  }
}

void main() {
  print('=== Тест 1: Пустой стек ===');
  final emptyStack = StackArray<int>();
  var val = emptyStack.tryPop();
  print('tryPop() из пустого стека: $val'); // null (ошибки нет)
  print('');

  print('=== Тест 2: Базовый tryPop ===');
  final stack = StackArray<int>();
  stack.push(1);
  stack.push(2);
  print('Стек: $stack');
  print('tryPop(): ${stack.tryPop()}'); // 2
  print('tryPop(): ${stack.tryPop()}'); // 1
  print('tryPop(): ${stack.tryPop()}'); // null
  print('');

  print('=== Тест 3: Один элемент ===');
  final singleStack = StackArray<int>();
  singleStack.push(42);
  print('Стек: $singleStack');
  print('tryPop(): ${singleStack.tryPop()}'); // 42
  print('tryPop(): ${singleStack.tryPop()}'); // null
  print('isEmpty: ${singleStack.isEmpty}'); // true
  print('');

  print('=== Тест 4: Чередование push/tryPop ===');
  final stack2 = StackArray<int>();
  stack2.push(10);
  print('После push(10): ${stack2.tryPop()}'); // 10
  stack2.push(20);
  stack2.push(30);
  print('После push(20), push(30): ${stack2.tryPop()}'); // 30
  print('После tryPop(): ${stack2.tryPop()}'); // 20
  print('После tryPop(): ${stack2.tryPop()}'); // null
  print('');

  print('=== Тест 5: tryPop с фиксированным стеком ===');
  final fixedStack = StackArray<int>(fixedSize: 3);
  fixedStack.push(100);
  fixedStack.push(200);
  print('Стек: $fixedStack, длина: ${fixedStack.length}');
  print('tryPop(): ${fixedStack.tryPop()}'); // 200
  print('tryPop(): ${fixedStack.tryPop()}'); // 100
  print('tryPop(): ${fixedStack.tryPop()}'); // null
  print('isEmpty: ${fixedStack.isEmpty}'); // true
}

