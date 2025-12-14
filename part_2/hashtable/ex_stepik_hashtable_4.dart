import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода putIfAbsent
extension HashTablePutIfAbsent<K, V> on HashTable<K, V> {
  /// Вставка только при отсутствии
  /// Проверяет наличие ключа key.
  /// Если ключ уже существует -> ничего не делает (значение не перезаписывается).
  /// Если ключа нет -> добавляет новую пару key: value.
  void putIfAbsent(K key, V value) {
    if (!containsKey(key)) {
      add(key, value);
    }
  }
}

void main() {
  // Тест 1: Ключ отсутствует - добавляется
  var table1 = HashTable<String, int>();
  print('Состояние до: $table1');
  table1.putIfAbsent("a", 1);
  print('Состояние после putIfAbsent("a", 1): $table1'); // {"a": 1}
  print('');
  
  // Тест 2: Ключ существует - значение не перезаписывается
  print('Состояние до: $table1');
  table1.putIfAbsent("a", 2);
  print('Состояние после putIfAbsent("a", 2): $table1'); // {"a": 1} (значение не изменилось)
  print('');
  
  // Тест 3: Несколько вызовов
  var table2 = HashTable<int, String>();
  table2.putIfAbsent(1, "первый");
  table2.putIfAbsent(2, "второй");
  table2.putIfAbsent(1, "замененный"); // Не должен заменить
  table2.putIfAbsent(3, "третий");
  
  print('Таблица: $table2');
  print('Значение ключа 1: ${table2[1]}'); // "первый", а не "замененный"
  print('');
  
  // Тест 4: Пустая таблица
  var table3 = HashTable<String, String>();
  table3.putIfAbsent("key1", "value1");
  table3.putIfAbsent("key2", "value2");
  print('Таблица: $table3');
  print('Длина: ${table3.length}'); // 2
}

