extension CombSort<T> on List<T> {
  void combSort(bool Function(T, T) compare) {
    if (isEmpty) {
      throw ArgumentError('Array is empty');
    }

    const double factor = 1.247;
    double step = (length - 1).toDouble();

    void swap(int i, int j) {
      T temp = this[i];
      this[i] = this[j];
      this[j] = temp;
    }

    while (step >= 1) {
      for (int i = 0; i + step.toInt() < length; i++) {
        if (compare(this[i], this[i + step.toInt()])) {
          swap(i, i + step.toInt());
        }
      }
      step /= factor;
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
  list.combSort((a, b) => a < b);
  print(list);

  list.combSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.combSort((a, b) => a.id > b.id);
  print(workers);

  workers.combSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
