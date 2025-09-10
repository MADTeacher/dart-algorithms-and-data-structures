import 'queue_array.dart';

class StackUsingQueue<T> {
  // Очередь для добавления элементов
  late ArrayQueue<T> _queue1;
  // Очередь для удаления элементов
  late ArrayQueue<T> _queue2;

  StackUsingQueue({int? fixedSize}) {
    _queue1 = ArrayQueue<T>(fixedSize: fixedSize);
    _queue2 = ArrayQueue<T>(fixedSize: fixedSize);
  }

  // Добавляем элемент на вершину стека
  void push(T element) {
    _queue1.enqueue(element);
  }

  // Удаляем и возвращаем элемент с вершины стека
  T pop() {
    if (_queue1.isEmpty) {
      throw StateError('Stack is empty');
    }

    // Перемещаем все элементы кроме последнего из queue1 в queue2
    while (_queue1.size > 1) {
      _queue2.enqueue(_queue1.dequeue());
    }

    // Последний элемент в queue1 - это вершина стека
    T topElement = _queue1.dequeue();

    // Меняем местами очереди
    var temp = _queue1;
    _queue1 = _queue2;
    _queue2 = temp;

    return topElement;
  }

  // Возвращаем элемент с вершины стека без удаления
  T peek() {
    if (_queue1.isEmpty) {
      throw StateError('Stack is empty');
    }

    // Перемещаем все элементы кроме последнего из queue1 в queue2
    while (_queue1.size > 1) {
      _queue2.enqueue(_queue1.dequeue());
    }

    // Последний элемент в queue1 - это вершина стека
    T topElement = _queue1.peek();
    _queue2.enqueue(_queue1.dequeue());

    // Меняем местами очереди
    var temp = _queue1;
    _queue1 = _queue2;
    _queue2 = temp;

    return topElement;
  }

  // Проверяем, пуст ли стек
  bool get isEmpty => _queue1.isEmpty;

  // Возвращаем размер стека
  int get size => _queue1.size;

  // Очищаем стек
  void clear() {
    _queue1.clear();
    _queue2.clear();
  }

  @override
  String toString() {
    return 'Stack: ${_queue1.toString()}';
  }
}

void main() {
  var stack = StackUsingQueue<int>();

  print('Стек пуст: ${stack.isEmpty}');
  print('Размер стека: ${stack.size}');

  // Добавляем элементы в стек
  print('\nДобавляем элементы: 1, 2, 3, 4');
  stack.push(1);
  stack.push(2);
  stack.push(3);
  stack.push(4);

  print('Размер стека: ${stack.size}');
  print('Стек: $stack');

  // Смотрим на вершину стека
  print('\nВершина стека (peek): ${stack.peek()}');
  print('Размер стека после peek: ${stack.size}');

  // Извлекаем элементы из стека
  print('\nИзвлекаем элементы из стека:');
  while (!stack.isEmpty) {
    print('Pop: ${stack.pop()}');
    print('Размер стека: ${stack.size}');
  }

  print('\nСтек пуст: ${stack.isEmpty}');

  // Попытка извлечь из пустого стека
  try {
    stack.pop();
  } on StateError catch (e) {
    print('Ошибка: $e');
  }
}
