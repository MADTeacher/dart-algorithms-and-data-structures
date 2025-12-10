// Задача 8: Реализация метода subArray
// Возвращает новый экземпляр DynamicArray<T>, содержащий элементы текущего массива,
// начиная с startIndex (включительно) и заканчивая endIndex (исключительно).
// Новый массив имеет емкость, равную его размеру (оптимальное использование памяти).

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

  // РЕАЛИЗАЦИЯ МЕТОДА subArray
  /// Возвращает новый экземпляр DynamicArray<T>, содержащий элементы текущего массива,
  /// начиная с startIndex (включительно) и заканчивая endIndex (исключительно).
  /// Новый массив имеет емкость, равную его размеру (оптимальное использование памяти).
  DynamicArray<T> subArray(int startIndex, int endIndex) {
    // Проверка корректности индексов
    if (startIndex < 0) {
      throw RangeError.index(startIndex, this, 'startIndex out of bounds');
    }
    if (endIndex > _size) {
      throw RangeError.index(endIndex, this, 'endIndex out of bounds');
    }
    if (startIndex > endIndex) {
      throw RangeError.range(
          endIndex, startIndex, _size, 'startIndex > endIndex');
    }

    // Вычисляем размер подмассива
    int subSize = endIndex - startIndex;

    // Создаем новый массив с оптимальной емкостью (равной размеру)
    DynamicArray<T> result = DynamicArray<T>(subSize);

    // Копируем элементы из исходного массива
    for (int i = startIndex; i < endIndex; i++) {
      result.add(_elements[i]!);
    }

    return result;
  }
}

void main() {
  // Тест 1: Базовый тест - получение подмассива
  var arr = DynamicArray<int>(10);
  arr.add(10);
  arr.add(20);
  arr.add(30);
  arr.add(40);
  arr.add(50);

  print('Исходный массив A: $arr');
  print('Size: ${arr.length}, Capacity: ${arr.capacity}');

  var subArr = arr.subArray(1, 4);

  print('\nПодмассив B = A.subArray(1, 4):');
  print('Массив B: $subArr'); // Ожидается [20, 30, 40]
  print('Size: ${subArr.length}'); // 3
  print('Capacity: ${subArr.capacity}'); // 3 (оптимальная емкость)

  // Проверка, что исходный массив не изменился
  print('\nИсходный массив A после операции:');
  print('Массив A: $arr'); // [10, 20, 30, 40, 50]
  print('Size: ${arr.length}'); // 5

  // Тест 2: Проверка исключений
  var arr2 = DynamicArray<int>(5);
  arr2.add(1);
  arr2.add(2);
  arr2.add(3);

  print('\nТест 2: Проверка исключений');
  print('Исходный массив: $arr2');
  print('Size: ${arr2.length}'); // 3

  try {
    arr2.subArray(3, 1); // startIndex > endIndex
    print('ОШИБКА: Исключение не было выброшено!');
  } on RangeError catch (e) {
    print('Исключение RangeError выброшено корректно: $e');
  }

  try {
    arr2.subArray(-1, 2); // startIndex < 0
    print('ОШИБКА: Исключение не было выброшено!');
  } on RangeError catch (e) {
    print('Исключение RangeError выброшено корректно: $e');
  }

  try {
    arr2.subArray(0, 5); // endIndex > size
    print('ОШИБКА: Исключение не было выброшено!');
  } on RangeError catch (e) {
    print('Исключение RangeError выброшено корректно: $e');
  }
}
