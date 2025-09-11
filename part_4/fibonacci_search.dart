class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) fibonacciSearch<T>(
  List<T> list,
  int Function(T element) compare,
) {
  // Проверяем, что искомое значение может находиться в коллекции
  if (compare(list.last) < 0 || compare(list.first) > 0 || list.isEmpty) {
    return (index: -1, value: null);
  }

  int n = list.length;

  // Инициализируем числа Фибоначчи
  int fibM2 = 0; // (m-2)-е число Фибоначчи
  int fibM1 = 1; // (m-1)-е число Фибоначчи
  int fibM = fibM2 + fibM1; // m-е число Фибоначчи

  // fibM будет наименьшим числом Фибоначчи >= n
  while (fibM < n) {
    fibM2 = fibM1;
    fibM1 = fibM;
    fibM = fibM2 + fibM1;
  }

  // Смещение для исключенного диапазона спереди
  int offset = -1;

  // Пока есть элементы для проверки
  while (fibM > 1) {
    // Проверяем, является ли fibM2 действительным местоположением
    int i = (offset + fibM2 < n - 1) ? offset + fibM2 : n - 1;

    int cmp = compare(list[i]);

    // Если элемент найден
    if (cmp == 0) {
      return (index: i, value: list[i]);
    }
    // Если искомый элемент больше list[i], сокращаем массив после i+1
    else if (cmp < 0) {
      fibM = fibM1;
      fibM1 = fibM2;
      fibM2 = fibM - fibM1;
      offset = i;
    }
    // Если искомый элемент меньше list[i], сокращаем массив до i
    else {
      fibM = fibM2;
      fibM1 = fibM1 - fibM2;
      fibM2 = fibM - fibM1;
    }
  }

  // Сравниваем последний элемент с искомым
  if (fibM1 == 1 && offset + 1 < n && compare(list[offset + 1]) == 0) {
    return (index: offset + 1, value: list[offset + 1]);
  }

  // Элемент не найден
  return (index: -1, value: null);
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a, b) => a.compareTo(b));
  print(list);

  var val = fibonacciSearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = fibonacciSearch(list, (i) => i.compareTo(100));
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
  var worker = fibonacciSearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = fibonacciSearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
