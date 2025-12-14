import 'set.dart';

/// Расширение для разбиения множества
extension MySetPartition<T> on MySet<T> {
  /// Разбивает множество на две части по заданному предикату
  /// 
  /// Возвращает список, содержащий ровно два объекта MySet:
  /// - Индекс 0: Множество элементов, удовлетворяющих условию (true)
  /// - Индекс 1: Множество элементов, не удовлетворяющих условию (false)
  /// 
  /// Эффективное распределение элементов за один проход.
  List<MySet<T>> partition(bool Function(T) predicate) {
    final trueSet = MySet<T>();
    final falseSet = MySet<T>();
    
    // Один проход по множеству
    for (var element in this) {
      if (predicate(element)) {
        trueSet.add(element);
      } else {
        falseSet.add(element);
      }
    }
    
    return [trueSet, falseSet];
  }
}

void main() {
  final mySet = MySet<int>();
  mySet.add(1);
  mySet.add(2);
  mySet.add(3);
  mySet.add(4);
  mySet.add(5);
  
  print('Исходное множество: $mySet');
  
  // Разбиение на четные и нечетные
  final result = mySet.partition((x) => x.isEven);
  
  print('Элементы, удовлетворяющие условию (четные): ${result[0]}');
  // Ожидаемый результат: {2, 4}
  
  print('Элементы, не удовлетворяющие условию (нечетные): ${result[1]}');
  // Ожидаемый результат: {1, 3, 5}
  
  // Дополнительный пример: разбиение на числа больше 3
  final result2 = mySet.partition((x) => x > 3);
  print('\nЭлементы > 3: ${result2[0]}');
  print('Элементы <= 3: ${result2[1]}');
}



