// Задача 1: Реализация метода indexOf
// Находит и возвращает первый индекс в массиве, где находится заданное значение.
// Если значение не найдено, возвращает -1.

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

  // РЕАЛИЗАЦИЯ МЕТОДА indexOf
  /// Находит и возвращает первый индекс в массиве, где находится заданное значение.
  /// Если значение не найдено, возвращает -1.
  int indexOf(T value) {
    for (int i = 0; i < _size; i++) {
      if (_elements[i]!.compareTo(value) == 0) {
        return i;
      }
    }
    return -1;
  }
}

void main() {
  // Тест 1: Базовый поиск
  var arr = DynamicArray<int>(4);
  arr.add(10);
  arr.add(20);
  arr.add(10);
  arr.add(30);

  print('Массив: $arr');
  print('indexOf(10): ${arr.indexOf(10)}'); // Ожидается 0
  print('indexOf(30): ${arr.indexOf(30)}'); // Ожидается 3
  print('indexOf(40): ${arr.indexOf(40)}'); // Ожидается -1

  // Тест 2: Поиск в пустом массиве
  var emptyArr = DynamicArray<int>(5);
  print('Пустой массив: $emptyArr');
  print('indexOf(10): ${emptyArr.indexOf(10)}'); // Ожидается -1
}
