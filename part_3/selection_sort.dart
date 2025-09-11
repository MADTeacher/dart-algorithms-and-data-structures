extension SelectionSort<T> on List<T> {
  void selectionSort(bool Function(T, T) compare) {
    if (isEmpty) {
      throw ArgumentError('Array is empty');
    }

    void swap(int i, int j) {
      T temp = this[i];
      this[i] = this[j];
      this[j] = temp;
    }

    for (int i = 0; i < length; i++) {
      int min = i;
      for (int j = i; j < length; j++) {
        if (compare(this[j], this[min])) {
          min = j;
        }
      }
      swap(i, min);
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
  list.selectionSort((a, b) => a < b);
  print(list);

  list.selectionSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.selectionSort((a, b) => a.id > b.id);
  print(workers);

  workers.selectionSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
