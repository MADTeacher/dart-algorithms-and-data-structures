// Временная сложность: O(n)
// Память: O(1)
bool isMaxHeap(List<int> arr) {
  int n = arr.length;

  // Проверяем каждый внутренний узел
  for (int i = 0; i <= (n - 2) ~/ 2; i++) {
    int leftChild = 2 * i + 1;
    int rightChild = 2 * i + 2;

    // Проверяем левого ребенка
    if (leftChild < n && arr[i] < arr[leftChild]) {
      return false;
    }

    // Проверяем правого ребенка
    if (rightChild < n && arr[i] < arr[rightChild]) {
      return false;
    }
  }

  return true;
}

void main() {
  print(isMaxHeap([9, 4, 7, 1, 3, 6, 2]));
  print(isMaxHeap([9, 4, 7, 5, 3, 6, 2]));
}
