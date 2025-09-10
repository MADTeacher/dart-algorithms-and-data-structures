import 'heap.dart';

// Временная сложность: O(n log k),
// где n - количество элементов в массиве,
// k - размер heap
// Память: O(k)
int findKthLargest(List<int> nums, int k) {
  Heap<int> minHeap = Heap<int>(isMaxHeap: false);

  // Добавляем k наибольший элемент в heap
  for (int num in nums) {
    // Если размер heap меньше k, добавляем элемент
    if (minHeap.size < k) {
      minHeap.insert(num);
    }
    // Если текущий элемент больше наименьшего
    // в heap, то заменяем его
    else if (num > minHeap.peek()) {
      minHeap.extract(); // Удаляем наименьший
      minHeap.insert(num); // Добавляем новый
    }
  }
  // Возвращаем k-й наибольший элемент
  return minHeap.peek();
}

void main() {
  var nums = [3, 2, 1, 5, 6, 4];
  print(findKthLargest(nums, 2));
  print(findKthLargest(nums, 3));
}
