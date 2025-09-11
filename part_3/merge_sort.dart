extension MergeSort<T> on List<T> {
  void mergeSort(bool Function(T, T) compare) {
    // Проверяем, что список не пустой
    if (isEmpty) {
      throw StateError('List is empty');
    }

    // Создаем буферный массив для временного хранения
    // элементов при слиянии. Размер буфера равен размеру
    // исходного списка
    List<T?> buffer = List.filled(length, null, growable: true);

    // Запускаем рекурсивную сортировку для всего массива
    _mergeSort(buffer, 0, length - 1, compare);
  }

  // Рекурсивный метод сортировки слиянием
  // buffer - вспомогательный массив для слияния
  // left - левая граница сортируемого участка
  // right - правая граница сортируемого участка
  // compare - функция сравнения элементов
  void _mergeSort(
    List<T?> buffer,
    int left,
    int right,
    bool Function(T, T) compare,
  ) {
    // Если left >= right, то участок пустой или содержит один элемент,
    // т.е. он уже отсортирован
    if (left < right) {
      // Находим середину участка для разделения на две части
      int mid = (left + right) ~/ 2;

      // Рекурсивно сортируем левую половину [left...mid]
      _mergeSort(buffer, left, mid, compare);

      // Рекурсивно сортируем правую половину [mid+1...right]
      _mergeSort(buffer, mid + 1, right, compare);

      // Начинаем слияние двух отсортированных половин
      // Инициализируем указатели:
      // k - индекс в буферном массиве
      // i - указатель на левую половину
      var (k, i) = (left, left);
      // j - указатель на правую половину
      var j = mid + 1;

      // Сравниваем элементы из обеих половин и
      // записываем меньший в буфер
      while (i <= mid && j <= right) {
        if (j > right || (i <= mid && compare(this[i], this[j]))) {
          // Элемент из левой половины меньше или
          // правая половина закончилась
          buffer[k++] = this[i++];
        } else {
          // Элемент из правой половины меньше
          buffer[k++] = this[j++];
        }
      }

      // Копирование оставшихся элементов с
      // левой стороны, если они есть
      while (i <= mid) {
        buffer[k++] = this[i++];
      }

      // Копирование оставшихся элементов с
      // правой стороны, если они есть
      while (j <= right) {
        buffer[k++] = this[j++];
      }

      // Копируем результат из буфера обратно в исходный массив
      for (var it = left; it <= right; it++) {
        this[it] = buffer[it]!;
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
  list.mergeSort((a, b) => a < b);
  print(list);

  list.mergeSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.mergeSort((a, b) => a.id > b.id);
  print(workers);

  workers.mergeSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
