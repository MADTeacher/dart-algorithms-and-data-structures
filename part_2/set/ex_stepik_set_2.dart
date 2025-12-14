import 'set.dart';

/// Расширение для проверки на подмножество
extension MySetSubset<T> on MySet<T> {
  /// Проверяет, является ли текущее множество подмножеством другого
  /// 
  /// Возвращает true, если все элементы текущего множества (this)
  /// присутствуют в множестве other.
  /// Пустое множество является подмножеством любого множества.
  bool isSubsetOf(MySet<T> other) {
    // Пустое множество является подмножеством любого множества
    if (isEmpty) {
      return true;
    }
    
    // Проверяем, что все элементы текущего множества есть в other
    for (var element in this) {
      if (!other.isContains(element)) {
        return false;
      }
    }
    
    return true;
  }
}

void main() {
  final set1 = MySet<int>();
  set1.add(1);
  set1.add(2);
  
  final set2 = MySet<int>();
  set2.add(1);
  set2.add(2);
  set2.add(3);
  
  final set3 = MySet<int>();
  set3.add(1);
  set3.add(4);
  
  print('Set 1: $set1');
  print('Set 2: $set2');
  print('Set 3: $set3');
  
  print('{1, 2} является подмножеством {1, 2, 3}? ${set1.isSubsetOf(set2)}');
  // Ожидаемый результат: true
  
  print('{1, 4} является подмножеством {1, 2, 3}? ${set3.isSubsetOf(set2)}');
  // Ожидаемый результат: false
  
  // Пустое множество является подмножеством любого
  final emptySet = MySet<int>();
  print('Пустое множество является подмножеством {1, 2, 3}? ${emptySet.isSubsetOf(set2)}');
  // Ожидаемый результат: true
}



