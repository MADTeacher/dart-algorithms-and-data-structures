// Временная сложность: O(log n)
// Память: O(1)
int searchInsert(List<int> nums, int target) {
  int left = 0;
  int right = nums.length - 1;

  while (left <= right) {
    int mid = left + (right - left) ~/ 2;

    if (nums[mid] == target) {
      // Элемент найден, возвращаем его индекс
      return mid;
    } else if (nums[mid] < target) {
      // Целевое значение больше, ищем в правой половине
      left = mid + 1;
    } else {
      // Целевое значение меньше, ищем в левой половине
      right = mid - 1;
    }
  }

  // Элемент не найден, возвращаем позицию для вставки
  return left;
}

// Рекурсивная реализация
int searchInsertRecursive(
  List<int> nums,
  int target, [
  int left = 0,
  int? right,
]) {
  right ??= nums.length - 1;

  if (left > right) {
    return left;
  }

  int mid = left + (right - left) ~/ 2;

  if (nums[mid] == target) {
    return mid;
  } else if (nums[mid] < target) {
    return searchInsertRecursive(nums, target, mid + 1, right);
  } else {
    return searchInsertRecursive(nums, target, left, mid - 1);
  }
}

void main() {
  var list = [1, 3, 5, 6, 8, 10, 12];
  var target = 7;
  var result = searchInsert(list, target);
  var recursiveResult = searchInsertRecursive(list, target);
  print('Массив: $list');
  print('Целевое значение: $target');
  print('Результат: $result');
  print('Результат (рекурсия): $recursiveResult\n');

  target = 5;
  result = searchInsert(list, target);
  print('Массив: $list');
  print('Целевое значение: $target');
  print('Результат: $result\n');
}
