// Задача 5: Реализация метода addAll
// Добавляет все элементы из переданной итерируемой коллекции в конец массива.
// Оптимизирует реаллокацию: выполняет одну реаллокацию, если необходимо.

class DynamicArray<T extends Comparable<dynamic>>{
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

  // РЕАЛИЗАЦИЯ МЕТОДА addAll
  /// Добавляет все элементы из переданной итерируемой коллекции в конец массива.
  /// Оптимизирует реаллокацию: выполняет одну реаллокацию, если необходимо.
  void addAll(Iterable<T> values) {
    final valuesLength = values.length;
    if (valuesLength == 0) {
      return; // Нет элементов для добавления
    }

    final requiredCapacity = _size + valuesLength;

    // Если требуется больше емкости, выполняем реаллокацию
    if (requiredCapacity > _elements.length) {
      // Вычисляем новую емкость: либо удваиваем, либо используем требуемую
      int newCapacity = _elements.length * 2;
      if (newCapacity < requiredCapacity) {
        newCapacity = requiredCapacity;
      }

      // Создаем новый массив с увеличенной емкостью
      List<T?> newElements = List<T?>.filled(newCapacity, null);
      for (int i = 0; i < _size; i++) {
        newElements[i] = _elements[i];
      }
      _elements = newElements;
    }

    // Копируем все элементы из values
    int index = _size;
    for (T value in values) {
      _elements[index++] = value;
    }
    _size = requiredCapacity;
  }
}

void main() {
  // Тест 1: Базовый тест - добавление списка
  var arr = DynamicArray<int>(4);
  arr.add(1);
  arr.add(2);

  print('До addAll:');
  print('Массив: $arr'); // [1, 2]
  print('Size: ${arr.length}'); // 2
  print('Capacity: ${arr.capacity}'); // 4

  var toAdd = [3, 4, 5, 6];
  print('Добавляем: $toAdd');
  arr.addAll(toAdd);

  print('После addAll:');
  print('Массив: $arr'); // Ожидается [1, 2, 3, 4, 5, 6]
  print('Size: ${arr.length}'); // 6
  print('Capacity: ${arr.capacity}'); // 8 (4 * 2 = 8, что больше требуемых 6)

  // Тест 2: Добавление, когда удвоение дает большую емкость
  var arr2 = DynamicArray<int>(10);
  arr2.add(1);
  arr2.add(2);

  print('\nТест 2: Удвоение дает большую емкость');
  print('До addAll:');
  print('Size: ${arr2.length}'); // 2
  print('Capacity: ${arr2.capacity}'); // 10

  var toAdd2 = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  print('Добавляем: $toAdd2 (10 элементов)');
  arr2.addAll(toAdd2);

  print('После addAll:');
  print('Size: ${arr2.length}'); // 12
  print('Capacity: ${arr2.capacity}'); // 20 (10 * 2 = 20, что больше требуемых 12)
}
