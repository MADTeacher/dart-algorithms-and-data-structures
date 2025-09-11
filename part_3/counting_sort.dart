extension CountingSort on List<int> {
  void countingSort({bool isAscending = true}) {
    // Находим минимальное и максимальное значения в массиве
    // Это нужно для определения диапазона значений
    int min = this[0];
    int max = this[0];
    for (int i = 1; i < length; i++) {
      if (this[i] < min) {
        min = this[i];
      }
      if (this[i] > max) {
        max = this[i];
      }
    }

    // Создаем массив для подсчета количества каждого элемента
    // Чтобы покрыть весь диапазон значений,
    // его размер должен быть = (max - min + 1)
    List<int> count = List<int>.filled(max - min + 1, 0);

    // Подсчитываем количество каждого элемента
    // Индекс в массиве count = (значение элемента - min)
    for (var it in this) {
      count[it - min]++;
    }

    // Сортировка по возрастанию
    if (isAscending) {
      int index = 0;
      for (int i = 0; i < count.length; i++) {
        // Для каждого значения записываем его столько раз,
        // сколько оно встречается
        while (count[i] > 0) {
          // Восстанавливаем исходное значение: индекс + min
          this[index++] = i + min;
          count[i]--;
        }
      }
    } else {
      // Сортировка по убыванию
      int index = length - 1;
      for (int i = count.length - 1; i >= 0; i--) {
        // Записываем значения в обратном порядке
        while (count[i] > 0) {
          // Восстанавливаем исходное значение: индекс + min
          this[index--] = i + min;
          count[i]--;
        }
      }
    }
  }
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.countingSort();
  print(list); // [11, 12, 22, 25, 34, 64, 90]
}
