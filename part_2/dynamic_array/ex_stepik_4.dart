// Задача 4: Реализация метода contains
// Возвращает true, если заданное значение присутствует в массиве,
// и false в противном случае.

class DynamicArray<T extends Comparable<dynamic>> {
  List<T?> _elements;
  int _size = 0;

  DynamicArray(int initialCapacity)
    : _elements = List<T?>.filled(initialCapacity, null);

  DynamicArray.from(Iterable<T> list)
    : _elements = List<T?>.from(list),
      _size = list.length;

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

  // РЕАЛИЗАЦИЯ МЕТОДА contains
  /// Возвращает true, если заданное значение присутствует в массиве,
  /// и false в противном случае.
  bool contains(T value) {
    for (int i = 0; i < _size; i++) {
      if (_elements[i]!.compareTo(value) == 0) {
        return true;
      }
    }

    return false;
  }
}

class Worker implements Comparable<Worker> {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';

  @override
  int compareTo(Worker other) {
    return id.compareTo(other.id);
  }
}

void main() {
  // Тест 1: Проверка с объектами Worker
  var workers = DynamicArray<Worker>(5);
  workers.add(Worker('A', 1));
  workers.add(Worker('B', 2));

  print('Массив работников: $workers');
  print(
    'contains(Worker(\'A\', 1)): ${workers.contains(Worker('A', 1))}',
  ); // Ожидается true
  print(
    'contains(Worker(\'B\', 2)): ${workers.contains(Worker('B', 2))}',
  ); // Ожидается true
  print(
    'contains(Worker(\'C\', 3)): ${workers.contains(Worker('C', 3))}',
  ); // Ожидается false

  // Примечание: compareTo сравнивает только id, поэтому
  // Worker('A', 1) и Worker('DifferentName', 1) будут считаться равными
  print(
    'contains(Worker(\'DifferentName\', 1)): ${workers.contains(Worker('DifferentName', 1))}',
  ); // Ожидается true (id совпадает)
}
