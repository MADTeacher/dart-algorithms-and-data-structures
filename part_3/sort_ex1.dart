// Временная сложность: O(n)
// Память: O(1)
int buyChocolates(List<int> prices, int money) {
  int min1 = double.maxFinite.toInt();
  int min2 = double.maxFinite.toInt();
  // Ищем две наименьших цены на шоколадки
  for (int price in prices)
    if (price <= min1) {
      min2 = min1;
      min1 = price;
    } else if (price < min2) {
      min2 = price;
    }
  // Считаем стоимость двух самых дешевых шоколадок
  int minCost = min1 + min2;
  // Если стоимость больше денег, возвращаем money
  // иначе возвращаем money - minCost
  return minCost > money ? money : money - minCost;
}

void main() {
  print(buyChocolates([1, 5, 3, 4, 5], 10));
  print(buyChocolates([1, 2], 2));
}
