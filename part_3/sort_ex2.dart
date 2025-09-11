import 'counting_sort.dart';

// Временная сложность: O(n)
// Память: O(1)
int buyChocolates(List<int> prices, int money) {
  if (prices.isEmpty) return 0;
  // Сортируем цены на шоколадки
  prices.countingSort();

  // Перебираем цены на шоколадки
  for (int i = 0; i < prices.length; ++i)
    // Если денег достаточно, покупаем шоколадку
    if (money >= prices[i])
      money -= prices[i];
    // Если денег недостаточно,
    // возвращаем количество купленных шоколадок
    else
      return i;

  // Если денег достаточно на все шоколадки,
  // возвращаем количество шоколадок
  return prices.length;
}

void main() {
  print(buyChocolates([1, 5, 3, 4, 2, 5], 10));
  print(buyChocolates([1, 2], 2));
}
