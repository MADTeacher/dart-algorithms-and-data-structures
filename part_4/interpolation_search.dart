class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) interpolationSearch<T>(
  List<T> list,
  int Function(T element) compare,
) {
  // Проверяем, что искомое значение может находиться в коллекции
  if (list.isEmpty || compare(list.first) > 0 || compare(list.last) < 0) {
    return (index: -1, value: null);
  }

  // Инициализируем границы
  int low = 0;
  int high = list.length - 1;

  // Выполняем поиск до тех пор, пока есть элементы для проверки
  while (low <= high) {
    int cmpLow = compare(list[low]);
    int cmpHigh = compare(list[high]);

    // Если элемент найден на границах
    if (cmpLow == 0) {
      return (index: low, value: list[low]);
    }
    if (cmpHigh == 0) {
      return (index: high, value: list[high]);
    }

    // Если искомый элемент вне диапазона
    if (cmpLow > 0 || cmpHigh < 0) {
      return (index: -1, value: null);
    }

    // Вычисляем позицию для интерполяции
    // Для универсальности используем пропорциональное деление
    // Поскольку у нас есть только функция сравнения, используем линейную интерполяцию
    int pos;
    if (cmpHigh == cmpLow) {
      pos = low;
    } else {
      // Приблизительная интерполяция на основе позиции
      double ratio = -cmpLow.toDouble() / (cmpHigh - cmpLow).toDouble();
      pos = (low + ratio * (high - low)).round();

      // Убеждаемся, что позиция в допустимых границах
      if (pos < low) pos = low;
      if (pos > high) pos = high;
    }

    int cmpPos = compare(list[pos]);

    // Если элемент найден
    if (cmpPos == 0) {
      return (index: pos, value: list[pos]);
    }
    // Если искомый элемент больше list[pos]
    else if (cmpPos < 0) {
      low = pos + 1;
    }
    // Если искомый элемент меньше list[pos]
    else {
      high = pos - 1;
    }
  }

  // Элемент не найден
  return (index: -1, value: null);
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a, b) => a.compareTo(b));
  print(list);

  var val = interpolationSearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = interpolationSearch(list, (i) => i.compareTo(100));
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
  var worker = interpolationSearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = interpolationSearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
