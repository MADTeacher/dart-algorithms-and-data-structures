extension GnomeSort<T> on List<T> {
  void gnomeSort(bool Function(T, T) compare) {
    if (isEmpty) {
      throw ArgumentError('Array is empty');
    }

    void swap(int i, int j) {
      T temp = this[i];
      this[i] = this[j];
      this[j] = temp;
    }

    int i = 1;
    while (i < length) {
      if (compare(this[i], this[i - 1])) {
        i++;
      } else {
        swap(i, i - 1);
        if (i > 1) {
          i--;
        }
      }
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
  list.gnomeSort((a, b) => a < b);
  print(list);

  list.gnomeSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.gnomeSort((a, b) => a.id > b.id);
  print(workers);

  workers.gnomeSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
