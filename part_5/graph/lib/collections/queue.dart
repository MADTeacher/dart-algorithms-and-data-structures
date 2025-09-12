class EmptyQueueException implements Exception {
  final String message;
  EmptyQueueException(this.message);

  @override
  String toString() => 'EmptyQueueException: $message';
}

class _SingleNode<T> {
  T data;
  _SingleNode<T>? nextPtr;

  _SingleNode(this.data, [this.nextPtr]);
}

class Queue<T> {
  int _length = 0;
  _SingleNode<T>? _head;
  _SingleNode<T>? _tail;

  int getSize() => _length;

  bool isEmpty() => _length == 0;

  void enqueue(T value) {
    final node = _SingleNode<T>(value);
    if (_length == 0) {
      _head = node;
      _tail = node;
      _length++;
      return;
    }

    _tail!.nextPtr = node;
    _tail = node;
    _length++;
  }

  T dequeue() {
    if (isEmpty()) {
      throw EmptyQueueException('Queue is empty');
    }
    final node = _head!;
    _head = node.nextPtr;
    _length--;
    return node.data;
  }

  T peak() {
    if (isEmpty()) {
      throw EmptyQueueException('Queue is empty');
    }
    return _head!.data;
  }
}
