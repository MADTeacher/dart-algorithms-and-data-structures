extension CocktailSort<T> on List<T> {
  void cocktailSort(bool Function(T, T) compare) {
    // Левая граница - начало неотсортированной части
    var left = 0;
    // Правая граница - конец неотсортированной части
    var right = length - 1;

    // Продолжаем, пока есть неотсортированная область
    while (left <= right) {
      // ПЕРВЫЙ ПРОХОД: справа налево
      // Находим минимальный элемент и перемещаем его к началу
      for (int i = right; i > left; i--) {
        if (compare(this[i], this[i - 1])) {
          // Если элементы стоят в неправильном порядке,
          // то меняем их местами
          T temp = this[i];
          this[i] = this[i - 1];
          this[i - 1] = temp;
        }
      }
      // Увеличиваем левую границу
      left++;

      // ВТОРОЙ ПРОХОД: слева направо
      // Находим максимальный элемент и перемещаем его к концу
      for (int i = left; i < right; i++) {
        if (compare(this[i + 1], this[i])) {
          // Если элементы стоят в неправильном порядке,
          // то меняем их местами
          T temp = this[i];
          this[i] = this[i + 1];
          this[i + 1] = temp;
        }
      }
      // Уменьшаем правую границу
      right--;
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
  list.cocktailSort((a, b) => a < b);
  print(list);

  list.cocktailSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.cocktailSort((a, b) => a.id > b.id);
  print(workers);

  workers.cocktailSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
