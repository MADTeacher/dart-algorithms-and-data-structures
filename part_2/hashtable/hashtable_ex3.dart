import 'hashtable.dart';

void main() {
  // Временная сложность: O(n)
  // Память: O(n)

  int N = 8;
  var list = [5, 7, 8, 10, 5, 6, 17, 2, 1, 0];
  var hashtable = HashTable<int, int>();

  for (int i = 0; i < list.length; i++) {
    if (hashtable.containsKey(N - list[i])) {
      var str1 = '${hashtable[N - list[i]]} = [${N - list[i]}]';
      var str2 = '$i = [${list[i]}]';
      print('$str1, $str2');
    }
    hashtable[list[i]] = i;
  }
}

// 5 = [6], 7 = [2]
// 1 = [7], 8 = [1]
// 2 = [8], 9 = [0]
