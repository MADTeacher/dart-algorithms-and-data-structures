class GraphSet<T> {
  final Map<T, bool> _set = <T, bool>{};

  GraphSet([Iterable<T>? values]) {
    if (values != null) {
      for (final value in values) {
        add(value);
      }
    }
  }

  bool add(T value) {
    final length = _set.length;
    _set[value] = true;
    return length != _set.length;
  }

  bool get isEmpty => _set.isEmpty;

  int size() => _set.length;

  void removeAll() {
    _set.clear();
  }

  bool contains(T value) => _set.containsKey(value);

  void forEach(void Function(T) func) {
    if (size() == 0) return;
    for (final key in _set.keys) {
      func(key);
    }
  }
}
