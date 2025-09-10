import 'doublylinkedlist.dart';

void main() {
  var integrityList = DoublyLinkedList.from([8, 3, 5, 4, 7, 6, 1, 2]);
  print('Исходный список: $integrityList');
  integrityList.partition(5);
  print('После разделения: $integrityList');
}