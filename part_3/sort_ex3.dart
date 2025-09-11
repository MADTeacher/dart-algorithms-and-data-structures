// Временная сложность: O(n + k),
// где n - количество элементов в arr1,
// k - количество уникальных элементов в arr1
// Память: O(k)
List<int> relativeSortArray(List<int> arr1, List<int> arr2) {
  if (arr1.isEmpty) return [];

  // Результирующий массив
  List<int> ans = [];
  // Объявляем массив для подсчета количества каждого элемента,
  // размером 1001, так как максимальное значение элемента - 1000
  List<int> count = List<int>.filled(1001, 0);

  // Подсчитываем количество каждого элемента
  for (int n in arr1) {
    ++count[n];
  }

  // Добавляем элементы из arr2 в результирующий массив
  for (int n in arr2) {
    while (count[n]-- > 0) {
      ans.add(n);
    }
  }

  // Добавляем оставшиеся элементы в результирующий массив
  for (int num = 0; num < 1001; ++num) {
    while (count[num]-- > 0) {
      ans.add(num);
    }
  }

  return ans;
}

void main() {
  var arr1 = [2, 3, 1, 3, 2, 4, 6, 7, 9, 2, 19];
  var arr2 = [2, 1, 4, 3, 9, 6];
  print(relativeSortArray(arr1, arr2));
}

// [2, 2, 2, 1, 4, 3, 3, 9, 6, 7, 19]
