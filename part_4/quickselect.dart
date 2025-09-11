import 'dart:math';

class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

final Random _generator = Random();

T quickSelect<T>(List<T> arr, int k, int Function(T a, T b) compare) {
  // Проверяем, что массив не пустой
  if (arr.isEmpty) {
    throw ArgumentError('Array cannot be empty');
  }

  // Проверяем, что k находится в допустимом диапазоне
  if (k <= 0 || k > arr.length) {
    throw ArgumentError('k must be between 1 and ${arr.length}');
  }

  // Если массив состоит из одного элемента
  if (arr.length == 1) {
    return arr[0];
  }

  // Выбираем случайный элемент как опорный
  T pivot = arr[_generator.nextInt(arr.length)];
  List<T> L = [];
  List<T> M = [];
  List<T> R = [];

  // Разделяем массив на три части
  for (T val in arr) {
    int cmp = compare(pivot, val);
    if (cmp > 0) {
      L.add(val);
    } else if (cmp == 0) {
      M.add(val);
    } else {
      R.add(val);
    }
  }

  // Если k меньше или равно длине левой части
  if (k <= L.length) {
    // Рекурсивно ищем в левой части
    return quickSelect(L, k, compare);
  } else if (k <= (L.length + M.length)) {
    // Если k находится в диапазоне левой части и средней части
    return pivot;
  } else {
    // Иначе ищем в правой части
    return quickSelect(R, k - (L.length + M.length), compare);
  }
}

void main() {
  List<int> arr = [3, -2, 0, 4, 22, -1, 34, 10, 5, 7, 9];

  print('Array: $arr');

  int k = 3;
  int kMin = quickSelect(arr, k, (a, b) => a.compareTo(b));
  print('${k}th min element is: $kMin');

  k = 2;
  kMin = quickSelect(arr, k, (a, b) => a.compareTo(b));
  print('${k}th min element is: $kMin');

  k = 5;
  kMin = quickSelect(arr, k, (a, b) => a.compareTo(b));
  print('${k}th min element is: $kMin');

  print('*' * 20);

  // Пример с объектами Worker
  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];

  print('Workers: $workers');

  // Поиск k-го минимального элемента по id
  k = 2;
  Worker kMinWorker = quickSelect(workers, k, (a, b) => a.id.compareTo(b.id));
  print('${k}nd min worker by id: $kMinWorker');

  k = 4;
  kMinWorker = quickSelect(workers, k, (a, b) => a.id.compareTo(b.id));
  print('${k}th min worker by id: $kMinWorker');
}
