// Задача 7: Реализация метода removeWhere
// Удаляет все элементы из массива, для которых функция test возвращает true.
// Оптимизированная реализация: сдвиг происходит только один раз.

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

  // РЕАЛИЗАЦИЯ МЕТОДА removeWhere
  /// Удаляет все элементы из массива, для которых функция test возвращает true.
  /// Оптимизированная реализация: сдвиг происходит только один раз.
  void removeWhere(bool Function(T element) test) {
    // Используем два указателя для эффективного удаления
    int writeIndex = 0;

    // Проходим по всем элементам
    for (int readIndex = 0; readIndex < _size; readIndex++) {
      T element = _elements[readIndex]!;

      // Если элемент не должен быть удален, сохраняем его
      if (!test(element)) {
        _elements[writeIndex] = element;
        writeIndex++;
      }
    }

    // Очищаем оставшиеся элементы
    for (int i = writeIndex; i < _size; i++) {
      _elements[i] = null;
    }

    // Обновляем размер
    _size = writeIndex;
  }
}


void main() {
  // Тест 1: Удаление четных чисел
  var arr = DynamicArray<int>(10);
  arr.add(1);
  arr.add(2);
  arr.add(3);
  arr.add(4);
  arr.add(5);
  arr.add(6);

  print('До removeWhere:');
  print('Массив: $arr'); // [1, 2, 3, 4, 5, 6]
  print('Size: ${arr.length}'); // 6

  arr.removeWhere((e) => e.isEven);

  print('\nПосле removeWhere((e) => e.isEven):');
  print('Массив: $arr'); // Ожидается [1, 3, 5]
  print('Size: ${arr.length}'); // 3

  // Тест 2: Удаление всех элементов, больших определенного значения
  var arr2 = DynamicArray<int>(10);
  arr2.add(10);
  arr2.add(20);
  arr2.add(30);
  arr2.add(40);
  arr2.add(50);

  print('\nТест 2: Удаление элементов > 25');
  print('До removeWhere:');
  print('Массив: $arr2'); // [10, 20, 30, 40, 50]

  arr2.removeWhere((e) => e > 25);

  print('После removeWhere((e) => e > 25):');
  print('Массив: $arr2'); // Ожидается [10, 20]
  print('Size: ${arr2.length}'); // 2
}
