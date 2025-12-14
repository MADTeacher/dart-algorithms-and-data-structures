import 'set.dart';

/// Расширение для реализации симметрической разности множеств
extension MySetSymmetricDifference<T> on MySet<T> {
  /// Симметрическая разность (XOR) двух множеств
  /// Возвращает множество элементов, которые есть либо в первом,
  /// либо во втором множестве, но не в обоих сразу
  /// 
  /// Формула: (A - B) + (B - A)
  MySet<T> symmetricDifference(MySet<T> other) {
    final result = MySet<T>();
    
    // Добавляем элементы из (A - B)
    for (var element in this) {
      if (!other.isContains(element)) {
        result.add(element);
      }
    }
    
    // Добавляем элементы из (B - A)
    for (var element in other) {
      if (!this.isContains(element)) {
        result.add(element);
      }
    }
    
    return result;
  }
}

void main() {
  final setA = MySet<int>();
  setA.add(1);
  setA.add(2);
  setA.add(3);
  
  final setB = MySet<int>();
  setB.add(3);
  setB.add(4);
  setB.add(5);
  
  print('Set A: $setA');
  print('Set B: $setB');
  
  final symmetricDiff = setA.symmetricDifference(setB);
  print('Симметрическая разность: $symmetricDiff');
  // Ожидаемый результат: {1, 2, 4, 5}
}



