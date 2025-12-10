// Задача 3: Реализация метода pushFront
// Вставляет новый элемент в начало массива (по индексу 0).
// Требует сдвига всех существующих элементов вправо.

class DynamicArray<T extends Comparable<dynamic>> {
  List<T?> _elements;
  int _size = 0;

  DynamicArray(int initialCapacity)
      : _elements = List<T?>.filled(initialCapacity, null);

  DynamicArray.from(Iterable<T> list)
      : _elements = List<T?>.from(list), _size = list.length;

  bool get isEmpty => _size == 0;

  int get length => _size;

  int get capacity => _elements.length;

  void add(T value) {
    if (_size == _elements.length) {
      _resize();
    }
    _elements[_size++] = value;
  }

  T pop() {
    if (_size == 0) {
      throw UnsupportedError('List is empty');
    }
    _size--;
    var value = _elements[_size];
    _elements[_size] = null;
    return value!;
  }

  void insert(int index, T value) {
    if (index < 0 || index > _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    if (_size == _elements.length) {
      _resize();
    }
    for (int i = _size; i > index; i--) {
      _elements[i] = _elements[i - 1];
    }
    _elements[index] = value;
    _size++;
  }

  T elementAt(int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    return _elements[index]!;
  }

  void set(int index, T value) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    _elements[index] = value;
  }

  void operator []=(int index, T value) {
    set(index, value);
  }

  T operator [](int index) {
    return elementAt(index);
  }

  void removeAt(int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    for (int i = index; i < _size - 1; i++) {
      _elements[i] = _elements[i + 1];
    }
    _elements[_size - 1] = null;
    _size--;
  }

  void remove(T value) {
    for (int i = 0; i < _size; i++) {
      if (_elements[i]!.compareTo(value) == 0) {
        removeAt(i);
        break;
      }
    }
  }

  void _resize() {
    int newCapacity = _elements.length * 2;
    List<T?> newElements = List<T?>.filled(newCapacity, null);
    for (int i = 0; i < _size; i++) {
      newElements[i] = _elements[i];
    }
    _elements = newElements;
  }

  void clear() {
    _elements = List<T?>.filled(_elements.length, null);
    _size = 0;
  }

  @override
  String toString() {
    if (_size == 0) {
      return '[]';
    }
    StringBuffer sb = StringBuffer();
    sb.write('[');
    for (int i = 0; i < _size; i++) {
      if (i != 0) {
        sb.write(', ${_elements[i]}');
      } else {
        sb.write('${_elements[i]}');
      }
    }
    sb.write(']');
    return sb.toString();
  }

  // РЕАЛИЗАЦИЯ МЕТОДА pushFront
  /// Вставляет новый элемент в начало массива (по индексу 0).
  /// Требует сдвига всех существующих элементов вправо.
  /// Выполняет реаллокацию, если необходимо.
  void pushFront(T value) {
    // Проверяем, нужна ли реаллокация
    if (_size == _elements.length) {
      _resize();
    }

    // Сдвигаем все элементы вправо
    for (int i = _size; i > 0; i--) {
      _elements[i] = _elements[i - 1];
    }

    // Вставляем новый элемент в начало
    _elements[0] = value;
    _size++;
  }
}

void main() {
  // Тест 1: Базовый тест - вставка в начало
  var arr = DynamicArray<int>(4);
  arr.add(5);
  arr.add(10);

  print('До pushFront(1):');
  print('Массив: $arr'); // [5, 10]
  print('Size: ${arr.length}');
  print('Capacity: ${arr.capacity}');

  arr.pushFront(1);

  print('\nПосле pushFront(1):');
  print('Массив: $arr'); // Ожидается [1, 5, 10]
  print('Size: ${arr.length}'); // 3
  print('Capacity: ${arr.capacity}');

  // Тест 2: Вставка в начало с переполнением
  var arr2 = DynamicArray<int>(3);
  arr2.add(2);
  arr2.add(3);
  arr2.add(4);

  print('\nТест 2: Вставка с переполнением');
  print('До pushFront(1):');
  print('Массив: $arr2'); // [2, 3, 4]
  print('Size: ${arr2.length}'); // 3
  print('Capacity: ${arr2.capacity}'); // 3

  arr2.pushFront(1);

  print('После pushFront(1):');
  print('Массив: $arr2'); // Ожидается [1, 2, 3, 4]
  print('Size: ${arr2.length}'); // 4
  print('Capacity: ${arr2.capacity}'); // 6 (удвоилась)
}
