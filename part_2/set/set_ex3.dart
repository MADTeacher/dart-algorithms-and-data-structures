import 'set.dart';

void main() {
  // Временная сложность: O(n)
  // Память: O(n)
  var list1 = ['John', 'Jane', 'Bob', 'Alice'];
  var list2 = ['Bob', 'Alice', 'Tom', 'Sara'];

  var set1 = MySet.from(list1);
  var set2 = MySet.from(list2);

  var intersection = set1.intersection(set2);
  print(intersection);
}
