extension InsertionSort<T> on List<T> {
  void insertionSort(bool Function(T, T) compare) {
    if (isEmpty) {
      throw ArgumentError('Array is empty');
    }

    for (int i = 1; i < length; i++) {
      T temp = this[i];
      int it = i;
      while (it > 0 && compare(this[it - 1], temp)) {
        this[it] = this[it - 1];
        it--;
      }
      this[it] = temp;
    }
  }
}

class Worker {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.insertionSort((a, b) => a < b);
  print(list);

  list.insertionSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.insertionSort((a, b) => a.id > b.id);
  print(workers);

  workers.insertionSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
