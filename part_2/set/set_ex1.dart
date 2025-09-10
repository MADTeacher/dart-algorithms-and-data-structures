import 'set.dart';
import '../linkedlist/singlylinkedlist.dart';

void main() {
  var list = SinglyLinkedList.from([1, 2, 1, 4, 1, 6, 2, 8, 9, 4]);
  print('Исходный список: $list');

  // Удаляем дубликаты через промежуточное множество
  // Временная сложность: O(n)
  // Память: O(n)
  var list2 = SinglyLinkedList.from(MySet.from(list));
  print('Список без дубликатов: $list2');

  // Удаляем дубликаты, итерируясь по односвязному списку
  // Временная сложность: O(n)
  // Память: O(n)
  var set = MySet<int>();
  var list3 = SinglyLinkedList<int>();
  for (var element in list) {
    if (!set.contains(element)) {
      set.add(element);
      list3.push(element);
    }
  }
  print('Список без дубликатов: $list3');
}
