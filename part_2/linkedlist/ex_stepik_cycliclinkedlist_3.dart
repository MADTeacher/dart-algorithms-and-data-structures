// Задача 3: Проверка на равенство (Метод equals)
// Уровень по таксономии Блума: Анализ.
//
// Добавьте в класс CyclicLinkedList<T> новый публичный метод equals(CyclicLinkedList<T> other),
// который проверяет, содержат ли два кольцевых списка одинаковые элементы в одинаковом порядке,
// начиная с _head.

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

  // Временная сложность: O(n)
  // Память: O(1)
  bool equals(CyclicLinkedList<T> other) {
    // Сначала проверяем длины
    if (_length != other._length) {
      return false;
    }

    // Если оба списка пустые, они равны
    if (isEmpty && other.isEmpty) {
      return true;
    }

    // Если один пустой, а другой нет - не равны
    if (isEmpty || other.isEmpty) {
      return false;
    }

    // Сравниваем элементы, начиная с _head
    var currentA = _head;
    var currentB = other._head;

    // Проходим по всему списку
    for (int i = 0; i < _length; i++) {
      // Сравниваем данные узлов
      if (currentA!.data.compareTo(currentB!.data) != 0) {
        return false;
      }
      currentA = currentA.nextPtr;
      currentB = currentB.nextPtr;
    }

    return true;
  }

}

void main() {
  // Тест 1: Базовый тест из задания
  var listA = CyclicLinkedList<int>();
  listA.add(10);
  listA.add(20);
  listA.add(30);
  print('Список A:');
  listA.forEach((data) => print(data));
  
  var listB = CyclicLinkedList<int>();
  listB.add(10);
  listB.add(20);
  listB.add(30);
  print('\nСписок B:');
  listB.forEach((data) => print(data));
  
  print('\nA.equals(B): ${listA.equals(listB)}');
  
  // Тест 2: Списки с одинаковыми элементами, но разным порядком
  var listC = CyclicLinkedList<int>();
  listC.add(30);
  listC.add(10);
  listC.add(20);
  print('\nСписок C (те же элементы, но другой порядок):');
  listC.forEach((data) => print(data));
  print('A.equals(C): ${listA.equals(listC)}');
  
  // Тест 3: Списки разной длины
  var listD = CyclicLinkedList<int>();
  listD.add(10);
  listD.add(20);
  print('\nСписок D (короче):');
  listD.forEach((data) => print(data));
  print('A.equals(D): ${listA.equals(listD)}');
  
  // Тест 4: Пустые списки
  var emptyA = CyclicLinkedList<int>();
  var emptyB = CyclicLinkedList<int>();
  print('\nПустые списки:');
  print('emptyA.equals(emptyB): ${emptyA.equals(emptyB)}');
  
  // Тест 5: Один пустой, другой нет
  print('emptyA.equals(A): ${emptyA.equals(listA)}');
  print('A.equals(emptyA): ${listA.equals(emptyA)}');
  
  // Тест 6: Списки с одним элементом
  var singleA = CyclicLinkedList<int>();
  singleA.add(42);
  var singleB = CyclicLinkedList<int>();
  singleB.add(42);
  var singleC = CyclicLinkedList<int>();
  singleC.add(99);
  print('\nСписки с одним элементом:');
  print('singleA.equals(singleB): ${singleA.equals(singleB)}');
  print('singleA.equals(singleC): ${singleA.equals(singleC)}');
  
  // Тест 7: Списки с одинаковыми элементами в одинаковом порядке, но разной позицией _head
  // (это должно быть false, т.к. сравнение начинается с _head)
  var listE = CyclicLinkedList<int>();
  listE.add(10);
  listE.add(20);
  listE.add(30);
  listE.rotate(1); // Сдвигаем _head
  print('\nСписок E (те же элементы, но _head сдвинут):');
  listE.forEach((data) => print(data));
  print('A.equals(E): ${listA.equals(listE)}');
}

