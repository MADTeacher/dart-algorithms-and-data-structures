import 'hashtable.dart';

void main() {
  // Временная сложность O(n)
  // Пространственная сложность O(n)

  var array = [1, 2, 4, 3, 2, 5, 6, 4, 2, 1, 2];
  var hashtable = HashTable<int, int>();

  // Обходим массив и заполняем хеш-таблицу
  for (var element in array) {
    // Если элемент уже хранится в хеш-таблице,
    // увеличиваем счетчик
    if (hashtable.containsKey(element)) {
      hashtable[element] = hashtable[element]! + 1;
    } else {
      // Если элемента нет в хеш-таблице,
      // добавляем его с счетчиком 1
      hashtable[element] = 1;
    }
  }

  // Обходим хеш-таблицу и находим элемент с
  // наибольшим количеством вхождений
  var maxCount = 0;
  var maxElement = 0;
  for (var element in array) {
    if (hashtable[element]! > maxCount) {
      maxCount = hashtable[element]!;
      maxElement = element;
    }
  }

  print('$maxElement - $maxCount');
}
