import 'dynamicarray.dart';

void main() {
  var dynamicArray = DynamicArray<int>.from([5,7,8,10, 5, 6, 17, 2, 1, 0]);
  // поиск максимального элемента
  // сложность O(n), память O(1)
  var maxElement = double.minPositive.toInt();
  for (int i = 0; i < dynamicArray.length; i++) {
    if (dynamicArray[i] > maxElement) {
      maxElement = dynamicArray[i];
    }
  }
  // или
  // var maxElement = dynamicArray.reduce((a, b) => a > b ? a : b);
  print(maxElement); // 17
}