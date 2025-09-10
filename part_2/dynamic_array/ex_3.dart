import 'dynamicarray.dart';

void main() {
  var dynamicArray1 = DynamicArray<int>.from([1, 4, 6, 7, 9, 12]);
  var dynamicArray2 = DynamicArray<int>.from([-2, 0, 1, 3, 5, 6]);
  // поиск медианы двух отсортированных массивов
  // с объединением массивов
  // сложность O(m+n), память O(m+n)

  // Объединяем два отсортированных массива в один отсортированный массив
  var merged = DynamicArray<int>(dynamicArray1.length + dynamicArray2.length);

  int i = 0, j = 0;

  // Слияние двух отсортированных массивов
  while (i < dynamicArray1.length && j < dynamicArray2.length) {
    if (dynamicArray1[i] <= dynamicArray2[j]) {
      merged.add(dynamicArray1[i]);
      i++;
    } else {
      merged.add(dynamicArray2[j]);
      j++;
    }
  }

  // Добавляем оставшиеся элементы из первого массива
  while (i < dynamicArray1.length) {
    merged.add(dynamicArray1[i]);
    i++;
  }

  // Добавляем оставшиеся элементы из второго массива
  while (j < dynamicArray2.length) {
    merged.add(dynamicArray2[j]);
    j++;
  }

  // Находим медиану
  int totalLength = merged.length;
  double median;
  if (totalLength % 2 == 1) {
    // Нечетное количество элементов - медиана это средний элемент
    median = merged[totalLength ~/ 2].toDouble();
  } else {
    // Четное количество элементов - медиана это среднее 
    // арифметическое двух средних элементов
    int mid1 = totalLength ~/ 2 - 1;
    int mid2 = totalLength ~/ 2;
    median = (merged[mid1] + merged[mid2]) / 2.0;
  }
  print('Median: $median');
}