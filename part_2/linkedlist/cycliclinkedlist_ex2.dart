import 'circliclinkedlist.dart';

void main() {
 var list1 = CyclicLinkedList.from([1, 2, 3, 4, 5]);
 var list2 = CyclicLinkedList.from([6, 7, 8, 9, 10]);
 print('Первый список: ${list1.toList()}');
 print('Второй список: ${list2.toList()}');
 list1.merge(list2);
 print('Объединенный список: ${list1.toList()}');
}
