// Интерфейс для объектов, которые могут быть
// использованы в качестве элементов кучи
abstract class IKey {
  int key();
  String name();
}

// Исключение, выбрасываемое при переполнении кучи
class HeapOverFlowException implements Exception {
  final String message;
  HeapOverFlowException(this.message);

  @override
  String toString() => 'HeapOverFlowException: $message';
}

// Исключение, выбрасываемое при попытке удаления из пустой кучи
class EmptyHeapException implements Exception {
  final String message;
  EmptyHeapException(this.message);

  @override
  String toString() => 'EmptyHeapException: $message';
}

// Исключение, выбрасываемое, когда индекс выходит за пределы диапазона
class IndexOutRangeException implements Exception {
  final String message;
  IndexOutRangeException(this.message);

  @override
  String toString() => 'IndexOutRangeException: $message';
}

// Исключение, выбрасываемое, если узел не найден
class NodeNotFoundException implements Exception {
  final String message;
  NodeNotFoundException(this.message);

  @override
  String toString() => 'NodeNotFoundException: $message';
}

class Heap<T extends IKey> {
  int _length = 0;
  int _capacity;
  final bool _isFixed;
  final bool Function(T, T) _comp;
  List<T?> _arr;

  Heap(int size, [bool fixed = false, bool Function(T, T)? comp])
      : _capacity = size,
        _isFixed = fixed,
        _comp = comp ?? ((a, b) => a.key() > b.key()),
        _arr = List<T?>.filled(size, null);

  // Создаем кучу из списка
  factory Heap.from(
    Iterable<T> data, [
    bool fixed = true,
    bool Function(T, T)? comp,
  ]) {
    final heap = Heap<T>(data.length, fixed, comp);
    for (final item in data) {
      heap.insert(item);
    }
    return heap;
  }

  bool _checkRange(int index) {
    return index >= 0 && index < _length;
  }

  void _resize(int newCapacity) {
    final newArray = List<T?>.filled(newCapacity, null);
    for (int i = 0; i < _length; i++) {
      newArray[i] = _arr[i];
    }
    _arr = newArray;
    _capacity = newCapacity;
  }

  bool isEmpty() => _length == 0;

  int getSize() => _length;

  void trickleUp(int index) {
    int parent = (index - 1) ~/ 2;
    final T bottom = _arr[index]!;

    while (index > 0 && _comp(_arr[parent]!, bottom)) {
      _arr[index] = _arr[parent];
      index = parent;
      parent = (parent - 1) ~/ 2;
    }

    _arr[index] = bottom;
  }

  void trickleDown(int index) {
    int largeChild = 0;
    final T top = _arr[index]!;

    while (index < _length ~/ 2) {
      final int leftChild = 2 * index + 1;
      final int rightChild = leftChild + 1;

      if (rightChild < _length && _comp(_arr[leftChild]!, _arr[rightChild]!)) {
        largeChild = rightChild;
      } else {
        largeChild = leftChild;
      }

      if (!_comp(top, _arr[largeChild]!)) {
        break;
      }

      _arr[index] = _arr[largeChild];
      index = largeChild;
    }

    _arr[index] = top;
  }

  void change(T node) {
    int index = -1;
    for (int i = 0; i < _length; i++) {
      if (node.name() == _arr[i]!.name()) {
        index = i;
        break;
      }
    }

    if (index < 0) {
      throw NodeNotFoundException('Node not found');
    }

    if (!_checkRange(index)) {
      throw IndexOutRangeException('Index out of range');
    }

    final T oldValue = _arr[index]!;
    _arr[index] = node;

    if (oldValue.key() >= node.key()) {
      trickleUp(index);
    } else {
      trickleDown(index);
    }
  }

  void insert(T value) {
    if (_length >= _capacity) {
      if (_isFixed) {
        throw HeapOverFlowException('Heap overflow: $value');
      } else {
        _resize(_capacity * 2);
      }
    }

    _arr[_length] = value;
    trickleUp(_length);
    _length++;
  }

  T remove() {
    if (isEmpty()) {
      throw EmptyHeapException('Heap is empty');
    }

    final T root = _arr[0]!;
    _length--;
    _arr[0] = _arr[_length];
    trickleDown(0);
    return root;
  }
}
