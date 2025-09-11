// Временная сложность: O(log(min(m,n)))
// Память: O(1)
double findMedianSortedArrays(List<int> nums1, List<int> nums2) {
  // Если nums1 больше nums2, меняем их местами
  // исходим из гипотезы о том, что nums1
  // имеет меньшую длину
  if (nums1.length > nums2.length) {
    return findMedianSortedArrays(nums2, nums1);
  }

  int m = nums1.length;
  int n = nums2.length;
  int totalLength = m + n;
  int halfLength = (totalLength + 1) ~/ 2;

  int left = 0;
  int right = m;

  while (left <= right) {
    // Разделяем nums1 на позиции i
    int i = (left + right) ~/ 2;
    // Разделяем nums2 на позиции j
    int j = halfLength - i;

    // Получаем элементы на границах разделения
    // Используем минимальные и максимальные значения int
    int maxLeft1 = (i == 0) ? -2147483648 : nums1[i - 1];
    int minRight1 = (i == m) ? 2147483647 : nums1[i];

    int maxLeft2 = (j == 0) ? -2147483648 : nums2[j - 1];
    int minRight2 = (j == n) ? 2147483647 : nums2[j];

    // Проверяем правильность разделения
    if (maxLeft1 <= minRight2 && maxLeft2 <= minRight1) {
      // Найдено правильное разделение
      if (totalLength % 2 == 1) {
        // Нечетное количество элементов
        return [maxLeft1, maxLeft2].reduce((a, b) => a > b ? a : b).toDouble();
      } else {
        // Четное количество элементов
        int maxLeft = [maxLeft1, maxLeft2].reduce((a, b) => a > b ? a : b);
        int minRight = [minRight1, minRight2].reduce((a, b) => a < b ? a : b);
        return (maxLeft + minRight) / 2.0;
      }
    } else if (maxLeft1 > minRight2) {
      // i слишком большое, уменьшаем
      right = i - 1;
    } else {
      // i слишком маленькое, увеличиваем
      left = i + 1;
    }
  }

  throw Exception('Входные массивы не отсортированы');
}

void main() {
  List<int> nums1 = [1, 3];
  List<int> nums2 = [2];
  double result1 = findMedianSortedArrays(nums1, nums2);
  print('Первый массив: $nums1');
  print('Второй массив: $nums2');
  print('Медиана: $result1\n');

  nums1 = [1, 2];
  nums2 = [3, 4];
  result1 = findMedianSortedArrays(nums1, nums2);
  print('Первый массив: $nums1');
  print('Второй массив: $nums2');
  print('Медиана: $result1\n');

  nums1 = [1, 3, 8];
  nums2 = [7, 9, 10, 11];
  result1 = findMedianSortedArrays(nums1, nums2);
  print('Первый массив: $nums1');
  print('Второй массив: $nums2');
  print('Медиана: $result1\n');
}
