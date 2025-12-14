// Задача 4: Обновление приоритета (Update Key)
// Реализация метода update для обновления значения элемента

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
    if (!isEmpty) {
      _heapifyDown(0);
    }
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

  /// Находит oldValue в куче, заменяет его на newValue
  /// и восстанавливает свойства кучи.
  /// Вызывает либо _heapifyUp, либо _heapifyDown только для измененного узла.
  void update(T oldValue, T newValue) {
    int index = indexOf(oldValue);
    if (index == -1) {
      throw ArgumentError('Element $oldValue not found in heap');
    }

    _heap[index] = newValue;
    
    // Определяем, нужно ли двигаться вверх или вниз
    // Если новое значение больше (для max heap) или меньше (для min heap),
    // чем старое, то нужно двигаться вверх
    bool shouldMoveUp = _isMaxHeap
        ? newValue.compareTo(oldValue) > 0
        : newValue.compareTo(oldValue) < 0;

    if (shouldMoveUp) {
      _heapifyUp(index);
    } else {
      _heapifyDown(index);
    }
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
  print('=' * 60);
  print('ТЕСТ 1: MaxHeap - увеличение приоритета (всплытие)');
  print('=' * 60);
  var maxHeap = Heap.fromList([100, 50, 20], isMaxHeap: true);
  print('Исходная куча:');
  print(maxHeap);
  int initialRoot = maxHeap.peek();
  print('peek(): $initialRoot');
  
  print('\nОбновляем 20 -> 200');
  maxHeap.update(20, 200);
  print('Куча после update:');
  print(maxHeap);
  int newRoot = maxHeap.peek();
  print('peek(): $newRoot');
  check(newRoot == 200, 'Корневой элемент не равен 200');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 2: MaxHeap - уменьшение приоритета (погружение)');
  print('=' * 60);
  print('Обновляем 200 -> 1');
  maxHeap.update(200, 1);
  print('Куча после update:');
  print(maxHeap);
  int rootAfterDecrease = maxHeap.peek();
  print('peek(): $rootAfterDecrease');
  check(rootAfterDecrease == 100, 'Корневой элемент не равен 100');
  
  // Проверяем, что 1 действительно внизу
  print('\nИзвлекаем все элементы:');
  List<int> extracted = [];
  while (!maxHeap.isEmpty) {
    int value = maxHeap.extract();
    extracted.add(value);
    print('Extract: $value');
  }
  print('Извлеченные значения: $extracted');
  
  // Проверяем порядок
  bool isOrderCorrect = true;
  for (int i = 0; i < extracted.length - 1; i++) {
    if (extracted[i] < extracted[i + 1]) {
      isOrderCorrect = false;
      break;
    }
  }
  print('Порядок корректен: $isOrderCorrect');
  check(isOrderCorrect, 'Порядок не убывающий');
  check(extracted.last == 1, 'Элемент 1 не последний');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 3: MinHeap - уменьшение приоритета (всплытие)');
  print('=' * 60);
  var minHeap = Heap.fromList([1, 5, 10, 20], isMaxHeap: false);
  print('Исходная куча:');
  print(minHeap);
  int minInitialRoot = minHeap.peek();
  print('peek(): $minInitialRoot');
  
  print('\nОбновляем 20 -> 0');
  minHeap.update(20, 0);
  print('Куча после update:');
  print(minHeap);
  int minNewRoot = minHeap.peek();
  print('peek(): $minNewRoot');
  check(minNewRoot == 0, 'Корневой элемент не равен 0');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 4: MinHeap - увеличение приоритета (погружение)');
  print('=' * 60);
  print('Обновляем 0 -> 15');
  minHeap.update(0, 15);
  print('Куча после update:');
  print(minHeap);
  int minRootAfterIncrease = minHeap.peek();
  print('peek(): $minRootAfterIncrease');
  check(minRootAfterIncrease == 1, 'Корневой элемент не равен 1');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 5: Обновление без изменения позиции');
  print('=' * 60);
  var stableHeap = Heap.fromList([100, 50, 75, 25, 30], isMaxHeap: true);
  print('Исходная куча:');
  print(stableHeap);
  int stableRoot = stableHeap.peek();
  print('Корень: $stableRoot');
  
  // Обновляем элемент на такое же значение (относительно других)
  print('\nОбновляем 50 -> 60 (небольшое изменение)');
  stableHeap.update(50, 60);
  print('Куча после update:');
  print(stableHeap);
  int stableRootAfter = stableHeap.peek();
  print('Корень после: $stableRootAfter');
  check(stableRootAfter == stableRoot, 'Корень изменился');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 6: Обновление корневого элемента');
  print('=' * 60);
  var rootHeap = Heap.fromList([100, 50, 75], isMaxHeap: true);
  print('Исходная куча:');
  print(rootHeap);
  int rootValue = rootHeap.peek();
  print('Корень: $rootValue');
  
  print('\nОбновляем корень 100 -> 200');
  rootHeap.update(rootValue, 200);
  print('Куча после update:');
  print(rootHeap);
  int newRootValue = rootHeap.peek();
  print('Новый корень: $newRootValue');
  check(newRootValue == 200, 'Корень не равен 200');
  
  print('\nОбновляем корень 200 -> 10');
  rootHeap.update(200, 10);
  print('Куча после update:');
  print(rootHeap);
  int finalRoot = rootHeap.peek();
  print('Новый корень: $finalRoot');
  check(finalRoot == 75, 'Корень не равен 75');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 7: Обновление несуществующего элемента');
  print('=' * 60);
  var testHeap = Heap.fromList([10, 20, 30], isMaxHeap: true);
  try {
    testHeap.update(999, 1000);
    check(false, 'Исключение не выброшено');
  } catch (e) {
    print('Поймано исключение: $e');
    check(e is ArgumentError, 'Исключение не ArgumentError');
  }
  
  print('\n' + '=' * 60);
  print('ТЕСТ 8: Множественные обновления');
  print('=' * 60);
  var multiHeap = Heap.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], isMaxHeap: true);
  print('Исходная куча (size: ${multiHeap.size}):');
  print('Корень: ${multiHeap.peek()}');
  
  print('\nВыполняем серию обновлений:');
  multiHeap.update(1, 50);
  print('1 -> 50, корень: ${multiHeap.peek()}');
  check(multiHeap.peek() == 50, 'Корень не равен 50');
  
  multiHeap.update(2, 60);
  print('2 -> 60, корень: ${multiHeap.peek()}');
  check(multiHeap.peek() == 60, 'Корень не равен 60');
  
  multiHeap.update(3, 70);
  print('3 -> 70, корень: ${multiHeap.peek()}');
  check(multiHeap.peek() == 70, 'Корень не равен 70');
  
  multiHeap.update(70, 5);
  print('70 -> 5, корень: ${multiHeap.peek()}');
  check(multiHeap.peek() == 60, 'Корень не равен 60');
  
  print('\nПроверяем финальное состояние через извлечение:');
  List<int> finalExtracted = [];
  while (!multiHeap.isEmpty) {
    finalExtracted.add(multiHeap.extract());
  }
  print('Извлеченные значения: $finalExtracted');
  
  bool isFinalOrderCorrect = true;
  for (int i = 0; i < finalExtracted.length - 1; i++) {
    if (finalExtracted[i] < finalExtracted[i + 1]) {
      isFinalOrderCorrect = false;
      break;
    }
  }
  print('Порядок корректен: $isFinalOrderCorrect');
  check(isFinalOrderCorrect, 'Порядок извлечения некорректен');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 9: Обновление на то же значение');
  print('=' * 60);
  var sameHeap = Heap.fromList([10, 20, 30], isMaxHeap: true);
  int sameRoot = sameHeap.peek();
  print('Исходный корень: $sameRoot');
  
  sameHeap.update(20, 20);
  int sameRootAfter = sameHeap.peek();
  print('Корень после update(20, 20): $sameRootAfter');
  check(sameRootAfter == sameRoot, 'Корень изменился');
  
  print('\n✅ Все тесты пройдены успешно!');
}

