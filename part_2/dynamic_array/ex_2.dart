import 'dynamicarray.dart';

void main() {
  int N = 8;
  var dynamicArray = DynamicArray<int>.from([5,7,8,10, 5, 6, 17, 2, 1, 0]);
  // поиск индексов элементов, чья сумма равна N
  // сложность O(n^2), память O(1)
  for (int i = 0; i < dynamicArray.length; i++) {
    for (int j = i + 1; j < dynamicArray.length; j++) {
      if (dynamicArray[i] + dynamicArray[j] == N) {
        print('$i = [${dynamicArray[i]}], $j = [${dynamicArray[j]}]');
      }
    }
  }
}

