import 'doublylinkedlist.dart';

void main() {
  var list = DoublyLinkedList.from([1, 2, 3, 4, 5]);
  print(list.toStringReverse());
}