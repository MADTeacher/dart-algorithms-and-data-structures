// Задача 6: Реализация метода swap
// Меняет местами элементы по двум заданным индексам.
// Выбрасывает RangeError, если индексы некорректны.

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

  // РЕАЛИЗАЦИЯ МЕТОДА swap
  /// Меняет местами элементы по двум заданным индексам.
  /// Выбрасывает RangeError, если индексы некорректны.
  void swap(int index1, int index2) {
    // Проверка корректности индексов
    if (index1 < 0 || index1 >= _size) {
      throw RangeError.index(index1, this, 'Index out of bounds', 'index1');
    }
    if (index2 < 0 || index2 >= _size) {
      throw RangeError.index(index2, this, 'Index out of bounds', 'index2');
    }

    // Если индексы одинаковые, ничего не делаем
    if (index1 == index2) {
      return;
    }

    // Меняем местами элементы
    T? temp = _elements[index1];
    _elements[index1] = _elements[index2];
    _elements[index2] = temp;
  }
}

void main() {
  // Тест 1: Базовый обмен элементов
  var arr = DynamicArray<int>(5);
  arr.add(1);
  arr.add(2);
  arr.add(3);
  arr.add(4);

  print('До swap(0, 3):');
  print('Массив: $arr'); // [1, 2, 3, 4]

  arr.swap(0, 3);

  print('После swap(0, 3):');
  print('Массив: $arr'); // Ожидается [4, 2, 3, 1]
  print('arr[0] = ${arr[0]}, arr[3] = ${arr[3]}');

  // Тест 2: Обмен одинаковых индексов
  var arr2 = DynamicArray<int>(5);
  arr2.add(10);
  arr2.add(20);
  arr2.add(30);

  print('\nТест 2: Обмен одинаковых индексов');
  print('До swap(1, 1):');
  print('Массив: $arr2'); // [10, 20, 30]

  arr2.swap(1, 1);

  print('После swap(1, 1):');
  print('Массив: $arr2'); // Ожидается [10, 20, 30] (не изменился)

  // Тест 3: Проверка исключения - некорректный индекс
  var arr3 = DynamicArray<int>(5);
  arr3.add(1);
  arr3.add(2);
  arr3.add(3);

  print('\nТест 3: Проверка исключения');
  print('Массив: $arr3'); // [1, 2, 3]
  print('Size: ${arr3.length}'); // 3

  try {
    arr3.swap(4, 0); // index1 = 4 выходит за границы
    print('ОШИБКА: Исключение не было выброшено!');
  } on RangeError catch (e) {
    print('Исключение RangeError выброшено корректно: $e');
  }
}
