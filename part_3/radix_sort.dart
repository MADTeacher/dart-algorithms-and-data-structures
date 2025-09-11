extension RadixSort on List<int> {
  int _getMax(List<int> arr) {
    int aMax = -double.maxFinite.toInt();
    for (int val in arr) {
      if (aMax < val) {
        aMax = val;
      }
    }
    return aMax;
  }

  List<int> radixSort(List<int> arr) {
    if (arr.isEmpty) {
      throw ArgumentError('Array is empty');
    }

    int digPlace = 1;
    List<int> result = List<int>.filled(arr.length, 0);

    int maxNumber = _getMax(arr);
    while ((maxNumber ~/ digPlace) > 0) {
      // частота чисел от 0 до 9
      List<int> count = List<int>.filled(10, 0);

      for (int val in arr) {
        count[(val ~/ digPlace) % 10]++;
      }

      for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
      }

      for (int i = arr.length - 1; i >= 0; i--) {
        result[count[(arr[i] ~/ digPlace) % 10] - 1] = arr[i];
        count[(arr[i] ~/ digPlace) % 10]--;
      }

      for (int i = 0; i < arr.length; i++) {
        arr[i] = result[i];
      }

      digPlace *= 10;
    }

    return arr;
  }
}

void main() {
  List<int> arr = [1, 2, 6, 0, 362, 214, 22, 54, 109, 5, 3];
  print('Array before sort: $arr');
  List<int> sortedArray = arr.radixSort(arr);
  print('Array after sorting: $sortedArray');
}
