import 'counting_sort.dart';

// Временная сложность: O(nlogn)
// Память: O(n)
int countOperationsToEmptyArray(List<int> nums) {
  final int n = nums.length; // Длина массива
  // Инициализируем переменную значением,
  // которое вернется в самом худшем случае
  int result = n;
  Map<int, int> numToIndex = {};

  // Сохраняем индексы каждого числа
  for (int i = 0; i < n; i++) {
    numToIndex[nums[i]] = i;
  }

  // Создаем копию массива и сортируем
  List<int> sortedNums = List.from(nums);
  sortedNums.countingSort();

  for (int i = 1; i < n; i++) {
    // На i-ом шаге мы уже удалили i - 1 наименьших чисел
    // и можем их игнорировать. Если элемент sortedNums[i]
    // имеет меньший индекс в оригинальном массиве,
    // чем sortedNums[i - 1], то нужно повернуть
    // весь левый массив n - i раз, чтобы установить
    // элемент sortedNums[i] на первую позицию.
    if (numToIndex[sortedNums[i]]! < numToIndex[sortedNums[i - 1]]!) {
      result += n - i;
    }
  }

  return result;
}

void main() {
  List<int> nums1 = [2, 3, -2];
  print('Input: $nums1');
  print('Output: ${countOperationsToEmptyArray(nums1)}\n');

  List<int> nums2 = [2, 4, 5, 7];
  print('Input: $nums2');
  print('Output: ${countOperationsToEmptyArray(nums2)}\n');

  List<int> nums3 = [1, 2, 3];
  print('Input: $nums3');
  print('Output: ${countOperationsToEmptyArray(nums3)}');
}
