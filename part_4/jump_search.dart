class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) jumpSearch<T>(
  List<T> list,
  int Function(T element) compare,
) {
  // Проверяем, что искомое значение может находиться в коллекции
  if (list.isEmpty || compare(list.first) > 0 || compare(list.last) < 0) {
    return (index: -1, value: null);
  }

  int n = list.length;

  // Вычисляем оптимальный размер прыжка
  int step = (n / 2).ceil();
  int prev = 0;

  // Прыгаем по блокам, пока не найдем блок, где может находиться элемент
  while (prev < n && compare(list[(prev + step - 1).clamp(0, n - 1)]) < 0) {
    prev += step;
  }

  // Если мы вышли за границы массива
  if (prev >= n) {
    return (index: -1, value: null);
  }

  // Выполняем линейный поиск в найденном блоке
  int end = (prev + step).clamp(0, n);
  for (int i = prev; i < end; i++) {
    int cmp = compare(list[i]);
    if (cmp == 0) {
      return (index: i, value: list[i]);
    }
    // Если элемент больше искомого,
    // значит искомого элемента нет
    if (cmp > 0) {
      break;
    }
  }

  // Элемент не найден
  return (index: -1, value: null);
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a, b) => a.compareTo(b));
  print(list);

  var val = jumpSearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = jumpSearch(list, (i) => i.compareTo(100));
  print('Index: ${val.index}, Value: ${val.value}');
  print('*' * 20);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];

  // Поиск по id
  workers.sort((a, b) => a.id.compareTo(b.id));
  var worker = jumpSearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = jumpSearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');

  // Поиск по имени
  workers.sort((a, b) => a.name.compareTo(b.name));
  worker = jumpSearch(workers, (w) => w.name.compareTo('Alice'));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = jumpSearch(workers, (w) => w.name.compareTo('John'));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
