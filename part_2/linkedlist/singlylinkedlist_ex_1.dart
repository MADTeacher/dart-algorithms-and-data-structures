import 'singlylinkedlist.dart';

void main() {
  var list = SinglyLinkedList.from([2, 3, 4, 2, 1, 2, 3, 4, 6, 7]);
  print('Исходный список: $list');
  removeDuplicates(list);
  print('После удаления дубликатов: $list');
}

// Временная сложность O(n^2), т.к. для каждого элемента 
// проверяем все последующие
//
// Память O(1), т.к. используем только указатели и
// не создаем дополнительные структуры данных
void removeDuplicates<T extends Comparable<dynamic>>(SinglyLinkedList<T> list) {
  if (list.isEmpty) return;
  
  // Проходим по каждому элементу списка
  for (int i = 0; i < list.length; i++) {
    T currentValue = list[i];
    
    // Проверяем все элементы после текущего
    int j = i + 1;
    while (j < list.length) {
      if (list[j].compareTo(currentValue) == 0) {
        // Найден дубликат - удаляем его
        list.removeAt(j);
        // Не увеличиваем j, так как элементы сдвинулись
      } else {
        j++;
      }
    }
  }
}
