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

  /// Оставляет в стеке только те элементы, которые удовлетворяют условию predicate.
  /// Остальные удаляются. Реализовано без создания нового массива.
  void retainWhere(bool Function(T) predicate) {
    if (isEmpty) return;

    int writeIndex = 0;
    // Проходим по всем элементам стека
    for (int readIndex = 0; readIndex <= _top; readIndex++) {
      final element = _items[readIndex];
      if (element != null && predicate(element)) {
        // Элемент удовлетворяет условию - оставляем его
        if (writeIndex != readIndex) {
          _items[writeIndex] = element;
        }
        writeIndex++;
      } else {
        // Элемент не удовлетворяет условию - пропускаем
        if (_capacity > 0) {
          // Для фиксированного стека устанавливаем null
          if (readIndex == _top) {
            _items[readIndex] = null;
          }
        }
      }
    }

    // Обновляем _top и очищаем хвост для динамического стека
    if (_capacity == 0) {
      // Удаляем лишние элементы с конца
      while (_items.length > writeIndex) {
        _items.removeLast();
      }
    } else {
      // Для фиксированного стека обнуляем элементы после writeIndex
      for (int i = writeIndex; i <= _top; i++) {
        _items[i] = null;
      }
    }
    _top = writeIndex - 1;
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
  print('=== Тест 1: Базовый retainWhere (четные числа) ===');
  final stack = StackArray<int>();
  stack.push(1);
  stack.push(2);
  stack.push(3);
  stack.push(4);
  print('Стек до retainWhere: $stack');
  // Оставляем только четные числа
  stack.retainWhere((x) => x % 2 == 0);
  print('Стек после retainWhere: $stack');
  print('Длина: ${stack.length}'); // 2
  print('pop(): ${stack.pop()}'); // 4
  print('pop(): ${stack.pop()}'); // 2
  print('');

  print('=== Тест 2: Пустой стек ===');
  final emptyStack = StackArray<int>();
  print('Пустой стек: $emptyStack');
  emptyStack.retainWhere((x) => x > 0);
  print('После retainWhere: $emptyStack');
  print('isEmpty: ${emptyStack.isEmpty}'); // true
  print('');

  print('=== Тест 3: Все элементы удаляются ===');
  final stack2 = StackArray<int>();
  stack2.push(1);
  stack2.push(3);
  stack2.push(5);
  print('Стек до retainWhere: $stack2');
  stack2.retainWhere((x) => x % 2 == 0); // Все нечетные
  print('Стек после retainWhere: $stack2');
  print('isEmpty: ${stack2.isEmpty}'); // true
  print('');

  print('=== Тест 4: Все элементы остаются ===');
  final stack3 = StackArray<int>();
  stack3.push(2);
  stack3.push(4);
  stack3.push(6);
  print('Стек до retainWhere: $stack3');
  stack3.retainWhere((x) => x % 2 == 0); // Все четные
  print('Стек после retainWhere: $stack3');
  print('Длина: ${stack3.length}'); // 3
  print('');

  print('=== Тест 5: Сложное условие (числа > 10) ===');
  final stack4 = StackArray<int>();
  stack4.push(5);
  stack4.push(15);
  stack4.push(8);
  stack4.push(20);
  stack4.push(3);
  print('Стек до retainWhere: $stack4');
  stack4.retainWhere((x) => x > 10);
  print('Стек после retainWhere: $stack4');
  print('Длина: ${stack4.length}'); // 2
  print('pop(): ${stack4.pop()}'); // 20
  print('pop(): ${stack4.pop()}'); // 15
}

