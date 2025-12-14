import 'set.dart';

/// Расширение для атомарных транзакций
extension MySetTransaction<T> on MySet<T> {
  /// Выполняет серию операций атомарно с возможностью отката
  /// 
  /// Запоминает текущее состояние множества, выполняет функцию action.
  /// Если action выполняется без ошибок — сохраняет изменения и возвращает true.
  /// Если action выбрасывает исключение — отменяет все изменения
  /// (восстанавливает из бэкапа) и возвращает false.
  /// Исключение наружу не выбрасывается (подавляется).
  bool performTransaction(void Function(MySet<T>) action) {
    // Создаем бэкап текущего состояния
    final backup = MySet<T>.from(this);
    
    try {
      // Выполняем действие
      action(this);
      
      // Если все прошло успешно, возвращаем true
      return true;
    } catch (e) {
      // В случае ошибки восстанавливаем состояние из бэкапа
      _restoreFromBackup(backup);
      
      // Исключение не выбрасываем наружу, только возвращаем false
      return false;
    }
  }
  
  /// Восстанавливает состояние множества из бэкапа
  void _restoreFromBackup(MySet<T> backup) {
    // Очищаем текущее множество
    clear();
    
    // Восстанавливаем все элементы из бэкапа
    for (var element in backup) {
      add(element);
    }
  }
}

void main() {
  final mySet = MySet<int>();
  mySet.add(1);
  mySet.add(2);
  
  print('Начальное множество: $mySet');
  
  // Успешная транзакция
  final success = mySet.performTransaction((set) {
    set.add(3);
    set.add(4);
  });
  
  print('После успешной транзакции: $mySet');
  print('Результат транзакции: $success');
  // Ожидаемый результат: {1, 2, 3, 4}, success = true
  
  // Транзакция с ошибкой
  final failure = mySet.performTransaction((set) {
    set.add(5);
    throw Exception('Произошла ошибка!');
    // set.add(6); - этот код не выполнится
  });
  
  print('После транзакции с ошибкой: $mySet');
  print('Результат транзакции: $failure');
  // Ожидаемый результат: {1, 2, 3, 4} (без изменений), failure = false
  // Элемент 5 не должен быть добавлен, так как произошла ошибка
  
  // Дополнительный пример: несколько операций с ошибкой в середине
  print('\n--- Дополнительный пример ---');
  final testSet = MySet<String>();
  testSet.add('A');
  testSet.add('B');
  
  print('Начальное множество: $testSet');
  
  final result = testSet.performTransaction((set) {
    set.add('C');
    set.add('D');
    throw StateError('Ошибка после добавления C и D');
    // set.add('E'); - этот код не выполнится из-за throw выше
  });
  
  print('После транзакции: $testSet');
  print('Результат: $result');
  // Ожидаемый результат: {A, B} (все изменения откачены), result = false
}

