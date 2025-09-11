// Временная сложность: O(log x)
// Память: O(1)
int mySqrt(int x) {
  if (x == 0 || x == 1) {
    return x;
  }

  int left = 1;
  int right = x;
  int result = 0;

  while (left <= right) {
    int mid = left + (right - left) ~/ 2;

    // Проверяем, не превышает ли mid * mid значение x
    // Используем деление вместо умножения для избежания переполнения
    if (mid <= x ~/ mid) {
      result = mid; // Сохраняем потенциальный результат
      left = mid + 1; // Ищем большее значение
    } else {
      right = mid - 1; // Уменьшаем диапазон поиска
    }
  }

  return result;
}

// Простая реализация через линейный поиск
// Временная сложность: O(x)
// Память: O(1)
int mySqrtLinear(int x) {
  if (x == 0 || x == 1) {
    return x;
  }

  for (int i = 1; i <= x; i++) {
    if (i * i == x) {
      return i;
    } else if (i * i > x) {
      return i - 1;
    }
  }

  return 0;
}

void main() {
  print('Корень из 25');
  print(mySqrt(25));
  print(mySqrtLinear(25));

  print('Корень из 19');
  print(mySqrt(19));
  print(mySqrtLinear(19));
}
