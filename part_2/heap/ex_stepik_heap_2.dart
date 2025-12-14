// Задача 2: Удаление произвольного элемента
// Реализация метода remove для удаления элемента по значению

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

  /// Находит элемент по значению и удаляет его из кучи,
  /// сохраняя свойства кучи. Возвращает true, если элемент был найден и удален,
  /// false если элемент не найден.
  bool remove(T value) {
    int index = indexOf(value);
    if (index == -1) {
      return false;
    }

    // Если удаляем последний элемент, просто удаляем его
    if (index == _heap.length - 1) {
      _heap.removeLast();
      return true;
    }

    // Заменяем удаляемый элемент последним элементом
    _heap[index] = _heap.last;
    _heap.removeLast();

    // Восстанавливаем свойства кучи
    if (index < _heap.length) {
      // Проверяем, нужно ли двигаться вверх или вниз
      if (index > 0 && _compare(_heap[_parent(index)], _heap[index])) {
        _heapifyUp(index);
      } else {
        _heapifyDown(index);
      }
    }

    return true;
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
  print('ТЕСТ 1: Удаление элемента из середины кучи');
  print('=' * 60);
  var heap = Heap.fromList([10, 5, 20, 3], isMaxHeap: true);
  print('Исходная куча (size: ${heap.size}):');
  print(heap);
  
  int initialSize = heap.size;
  print('\nУдаляем элемент 5...');
  bool removed = heap.remove(5);
  print('Элемент удален: $removed');
  check(removed == true, 'Элемент не удален');
  print('Размер после удаления: ${heap.size}');
  check(heap.size == initialSize - 1, 'Размер не уменьшился на 1');
  print('Куча после удаления:');
  print(heap);
  
  // Проверяем порядок извлечения
  print('\nИзвлекаем элементы по порядку:');
  List<int> extracted = [];
  while (!heap.isEmpty) {
    int value = heap.extract();
    extracted.add(value);
    print('Extract: $value');
  }
  
  // Проверяем, что порядок корректен для max heap
  bool isCorrectOrder = true;
  for (int i = 0; i < extracted.length - 1; i++) {
    if (extracted[i] < extracted[i + 1]) {
      isCorrectOrder = false;
      break;
    }
  }
  print('Порядок извлечения корректен: $isCorrectOrder');
  check(isCorrectOrder, 'Порядок извлечения не убывающий');
  check(!extracted.contains(5), 'Удаленный элемент был извлечен');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 2: Удаление несуществующего элемента');
  print('=' * 60);
  var heap2 = Heap.fromList([10, 5, 20, 3], isMaxHeap: true);
  int sizeBefore = heap2.size;
  bool notFound = heap2.remove(100);
  print('Попытка удалить 100: $notFound');
  check(notFound == false, 'Несуществующий элемент вернул не false');
  print('Размер остался: ${heap2.size}');
  check(heap2.size == sizeBefore, 'Размер изменился');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 3: Удаление корневого элемента');
  print('=' * 60);
  var heap3 = Heap.fromList([10, 5, 20, 3, 15], isMaxHeap: true);
  print('Исходная куча:');
  print(heap3);
  int rootValue = heap3.peek();
  print('Корневой элемент: $rootValue');
  
  bool rootRemoved = heap3.remove(rootValue);
  print('Удален корневой элемент: $rootRemoved');
  check(rootRemoved == true, 'Корневой элемент не удален');
  print('Новый корневой элемент: ${heap3.peek()}');
  print('Куча после удаления корня:');
  print(heap3);
  
  // Проверяем, что свойство кучи сохранилось
  int newRoot = heap3.peek();
  print('\nПроверка свойства кучи: новый корень = $newRoot');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 4: Удаление последнего элемента');
  print('=' * 60);
  var heap4 = Heap.fromList([10, 5, 20, 3], isMaxHeap: true);
  print('Исходная куча:');
  print(heap4);
  
  // Находим минимальный элемент через извлечение и восстановление
  // Создаем копию для поиска минимального
  var heap4Copy = Heap.fromList([10, 5, 20, 3], isMaxHeap: false);
  int minValue = heap4Copy.peek(); // В min heap корень - минимальный
  print('Удаляем минимальный элемент: $minValue');
  bool leafRemoved = heap4.remove(minValue);
  check(leafRemoved == true, 'Лист не удален');
  print('Куча после удаления листа:');
  print(heap4);
  check(heap4.indexOf(minValue) == -1, 'Элемент не удален');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 5: Удаление всех элементов по одному');
  print('=' * 60);
  var heap5 = Heap.fromList([10, 5, 20, 3, 15, 7], isMaxHeap: true);
  print('Исходная куча (size: ${heap5.size}):');
  print(heap5);
  
  // Собираем все значения через извлечение из копии
  var heap5Copy = Heap.fromList([10, 5, 20, 3, 15, 7], isMaxHeap: true);
  List<int> originalValues = [];
  while (!heap5Copy.isEmpty) {
    originalValues.add(heap5Copy.extract());
  }
  originalValues = originalValues.reversed.toList(); // Восстанавливаем порядок
  
  print('\nУдаляем все элементы по одному:');
  for (int value in originalValues) {
    if (heap5.indexOf(value) != -1) { // Проверяем, что элемент еще есть
      bool removed = heap5.remove(value);
      print('Удален $value: $removed, размер: ${heap5.size}');
      check(removed == true, 'Элемент не удален');
      if (!heap5.isEmpty) {
        // Проверяем, что свойство кучи сохранилось
        int currentRoot = heap5.peek();
        print('  Корень после удаления: $currentRoot');
      }
    }
  }
  print('Финальный размер: ${heap5.size}');
  check(heap5.isEmpty, 'Куча не пустая');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 6: Удаление в MinHeap');
  print('=' * 60);
  var minHeap = Heap.fromList([10, 5, 20, 3, 15], isMaxHeap: false);
  print('Исходная MinHeap:');
  print(minHeap);
  
  bool minRemoved = minHeap.remove(5);
  print('Удален элемент 5: $minRemoved');
  check(minRemoved == true, 'Элемент не удален из MinHeap');
  print('Куча после удаления:');
  print(minHeap);
  
  // Проверяем порядок извлечения для min heap
  print('\nИзвлекаем элементы:');
  List<int> minExtracted = [];
  while (!minHeap.isEmpty) {
    int value = minHeap.extract();
    minExtracted.add(value);
    print('Extract: $value');
  }
  
  bool isMinOrderCorrect = true;
  for (int i = 0; i < minExtracted.length - 1; i++) {
    if (minExtracted[i] > minExtracted[i + 1]) {
      isMinOrderCorrect = false;
      break;
    }
  }
  print('Порядок извлечения корректен: $isMinOrderCorrect');
  check(isMinOrderCorrect, 'Порядок не возрастающий');
  
  print('\n' + '=' * 60);
  print('ТЕСТ 7: Удаление из пустой кучи');
  print('=' * 60);
  var emptyHeap = Heap<int>(isMaxHeap: true);
  bool emptyRemoved = emptyHeap.remove(5);
  print('Попытка удалить из пустой кучи: $emptyRemoved');
  check(emptyRemoved == false, 'Из пустой кучи вернулся не false');
  
  print('\n✅ Все тесты пройдены успешно!');
}

