// Задача 4: Разделение списка на два (Метод split)
// Уровень по таксономии Блума: Анализ, Синтез.
//
// Добавьте в класс CyclicLinkedList<T> новый публичный метод split(),
// который разделяет список ровно пополам на два новых кольцевых списка.

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? nextPtr;
  _Node<T>? prevPtr;

  _Node(this.data);
}

class CyclicLinkedList<T extends Comparable<dynamic>> {
  int _length = 0;
  _Node<T>? _head;

  CyclicLinkedList();

  CyclicLinkedList.from(Iterable<T> list) {
    for (var element in list) {
      add(element);
    }
  }

  int get size => _length;

  int get length => _length;

  bool get isEmpty => _length == 0;

  void add(T data) {
    final node = _Node(data);
    if (isEmpty) {
      node.prevPtr = node;
      node.nextPtr = node;
      _head = node;
    } else {
      node.prevPtr = _head!.prevPtr;
      node.nextPtr = _head;
      _head!.prevPtr!.nextPtr = node;
      _head!.prevPtr = node;
      _head = node;
    }
    _length++;
  }

  void forEach(void Function(T) action) {
    if (_head == null) return;

    _Node<T> node = _head!;
    action(node.data);

    for (int i = 0; i < _length - 1; i++) {
      node = node.nextPtr!;
      action(node.data);
    }
  }

  void reverseForEach(void Function(T) action) {
    if (_head == null) return;

    _Node<T> node = _head!;
    action(node.data);

    for (int i = 0; i < _length - 1; i++) {
      node = node.prevPtr!;
      action(node.data);
    }
  }

  void rotate(int delta) {
    if (_length > 0) {
      if (delta < 0) {
        final scalingCoef = (_length - 1 - delta / _length).toInt();
        delta += scalingCoef * _length;
      }
      delta %= _length;

      if (delta > _length / 2) {
        delta = _length - delta;
        for (int i = 0; i < delta; i++) {
          _head = _head!.prevPtr;
        }
      } else if (delta == 0) {
        return;
      } else {
        for (int i = 0; i < delta; i++) {
          _head = _head!.nextPtr;
        }
      }
    }
  }

  bool remove() {
    if (isEmpty) {
      return false;
    }

    final currentNode = _head;
    final nextNode = currentNode!.nextPtr;
    final prevNode = currentNode.prevPtr;

    if (_length == 1) {
      _head = null;
    } else {
      _head = nextNode;
      nextNode!.prevPtr = prevNode;
      prevNode!.nextPtr = nextNode;
    }
    _length--;

    return true;
  }

  void removeAll() {
    while (remove()) {}
  }

  T value() {
    if (isEmpty) {
      throw StateError('List is empty');
    }
    return _head!.data;
  }

  // Временная сложность: O(n) - проходим до середины списка
  // Память: O(1) - только создаем новый список
  CyclicLinkedList<T> split() {
    var secondList = CyclicLinkedList<T>();

    // Если список пустой или содержит один элемент, возвращаем пустой список
    if (isEmpty || _length == 1) {
      return secondList;
    }

    // Вычисляем середину: если длина нечетная, первый список будет на 1 элемент больше
    int firstHalfLength = (_length + 1) ~/ 2; // Округление вверх
    int secondHalfLength = _length - firstHalfLength;

    // Находим узел, с которого начинается вторая половина
    // Проходим от _head до середины
    var current = _head;
    for (int i = 0; i < firstHalfLength; i++) {
      current = current!.nextPtr;
    }

    // current теперь указывает на начало второй половины
    var secondHalfStart = current!;
    var firstHalfEnd = secondHalfStart.prevPtr!;
    var secondHalfEnd = _head!.prevPtr!;

    // Сохраняем начало первой половины
    var firstHalfStart = _head!;

    // Разрываем цикл: замыкаем первую половину
    firstHalfStart.prevPtr = firstHalfEnd;
    firstHalfEnd.nextPtr = firstHalfStart;

    // Замыкаем вторую половину
    secondHalfStart.prevPtr = secondHalfEnd;
    secondHalfEnd.nextPtr = secondHalfStart;

    // Устанавливаем _head для второй половины
    secondList._head = secondHalfStart;
    secondList._length = secondHalfLength;

    // Обновляем длину первой половины (текущего списка)
    _length = firstHalfLength;

    return secondList;
  }

}

void main() {
  // Тест 1: Базовый тест из задания - четная длина
  var listA = CyclicLinkedList<int>();
  listA.add(1);
  listA.add(2);
  listA.add(3);
  listA.add(4);
  print('Исходный список A (четная длина):');
  listA.forEach((data) => print(data));
  print('Длина: ${listA.length}');
  
  var listB = listA.split();
  print('\nПосле split():');
  print('Список A (первая половина):');
  listA.forEach((data) => print(data));
  print('Длина A: ${listA.length} (должна быть 2)');
  
  print('\nСписок B (вторая половина):');
  listB.forEach((data) => print(data));
  print('Длина B: ${listB.length} (должна быть 2)');
  
  // Проверка корректности циклов
  print('\nПроверка корректности циклов:');
  print('A._head!.prevPtr!.nextPtr == A._head: ${listA._head!.prevPtr!.nextPtr == listA._head} (должно быть true)');
  print('B._head!.prevPtr!.nextPtr == B._head: ${listB._head!.prevPtr!.nextPtr == listB._head} (должно быть true)');
  
  // Тест 2: Нечетная длина
  var listC = CyclicLinkedList<int>();
  listC.add(1);
  listC.add(2);
  listC.add(3);
  listC.add(4);
  listC.add(5);
  print('\n\nИсходный список C (нечетная длина):');
  listC.forEach((data) => print(data));
  print('Длина: ${listC.length}');
  
  var listD = listC.split();
  print('\nПосле split():');
  print('Список C (первая половина):');
  listC.forEach((data) => print(data));
  print('Длина C: ${listC.length} (должна быть 3)');
  
  print('\nСписок D (вторая половина):');
  listD.forEach((data) => print(data));
  print('Длина D: ${listD.length} (должна быть 2)');
  
  // Тест 3: Список с одним элементом
  var singleList = CyclicLinkedList<int>();
  singleList.add(42);
  print('\n\nСписок с одним элементом:');
  singleList.forEach((data) => print(data));
  var emptySplit = singleList.split();
  print('После split():');
  print('Оригинал:');
  singleList.forEach((data) => print(data));
  print('Длина оригинала: ${singleList.length} (должна быть 1)');
  print('Длина результата split: ${emptySplit.length} (должна быть 0)');
  
  // Тест 4: Пустой список
  var emptyList = CyclicLinkedList<int>();
  var emptyResult = emptyList.split();
  print('\n\nПустой список:');
  print('Длина оригинала: ${emptyList.length}');
  print('Длина результата split: ${emptyResult.length} (должна быть 0)');
  
  // Тест 5: Список с двумя элементами
  var twoList = CyclicLinkedList<int>();
  twoList.add(10);
  twoList.add(20);
  print('\n\nСписок с двумя элементами:');
  twoList.forEach((data) => print(data));
  var twoSplit = twoList.split();
  print('После split():');
  print('Первая половина:');
  twoList.forEach((data) => print(data));
  print('Длина первой половины: ${twoList.length} (должна быть 1)');
  print('Вторая половина:');
  twoSplit.forEach((data) => print(data));
  print('Длина второй половины: ${twoSplit.length} (должна быть 1)');
}

