// Задача 5: Тернарная куча (d-ary Heap, d=3)
// Модификация внутренней логики для поддержки тернарной кучи

class Heap<T extends Comparable<dynamic>> {
  List<T> _heap;
  final bool _isMaxHeap;
  static const int _arity = 3; // Тернарная куча (3 ребенка)

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

  void _heapifyUp(int i) {
    while (i != 0 && _compare(_heap[_parent(i)], _heap[i])) {
      _swap(_parent(i), i);
      i = _parent(i);
    }
  }

  void _heapifyDown(int i) {
    int largestOrSmallest = i;
    
    // Проверяем всех детей (для тернарной кучи их может быть до 3)
    for (int childIndex = _firstChild(i);
        childIndex <= _lastChild(i) && childIndex < size;
        childIndex++) {
      if (_compare(_heap[largestOrSmallest], _heap[childIndex])) {
        largestOrSmallest = childIndex;
      }
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

  /// Возвращает индекс первого ребенка узла i
  int _firstChild(int i) => _arity * i + 1;

  /// Возвращает индекс последнего возможного ребенка узла i
  int _lastChild(int i) => _arity * i + _arity;

  /// Возвращает индекс родителя узла i
  int _parent(int i) => (i - 1) ~/ _arity;

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
    List<String> result = ['Heap (Ternary)\n'];
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
    // Собираем всех детей узла
    List<int> children = [];
    for (int i = _firstChild(index); i <= _lastChild(index) && i < heapSize; i++) {
      children.add(i);
    }

    // Выводим текущий узел
    result.add('$prefix${isTail ? '└── ' : '┌── '} ${_heap[index]}\n');

    // Выводим детей справа налево (для правильного отображения дерева)
    for (int i = children.length - 1; i >= 0; i--) {
      bool isLastChild = (i == 0);
      String childPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStrHeap(result, childPrefix, children[i], isLastChild, heapSize);
    }
  }

  /// Возвращает карту структуры кучи для анализа
  Map<int, List<int>> toMap() {
    Map<int, List<int>> structure = {};
    for (int i = 0; i < _heap.length; i++) {
      List<int> children = [];
      for (int j = _firstChild(i); j <= _lastChild(i) && j < _heap.length; j++) {
        children.add(j);
      }
      if (children.isNotEmpty) {
        structure[i] = children;
      }
    }
    return structure;
  }
}

// Вспомогательная функция для проверок (работает в release mode)
void check(bool condition, String message) {
  if (!condition) {
    throw AssertionError('ОШИБКА ТЕСТА: $message');
  }
}

void main() {
  print('ТЕСТ 1: Тернарная куча с 12 элементами');
  var heap = Heap<int>(isMaxHeap: true);
  
  for (int i = 1; i <= 12; i++) {
    heap.insert(i);
  }
  
  print('Размер кучи: ${heap.size}');
  print('Куча:');
  print(heap);
  
  // Проверка структуры через toMap
  print('\nСтруктура кучи:');
  var structure = heap.toMap();
  structure.forEach((parent, children) {
    print('$parent -> $children');
    check(children.length <= 3, 'У узла более 3 детей');
  });
  
  // Проверяем, что у корня 3 ребенка
  var rootChildren = structure[0];
  if (rootChildren != null) {
    print('\nУ корня детей: ${rootChildren.length}');
    check(rootChildren.length == 3, 'У корня не 3 ребенка');
  }
  
  // Проверка высоты
  print('\nТЕСТ 2: Проверка корректности extract');
  print('Извлекаем элементы по порядку:');
  List<int> extracted = [];
  while (!heap.isEmpty) {
    int value = heap.extract();
    extracted.add(value);
    print('Extract: $value');
  }
  print('\nИзвлеченные значения: $extracted');
  
  // Проверка, что порядок корректен
  bool isCorrect = true;
  for (int i = 0; i < extracted.length - 1; i++) {
    if (extracted[i] < extracted[i + 1]) {
      isCorrect = false;
      break;
    }
  }
  print('Порядок корректен: $isCorrect');
  check(isCorrect, 'Порядок не убывающий');
  check(extracted.first == 12, 'Первый элемент не максимальный');
  check(extracted.last == 1, 'Последний элемент не минимальный');
  
  print('\nТЕСТ 3: Тернарная Min Heap');
  var minHeap = Heap<int>(isMaxHeap: false);
  for (int i = 12; i >= 1; i--) {
    minHeap.insert(i);
  }
  print('Min Heap:');
  print(minHeap);
  int minRoot = minHeap.peek();
  print('peek(): $minRoot');
  check(minRoot == 1, 'Корень не равен 1');
  
  print('\nСтруктура MinHeap:');
  var minStructure = minHeap.toMap();
  minStructure.forEach((parent, children) {
    print('$parent -> $children');
    check(children.length <= 3, 'У узла более 3 детей');
  });
  
  print('\nТЕСТ 4: Проверка корректности extract');
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
  print('Порядок корректен: $isMinOrderCorrect');
  check(isMinOrderCorrect, 'Порядок не возрастающий');
  check(minExtracted.first == 1, 'Первый элемент не минимальный');
  check(minExtracted.last == 12, 'Последний элемент не максимальный');
  
  print('\nТЕСТ 5: Проверка структуры для разных размеров');
  
  // \nТест с 1 элементом
  var heap1 = Heap<int>(isMaxHeap: true);
  heap1.insert(1);
  print('1 элемент:');
  var struct1 = heap1.toMap();
  print('Структура: $struct1');
  check(struct1.isEmpty, 'У одного элемента есть дети');
  
  // \nТест с 4 элементами
  var heap4 = Heap<int>(isMaxHeap: true);
  for (int i = 1; i <= 4; i++) {
    heap4.insert(i);
  }
  print('\n4 элемента:');
  var struct4 = heap4.toMap();
  print('Структура:');
  struct4.forEach((parent, children) {
    print('  $parent -> $children');
  });
  check(struct4[0] != null && struct4[0]!.length == 3, 'У корня не 3 ребенка');
  
  // \nТест с 13 элементами
  var heap13 = Heap<int>(isMaxHeap: true);
  for (int i = 1; i <= 13; i++) {
    heap13.insert(i);
  }
  print('\n13 элементов:');
  var struct13 = heap13.toMap();
  print('Структура:');
  struct13.forEach((parent, children) {
    print('  $parent -> $children');
    if (parent == 0) {
      check(children.length == 3, 'У корня не 3 ребенка');
    }
  });
  
  print('\nТЕСТ 6: Проверка математики индексов');
  var testHeap = Heap<int>(isMaxHeap: true);
  for (int i = 1; i <= 10; i++) {
    testHeap.insert(i);
  }
  
  // Проверяем формулы для тернарной кучи
  print('Проверка формул для тернарной кучи:');
  for (int i = 0; i < testHeap.size; i++) {
    int firstChild = testHeap._firstChild(i);
    int lastChild = testHeap._lastChild(i);
    int parent = testHeap._parent(i);
    
    if (i > 0) {
      int calculatedParent = (i - 1) ~/ 3;
      check(parent == calculatedParent, 'Формула родителя неверна для индекса $i');
    }
    
    if (firstChild < testHeap.size) {
      int calculatedFirst = 3 * i + 1;
      check(firstChild == calculatedFirst, 'Формула первого ребенка неверна');
    }
    
    if (lastChild < testHeap.size) {
      int calculatedLast = 3 * i + 3;
      check(lastChild == calculatedLast, 'Формула последнего ребенка неверна');
    }
  }
  print('Все формулы корректны ✅');
  
  print('\nТЕСТ 7: Сравнение с бинарной кучей');
  print('Для 12 элементов:');
  print('  Бинарная куча: высота ≈ 4 уровня');
  print('  Тернарная куча: высота ≈ 3 уровня');
  
  var heightHeap = Heap<int>(isMaxHeap: true);
  for (int i = 1; i <= 12; i++) {
    heightHeap.insert(i);
  }
  
  // Подсчитываем максимальную глубину
  int maxDepth = 0;
  void calculateDepth(int index, int depth) {
    if (depth > maxDepth) maxDepth = depth;
    for (int child = heightHeap._firstChild(index);
        child <= heightHeap._lastChild(index) && child < heightHeap.size;
        child++) {
      calculateDepth(child, depth + 1);
    }
  }
  calculateDepth(0, 0);
  print('  Фактическая высота тернарной кучи: ${maxDepth + 1} уровней');
  check(maxDepth + 1 <= 3, 'Высота более 3 уровней');
  
  print('\nТЕСТ 8: Множественные операции insert/extract');
  var complexHeap = Heap<int>(isMaxHeap: true);
  
  // Вставляем элементы
  for (int i = 1; i <= 20; i++) {
    complexHeap.insert(i);
  }
  print('Вставлено 20 элементов, размер: ${complexHeap.size}');
  print('Корень: ${complexHeap.peek()}');
  check(complexHeap.peek() == 20, 'Корень не максимальный');
  
  // Извлекаем несколько элементов
  List<int> complexExtracted = [];
  for (int i = 0; i < 5; i++) {
    complexExtracted.add(complexHeap.extract());
  }
  print('Извлечено 5 элементов: $complexExtracted');
  print('Новый корень: ${complexHeap.peek()}');
  check(complexHeap.peek() == 15, 'Новый корень не равен 15');
  
  // Проверяем структуру после извлечений
  var complexStruct = complexHeap.toMap();
  print('\nСтруктура после извлечений:');
  complexStruct.forEach((parent, children) {
    print('  $parent -> $children');
    check(children.length <= 3, 'У узла более 3 детей');
  });
}

