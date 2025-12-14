// Задача 1: Поиск индекса элемента
// Реализация метода indexOf для поиска индекса элемента в куче

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
    _heapifyDown(0);
    return extractedValue;
  }

  T peek() => _heap.first;

  /// Возвращает индекс первого вхождения элемента в куче.
  /// Если элемент не найден, возвращает -1.
  int indexOf(T value) {
    for (int i = 0; i < _heap.length; i++) {
      if (_heap[i].compareTo(value) == 0) {
        return i;
      }
    }
    return -1;
  }

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
  print('ТЕСТ 1: Поиск существующего элемента в MaxHeap');
  var heap = Heap.fromList([10, 5, 20, 3, 15], isMaxHeap: true);
  print('Куча: $heap');
  
  // Проверяем все элементы
  var testValues = [10, 5, 20, 3, 15];
  for (var value in testValues) {
    int index = heap.indexOf(value);
    print('indexOf($value) = $index');
    check(index >= 0, 'Элемент $value не найден');
  }
  
  print('\nТЕСТ 2: Поиск несуществующего элемента');
  int notFound = heap.indexOf(100);
  print('indexOf(100) = $notFound');
  check(notFound == -1, 'Несуществующий элемент вернул не -1');
  
  int notFound2 = heap.indexOf(-5);
  print('indexOf(-5) = $notFound2');
  check(notFound2 == -1, 'Несуществующий элемент вернул не -1');
  
  print('\nТЕСТ 3: Поиск в MinHeap');
  var minHeap = Heap.fromList([10, 5, 20, 3, 15], isMaxHeap: false);
  print('Min Heap: $minHeap');
  
  for (var value in testValues) {
    int index = minHeap.indexOf(value);
    print('indexOf($value) = $index');
    check(index >= 0, 'Элемент $value не найден');
  }
  
  print('indexOf(99) = ${minHeap.indexOf(99)}');
  check(minHeap.indexOf(99) == -1, 'Несуществующий элемент вернул не -1');
  
  print('\nТЕСТ 4: Поиск после операций insert/extract');
  var dynamicHeap = Heap<int>(isMaxHeap: true);
  dynamicHeap.insert(50);
  dynamicHeap.insert(30);
  dynamicHeap.insert(70);
  dynamicHeap.insert(10);
  
  print('Куча после вставки: $dynamicHeap');
  print('indexOf(50) = ${dynamicHeap.indexOf(50)}');
  print('indexOf(70) = ${dynamicHeap.indexOf(70)}');
  check(dynamicHeap.indexOf(50) >= 0, 'Элемент 50 не найден');
  check(dynamicHeap.indexOf(70) >= 0, 'Элемент 70 не найден');
  
  int extracted = dynamicHeap.extract();
  print('\nИзвлечен элемент: $extracted');
  print('Куча после extract: $dynamicHeap');
  
  // Проверяем, что извлеченный элемент больше не найден
  int indexAfterExtract = dynamicHeap.indexOf(extracted);
  print('indexOf($extracted) после extract = $indexAfterExtract');
  check(indexAfterExtract == -1, 'Извлеченный элемент найден');
  
  // Проверяем оставшиеся элементы
  print('indexOf(30) = ${dynamicHeap.indexOf(30)}');
  print('indexOf(10) = ${dynamicHeap.indexOf(10)}');
  check(dynamicHeap.indexOf(30) >= 0, 'Элемент 30 не найден');
  check(dynamicHeap.indexOf(10) >= 0, 'Элемент 10 не найден');
  
  print('\nТЕСТ 5: Поиск в пустой куче');
  var emptyHeap = Heap<int>(isMaxHeap: true);
  int emptyIndex = emptyHeap.indexOf(5);
  print('indexOf(5) в пустой куче = $emptyIndex');
  check(emptyIndex == -1, 'В пустой куче вернулся не -1');
  
  print('\nТЕСТ 6: Поиск дубликатов');
  var duplicateHeap = Heap.fromList([5, 5, 5, 10, 10], isMaxHeap: true);
  print('Куча с дубликатами: $duplicateHeap');
  int firstIndex = duplicateHeap.indexOf(5);
  print('indexOf(5) = $firstIndex');
  check(firstIndex >= 0, 'Элемент 5 не найден');
  
  int firstIndex10 = duplicateHeap.indexOf(10);
  print('indexOf(10) = $firstIndex10');
  check(firstIndex10 >= 0, 'Элемент 10 не найден');
}

