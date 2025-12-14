import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода getOrDefault
extension HashTableGetOrDefault<K, V> on HashTable<K, V> {
  /// Безопасное получение с дефолтным значением
  /// Ищет значение по ключу.
  /// Если ключ есть -> возвращает связанное значение.
  /// Если ключа нет -> возвращает defaultValue, не добавляя его в таблицу.
  V getOrDefault(K key, V defaultValue) {
    V? value = get(key);
    return value ?? defaultValue;
  }
}

void main() {
  // Тест 1: Ключ существует
  var table1 = HashTable<String, int>();
  table1["A"] = 100;
  
  print('Таблица: $table1');
  print('getOrDefault("A", 0): ${table1.getOrDefault("A", 0)}'); // 100
  print('');
  
  // Тест 2: Ключ не существует
  print('getOrDefault("B", 0): ${table1.getOrDefault("B", 0)}'); // 0
  print('Таблица после getOrDefault: $table1'); // Не изменилась
  print('');
  
  // Тест 3: Строковые значения
  var table2 = HashTable<String, String>();
  table2["name"] = "Иван";
  table2["city"] = "Москва";
  
  print('Таблица: $table2');
  print('getOrDefault("name", "Неизвестно"): ${table2.getOrDefault("name", "Неизвестно")}'); // "Иван"
  print('getOrDefault("age", "Неизвестно"): ${table2.getOrDefault("age", "Неизвестно")}'); // "Неизвестно"
  print('');
  
  // Тест 4: Проверка, что defaultValue не добавляется в таблицу
  var table3 = HashTable<int, String>();
  table3[1] = "один";
  
  print('Таблица до: $table3');
  var result = table3.getOrDefault(2, "два");
  print('getOrDefault(2, "два"): $result');
  print('Таблица после: $table3'); // Не изменилась, ключ 2 не добавлен
  print('Длина таблицы: ${table3.length}'); // 1
}

