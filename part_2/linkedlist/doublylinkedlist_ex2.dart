import 'doublylinkedlist.dart';

void main() {
  var list = DoublyLinkedList.from([1, 2, 3, 4, 5]);
  print('Список: $list');
  print('Палиндром?: ${list.isPalindrome()}\n');
  
  list = DoublyLinkedList.from([1, 2, 3, 2, 1]);
  print('Список: $list');
  print('Палиндром?: ${list.isPalindrome()}');
}
