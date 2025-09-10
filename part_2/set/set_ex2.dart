import 'set.dart';
import '../linkedlist/singlylinkedlist.dart';

void isContainsDuplicates<T extends Comparable<T>>(SinglyLinkedList<T> list) {
  var set = MySet<T>();
  for (var element in list) {
    if (set.contains(element)) {
      print('Список содержит дубликаты');
      return;
    }
    set.add(element);
  }
  print('Список не содержит дубликатов');
}

void main() {
  // Временная сложность: O(n)
  // Память: O(n)
  var list = SinglyLinkedList.from([1, 3, 2, 1, 4, 1, 6, 2, 8, 9, 4]);
  isContainsDuplicates(list);

  list = SinglyLinkedList.from([1, 3, 2, 4, 6, 8, 9]);
  isContainsDuplicates(list);
}
