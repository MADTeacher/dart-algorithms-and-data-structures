// Временная сложность: O(n)
// Память: O(1)
int firstMissingPositive(List<int> nums) {
  int n = nums.length;

  // Размещаем каждое число в правильную позицию
  // Число i должно быть на позиции i-1 (если оно в диапазоне [1, n])
  for (int i = 0; i < n; i++) {
    // Продолжаем размещать числа, пока текущее число
    // не окажется на правильном месте
    while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
      // Меняем местами nums[i] и nums[nums[i] - 1]
      int temp = nums[nums[i] - 1];
      nums[nums[i] - 1] = nums[i];
      nums[i] = temp;
    }
  }

  // Находим первое число, которое не на своем месте
  for (int i = 0; i < n; i++) {
    if (nums[i] != i + 1) {
      return i + 1;
    }
  }

  // Если все числа от 1 до n на своих местах,
  // возвращаем n + 1
  return n + 1;
}

void main() {
  List<int> nums = [3, 4, 2, 1];
  int result = firstMissingPositive(nums);
  print('Массив: $nums');
  print('Результат: $result\n');

  nums = [1, 2, 0];
  result = firstMissingPositive(nums);
  print('Массив: $nums');
  print('Результат: $result\n');

  nums = [7, 8, 9, 11, 12];
  result = firstMissingPositive(nums);
  print('Массив: $nums');
  print('Результат: $result\n');
}
