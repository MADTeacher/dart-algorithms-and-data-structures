// Задача 3: Линейное построение кучи (Floyd's Algorithm)
// Реализация метода buildLinear для построения кучи за O(N)

import 'dart:math';

class Heap<T extends Comparable<dynamic>> {
  List<T> _heap;
  final bool _isMaxHeap;

  Heap({bool isMaxHeap = true})
      : _heap = [],
        _isMaxHeap = isMaxHeap;

  factory Heap.fromList(
    List<T> list, {
    bool isMaxHeap = true,
  }) {
    Heap<T> heap = Heap<T>(isMaxHeap: isMaxHeap);
    for (T element in list) {
      heap.insert(element);
    }
    return heap;
  }

  /// Строит кучу за O(N) используя алгоритм Флойда.
  /// Присваивает список внутреннему массиву и вызывает _heapifyDown
  /// для всех нелистовых узлов, начиная с последнего родителя.
  factory Heap.buildLinear(
    List<T> list, {
    bool isMaxHeap = true,
  }) {
    Heap<T> heap = Heap<T>(isMaxHeap: isMaxHeap);
    heap._heap = List<T>.from(list);
    
    // Начинаем с последнего родителя и идем вверх к корню
    // Последний родитель находится на индексе (size - 2) ~/ 2
    for (int i = (heap._heap.length - 2) ~/ 2; i >= 0; i--) {
      heap._heapifyDown(i);
    }
    
    return heap;
  }

  int get size => _heap.length;
  bool get isEmpty => _heap.isEmpty;

  void insert(T value) {
    _heap.add(value);
    _heapifyUp(_heap.length - 1);
  }

  T extract() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty');
    }
    T extractedValue = _heap.first;
    _heap[0] = _heap.last;
    _heap.removeLast();
    if (!isEmpty) {
      _heapifyDown(0);
    }
    return extractedValue;
  }

  T peek() => _heap.first;

  void _heapifyUp(int i) {
    while (i != 0 && _compare(_heap[_parent(i)], _heap[i])) {
      _swap(_parent(i), i);
      i = _parent(i);
    }
  }

  void _heapifyDown(int i) {
    int largestOrSmallest = i;
    int left = _leftChild(i);
    int right = _rightChild(i);

    if (left < size &&
        _compare(
          _heap[largestOrSmallest],
          _heap[left],
        )) {
      largestOrSmallest = left;
    }
    if (right < size &&
        _compare(
          _heap[largestOrSmallest],
          _heap[right],
        )) {
      largestOrSmallest = right;
    }
    if (largestOrSmallest != i) {
      _swap(i, largestOrSmallest);
      _heapifyDown(largestOrSmallest);
    }
  }

  void _swap(int i, int j) {
    T temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }

  bool _compare(T parent, T child) {
    return _isMaxHeap
        ? parent.compareTo(child) < 0
        : parent.compareTo(child) > 0;
  }

  int _leftChild(int i) => 2 * i + 1;
  int _rightChild(int i) => 2 * i + 2;
  int _parent(int i) => (i - 1) ~/ 2;

  void change(int index, T value) {
    if (index < 0 || index >= _heap.length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }

    var oldValue = _heap[index];
    _heap[index] = value;
    if (_compare(oldValue, value)) {
      _heapifyUp(index);
    } else {
      _heapifyDown(index);
    }
  }

  @override
  String toString() {
    List<String> result = ['Heap\n'];
    if (!isEmpty) {
      _createStrHeap(result, '', 0, true, size);
    }
    return result.join();
  }

  void _createStrHeap(
    List<String> result,
    String prefix,
    int index,
    bool isTail,
    int heapSize,
  ) {
    int leftIndex = _leftChild(index);
    int rightIndex = _rightChild(index);

    if (rightIndex < heapSize) {
      String newPrefix = prefix + (isTail ? '│   ' : '    ');
      _createStrHeap(result, newPrefix, rightIndex, false, heapSize);
    }

    result.add('$prefix${isTail ? '└── ' : '┌── '} ${_heap[index]}\n');

    if (leftIndex < heapSize) {
      String newPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStrHeap(result, newPrefix, leftIndex, true, heapSize);
    }
  }
}

// Вспомогательная функция для проверок (работает в release mode)
void check(bool condition, String message) {
  if (!condition) {
    throw AssertionError('ОШИБКА ТЕСТА: $message');
  }
}

void main() {
  print('ТЕСТ 1: Cоздание кучи');
  var largeList = List.generate(100000, (i) => i);
  largeList.shuffle(Random(42));
  
  print('Размер массива: ${largeList.length} элементов');
  var heap1 = Heap.fromList(largeList, isMaxHeap: true);
  var heap2 = Heap.buildLinear(largeList, isMaxHeap: true);

  
  print('\nТЕСТ 2: Корректность построения кучи');
  print('heap1.peek(): ${heap1.peek()}');
  print('heap2.peek(): ${heap2.peek()}');
  check(heap1.peek() == heap2.peek(), 'Корневые элементы не совпадают');
  print('Оба метода дают одинаковый корневой элемент: ✅');
  
  print('\nТЕСТ 3: Проверка свойства кучи через извлечение');
  print('Извлекаем элементы из heap2:');
  List<int> extracted = [];
  int extractCount = 20;
  for (int i = 0; i < extractCount && !heap2.isEmpty; i++) {
    int value = heap2.extract();
    extracted.add(value);
    print('Extract: $value');
  }
  
  // Проверяем порядок
  bool isOrderCorrect = true;
  for (int i = 0; i < extracted.length - 1; i++) {
    if (extracted[i] < extracted[i + 1]) {
      isOrderCorrect = false;
      break;
    }
  }
  print('Порядок извлечения корректен: $isOrderCorrect');
  check(isOrderCorrect, 'Порядок не убывающий');
  
  print('\nТЕСТ 4: Сравнение всех извлеченных элементов');
  // Создаем новые кучи для полного сравнения
  var list1 = List<int>.generate(1000, (i) => i);
  list1.shuffle(Random(42));
  var list2 = List<int>.from(list1);
  
  var h1 = Heap.fromList(list1, isMaxHeap: true);
  var h2 = Heap.buildLinear(list2, isMaxHeap: true);
  
  List<int> all1 = [];
  List<int> all2 = [];
  
  while (!h1.isEmpty) {
    all1.add(h1.extract());
  }
  while (!h2.isEmpty) {
    all2.add(h2.extract());
  }
  
  print('Извлечено элементов из fromList: ${all1.length}');
  print('Извлечено элементов из buildLinear: ${all2.length}');
  check(all1.length == all2.length, 'Количество элементов не совпадает');
  
  bool allMatch = true;
  for (int i = 0; i < all1.length; i++) {
    if (all1[i] != all2[i]) {
      allMatch = false;
      break;
    }
  }
  print('Все элементы совпадают: $allMatch');
  check(allMatch, 'Последовательности извлечения не совпадают');
  
  print('\nТЕСТ 5: Минимальная куча');
  var smallList = [10, 5, 20, 3, 15, 7, 25];
  var minHeap1 = Heap.fromList(smallList, isMaxHeap: false);
  var minHeap2 = Heap.buildLinear(smallList, isMaxHeap: false);
  
  print('fromList peek: ${minHeap1.peek()}');
  print('buildLinear peek: ${minHeap2.peek()}');
  check(minHeap1.peek() == minHeap2.peek(), 'Корневые элементы не совпадают');
  
  // Проверяем порядок извлечения
  List<int> min1 = [];
  List<int> min2 = [];
  while (!minHeap1.isEmpty) {
    min1.add(minHeap1.extract());
  }
  while (!minHeap2.isEmpty) {
    min2.add(minHeap2.extract());
  }
  
  print('fromList извлечение: $min1');
  print('buildLinear извлечение: $min2');
  check(min1.toString() == min2.toString(), 'Последовательности не совпадают');
  
  print('\nТЕСТ 6: Пустой список');
  var emptyHeap1 = Heap.fromList(<int>[], isMaxHeap: true);
  var emptyHeap2 = Heap.buildLinear(<int>[], isMaxHeap: true);
  
  print('fromList isEmpty: ${emptyHeap1.isEmpty}');
  print('buildLinear isEmpty: ${emptyHeap2.isEmpty}');
  check(emptyHeap1.isEmpty && emptyHeap2.isEmpty, 'Кучи не пустые');
  
  print('\nТЕСТ 7: Один элемент');
  var singleHeap1 = Heap.fromList([42], isMaxHeap: true);
  var singleHeap2 = Heap.buildLinear([42], isMaxHeap: true);
  
  print('fromList peek: ${singleHeap1.peek()}');
  print('buildLinear peek: ${singleHeap2.peek()}');
  check(singleHeap1.peek() == singleHeap2.peek() && singleHeap1.peek() == 42, 'Корневые элементы не совпадают или не равны 42');
  
  print('\nТЕСТ 8: Два элемента');
  var twoHeap1 = Heap.fromList([10, 5], isMaxHeap: true);
  var twoHeap2 = Heap.buildLinear([10, 5], isMaxHeap: true);
  
  print('fromList: ${twoHeap1.peek()}');
  print('buildLinear: ${twoHeap2.peek()}');
  check(twoHeap1.peek() == twoHeap2.peek(), 'Корневые элементы не совпадают');
  
  int e1 = twoHeap1.extract();
  int e2 = twoHeap2.extract();
  print('fromList extract: $e1');
  print('buildLinear extract: $e2');
  check(e1 == e2, 'Извлеченные элементы не совпадают');
}

