import 'queue_array.dart';

// Временная сложность: O(n)
// Память: O(n)
T? findFirstUnique<T>(ArrayQueue<T> queue) {
  if (queue.isEmpty) return null;

  // Таблица для подсчета количества вхождений каждого элемента
  Map<T, int> elementCount = {};

  // Список для сохранения порядка элементов
  List<T> elements = [];

  // Извлекаем все элементы из очереди для подсчета
  while (!queue.isEmpty) {
    T element = queue.dequeue();
    elements.add(element);
    elementCount[element] = (elementCount[element] ?? 0) + 1;
  }

  // Восстанавливаем очередь
  for (T element in elements) {
    queue.enqueue(element);
  }

  // Находим первый элемент с количеством вхождений равным 1
  for (T element in elements) {
    if (elementCount[element] == 1) {
      return element;
    }
  }

  return null; // Уникальный элемент не найден
}

void main() {
  var queue = ArrayQueue<int>();
  [1, 2, 3, 2, 4, 1, 5].forEach(queue.enqueue);
  print(findFirstUnique(queue));

  queue.clear();
  [4, 5, 6, 7, 6, 4, 2, 7, 5, 9].forEach(queue.enqueue);
  print(findFirstUnique(queue));

  queue.clear();
  print(findFirstUnique(queue));
}
