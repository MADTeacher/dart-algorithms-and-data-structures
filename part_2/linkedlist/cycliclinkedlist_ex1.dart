import 'circliclinkedlist.dart';

void main() {
  var list = CyclicLinkedList.from([7, 3, 7, 1, 7, 2, 7]);
  print('Список: ${list.toList()}');
  print('Количество вхождений 7: ${list.count(7)}');
  print('Количество вхождений 3: ${list.count(3)}');
  print('Количество вхождений 99: ${list.count(99)}');
}
