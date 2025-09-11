extension QuickSort<T> on List<T> {
  void quickSort(bool Function(T, T) compare) {
    // Проверяем, что список не пустой
    if (isEmpty) {
      return;
    }
    // Запускаем рекурсивную сортировку для всего массива
    _quickSort(0, length - 1, compare);
  }

  // Рекурсивный метод быстрой сортировки
  // left - левая граница сортируемого участка
  // right - правая граница сортируемого участка
  // compare - функция сравнения элементов
  void _quickSort(int left, int right, bool Function(T, T) compare) {
    // Если left >= right, то участок пустой или содержит один элемент,
    // т.е. он уже отсортирован
    if (left < right) {
      // ЭТАП 1: РАЗБИЕНИЕ (Partition)
      // Выбираем опорный элемент и разбиваем массив так, чтобы:
      // - слева от опорного были элементы меньше него
      // - справа от опорного были элементы больше него
      int pivot = _partition(left, right, compare);

      // ЭТАП 2: РЕКУРСИВНАЯ СОРТИРОВКА
      // Рекурсивно сортируем левую часть (элементы меньше опорного)
      _quickSort(left, pivot - 1, compare);

      // Рекурсивно сортируем правую часть (элементы больше опорного)
      _quickSort(pivot + 1, right, compare);
    }
  }

  // Вспомогательный метод для обмена местами двух элементов
  // [i] - индекс первого элемента
  // [j] - индекс второго элемента
  void swap(int i, int j) {
    T temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }

  // Метод разбиения массива относительно опорного элемента
  // left - левая граница участка
  // right - правая граница участка (здесь находится опорный элемент)
  // compare - функция сравнения элементов
  // Возвращает финальную позицию опорного элемента
  int _partition(int left, int right, bool Function(T, T) compare) {
    // Выбираем последний элемент как опорный (pivot)
    T pivot = this[right];

    // Указатель на границу области "меньших" элементов
    // Все элементы слева от less меньше опорного
    int less = left;

    // Проходим по всем элементам кроме опорного
    for (int i = left; i < right; i++) {
      // Если текущий элемент меньше опорного, то перемещаем его
      // в область "меньших" элементов и увеличиваем less, иначе
      // элемент остается на месте
      if (compare(this[i], pivot)) {
        swap(i, less);
        less++;
      }
    }

    // Помещаем опорный элемент на его финальную позицию
    // между "меньшими" и "большими" элементами
    swap(less, right);

    // Возвращаем позицию опорного элемента
    return less;
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
  list.quickSort((a, b) => a < b);
  print(list);

  list.quickSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.quickSort((a, b) => a.id > b.id);
  print(workers);

  workers.quickSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
