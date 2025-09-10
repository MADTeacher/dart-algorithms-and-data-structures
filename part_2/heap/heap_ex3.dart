import 'heap.dart';

class FrequencyElement implements Comparable<FrequencyElement> {
  final int value;
  final int frequency;

  FrequencyElement(this.value, this.frequency);

  @override
  int compareTo(FrequencyElement other) {
    // Сравниваем по частоте
    return frequency.compareTo(other.frequency);
  }

  @override
  String toString() => 'FreqElement($value: $frequency)';
}

// Временная сложность: O(n log k), где
// n - количество элементов в массиве,
// k - количество самых частых элементов
// Память: O(n + k)
List<int> topKFrequent(List<int> nums, int k) {
  // Подсчитываем частоты
  Map<int, int> frequencyMap = {};
  for (int num in nums) {
    frequencyMap[num] = (frequencyMap[num] ?? 0) + 1;
  }

  // Используем min-heap для хранения k самых частых элементов
  Heap<FrequencyElement> minHeap = Heap<FrequencyElement>(isMaxHeap: false);

  // Добавляем k-наибольший элемент в heap
  for (var entry in frequencyMap.entries) {
    FrequencyElement element = FrequencyElement(entry.key, entry.value);
    // Если размер heap меньше k, добавляем элемент
    if (minHeap.size < k) {
      minHeap.insert(element);
    } else if (element.frequency > minHeap.peek().frequency) {
      // Если текущий элемент больше наименьшего
      // в heap, то заменяем его
      minHeap.extract();
      minHeap.insert(element);
    }
  }

  // Извлекаем результат
  List<int> result = [];
  while (!minHeap.isEmpty) {
    result.add(minHeap.extract().value);
  }

  return result.reversed.toList();
}

void main() {
  var nums = [1, 1, 1, 2, 2, 3, 3, 3, 4, 5];
  print(topKFrequent(nums, 2));
  print(topKFrequent(nums, 3));
}
