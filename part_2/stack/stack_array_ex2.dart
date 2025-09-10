import 'stack_array.dart';

// Реализация очереди (FIFO) с помощью двух стеков
// Временная сложность:
// - enqueue: O(1)
// - dequeue: O(n) в худшем случае, в среднем O(1)
// - peek: O(n) в худшем случае, в среднем O(1)
// Память: O(n)
class QueueWithTwoStacks<T> {
  final StackArray<T> _inputStack; // Стек для добавления элементов
  final StackArray<T> _outputStack; // Стек для извлечения элементов

  QueueWithTwoStacks()
    : _inputStack = StackArray<T>(),
      _outputStack = StackArray<T>();

  // Добавляем элемент в конец очереди
  void enqueue(T element) {
    _inputStack.push(element);
  }

  // Извлекаем и возвращаем первый элемент из очереди
  T dequeue() {
    if (isEmpty) {
      throw StateError("Cannot dequeue from an empty queue.");
    }

    // Если выходной стек пуст, перемещаем все элементы из входного стека
    if (_outputStack.isEmpty) {
      _moveInputToOutput();
    }

    return _outputStack.pop();
  }

  // Возвращаем первый элемент очереди без его извлечения
  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek from an empty queue.");
    }

    // Если выходной стек пуст, перемещаем все элементы из входного стека
    if (_outputStack.isEmpty) {
      _moveInputToOutput();
    }

    return _outputStack.peek();
  }

  // Проверяем, пуста ли очередь
  bool get isEmpty => _inputStack.isEmpty && _outputStack.isEmpty;

  // Возвращаем количество элементов в очереди
  int get length => _inputStack.length + _outputStack.length;

  // Перемещаем все элементы из входного стека в выходной стек
  void _moveInputToOutput() {
    while (!_inputStack.isEmpty) {
      _outputStack.push(_inputStack.pop());
    }
  }

  // Очищаем очередь
  void clear() {
    _inputStack.clear();
    _outputStack.clear();
  }

  @override
  String toString() {
    if (isEmpty) return '[]';

    // Сохраняем все элементы
    final currentElements = <T>[];
    while (!isEmpty) {
      final element = dequeue();
      currentElements.add(element);
    }

    // Восстанавливаем очередь
    for (final element in currentElements) {
      enqueue(element);
    }

    return currentElements.toString();
  }
}

void main() {
  final queue = QueueWithTwoStacks<int>();
  queue.enqueue(10);
  queue.enqueue(20);
  print('Извлекли: ${queue.dequeue()}');
  queue.enqueue(30);
  queue.enqueue(40);
  print('Первый элемент: ${queue.peek()}');
  print('Извлекли: ${queue.dequeue()}');
  print('Извлекли: ${queue.dequeue()}');
  print('Извлекли: ${queue.dequeue()}');
  print('Очередь пуста: ${queue.isEmpty}');

  try {
    queue.dequeue();
  } on StateError catch (e) {
    print(e);
  }
}
