import 'set.dart';

/// Расширение для группировки элементов множества
extension MySetGroupBy<T> on MySet<T> {
  /// Группирует элементы множества по ключу
  /// 
  /// Превращает плоское множество в словарь (Map), где ключом является
  /// признак элемента (вычисляется через keySelector), а значением —
  /// множество элементов с этим признаком.
  /// 
  /// [K] - тип ключа для группировки
  Map<K, MySet<T>> groupBy<K>(K Function(T) keySelector) {
    final result = <K, MySet<T>>{};
    
    // Проходим по всем элементам
    for (var element in this) {
      // Вычисляем ключ для элемента
      final key = keySelector(element);
      
      // Если ключа еще нет в мапе, создаем новое множество
      result.putIfAbsent(key, () => MySet<T>());
      
      // Добавляем элемент в соответствующее множество
      result[key]!.add(element);
    }
    
    return result;
  }
}

void main() {
  final mySet = MySet<String>();
  mySet.add('apple');
  mySet.add('ant');
  mySet.add('banana');
  mySet.add('cat');
  
  print('Исходное множество: $mySet');
  
  // Группировка по первой букве
  final grouped = mySet.groupBy((str) => str[0]);
  
  print('\nГруппировка по первой букве:');
  grouped.forEach((key, value) {
    print('  $key: $value');
  });
  // Ожидаемый результат:
  //   a: {apple, ant}
  //   b: {banana}
  //   c: {cat}
  
  // Дополнительный пример: группировка по длине строки
  final groupedByLength = mySet.groupBy((str) => str.length);
  print('\nГруппировка по длине строки:');
  groupedByLength.forEach((key, value) {
    print('  Длина $key: $value');
  });
  
  // Пример с числами
  final numberSet = MySet<int>();
  numberSet.add(1);
  numberSet.add(2);
  numberSet.add(3);
  numberSet.add(4);
  numberSet.add(5);
  numberSet.add(6);
  
  final groupedByParity = numberSet.groupBy((n) => n.isEven ? 'четные' : 'нечетные');
  print('\nГруппировка чисел по четности:');
  groupedByParity.forEach((key, value) {
    print('  $key: $value');
  });
}



