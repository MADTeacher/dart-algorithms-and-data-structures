// Задача 2: Реализация метода trimToSize
// Уменьшает внутреннюю емкость массива так, чтобы она точно соответствовала
// текущему размеру. Если размер уже равен емкости, метод не выполняет действий.

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

  // РЕАЛИЗАЦИЯ МЕТОДА trimToSize
  /// Уменьшает внутреннюю емкость массива так, чтобы она точно соответствовала
  /// текущему размеру. Если размер уже равен емкости, метод не выполняет действий.
  void trimToSize() {
    if (_size == _elements.length) {
      return; // Емкость уже оптимальна
    }

    if (_size == 0) {
      // Если массив пуст, создаем минимальную емкость
      _elements = List<T?>.filled(1, null);
      return;
    }

    // Создаем новый массив с емкостью, равной размеру
    List<T?> newElements = List<T?>.filled(_size, null);
    for (int i = 0; i < _size; i++) {
      newElements[i] = _elements[i];
    }
    _elements = newElements;
  }
}

void main() {
  // Тест 1: Базовый тест - уменьшение емкости
  var arr = DynamicArray<int>(12);
  arr.add(1);
  arr.add(2);
  arr.add(3);
  arr.add(4);
  arr.add(5);

  print('До trimToSize():');
  print('Size: ${arr.length}'); // 5
  print('Capacity: ${arr.capacity}'); // 12
  print('Массив: $arr');

  arr.trimToSize();

  print('После trimToSize():');
  print('Size: ${arr.length}'); // 5
  print('Capacity: ${arr.capacity}'); // 5
  print('Массив: $arr');

  // Проверка, что все элементы сохранены
  print('Проверка элементов:');
  for (int i = 0; i < arr.length; i++) {
    print('arr[$i] = ${arr[i]}');
  }

  // Тест 2: Емкость уже оптимальна
  var arr2 = DynamicArray<int>(5);
  arr2.add(10);
  arr2.add(20);
  arr2.add(30);
  arr2.add(40);
  arr2.add(50);

  print('Тест 2: Емкость уже оптимальна');
  print('До trimToSize():');
  print('Size: ${arr2.length}'); // 5
  print('Capacity: ${arr2.capacity}'); // 5

  arr2.trimToSize();

  print('После trimToSize():');
  print('Size: ${arr2.length}'); // 5
  print('Capacity: ${arr2.capacity}'); // 5 (не изменилась)
}
