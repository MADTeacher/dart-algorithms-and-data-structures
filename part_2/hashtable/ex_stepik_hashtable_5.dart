import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода addAll
extension HashTableAddAll<K, V> on HashTable<K, V> {
  /// Слияние таблиц
  /// Принимает другую хеш-таблицу того же типа.
  /// Проходит по всем элементам таблицы other и добавляет их в текущую таблицу.
  /// Если ключ из other уже есть в текущей таблице, 
  /// значение перезаписывается значением из other.
  void addAll(HashTable<K, V> other) {
    other.forEach((key, value) {
      add(key, value);
    });
  }
}

void main() {
  // Тест 1: Базовый пример из задания
  var table1 = HashTable<String, int>();
  table1["a"] = 1;
  table1["b"] = 9;
  
  var table2 = HashTable<String, int>();
  table2["b"] = 2;
  table2["c"] = 3;
  
  print('Таблица this до: $table1');
  print('Таблица other: $table2');
  
  table1.addAll(table2);
  
  print('Таблица this после: $table1'); // {"a": 1, "b": 2, "c": 3}
  print('Ключ "b" перезаписан: ${table1["b"]}'); // 2 (было 9)
  print('');
  
  // Тест 2: Пустая таблица other
  var table3 = HashTable<int, String>();
  table3[1] = "один";
  table3[2] = "два";
  
  var emptyTable = HashTable<int, String>();
  
  print('Таблица this до: $table3');
  print('Таблица other (пустая): $emptyTable');
  
  table3.addAll(emptyTable);
  
  print('Таблица this после: $table3'); // Не изменилась
  print('');
  
  // Тест 3: Пустая таблица this
  var table4 = HashTable<String, int>();
  var table5 = HashTable<String, int>();
  table5["x"] = 10;
  table5["y"] = 20;
  
  print('Таблица this (пустая): $table4');
  print('Таблица other: $table5');
  
  table4.addAll(table5);
  
  print('Таблица this после: $table4'); // {"x": 10, "y": 20}
  print('');
  
  // Тест 4: Полное перезаписывание
  var table6 = HashTable<int, String>();
  table6[1] = "старое";
  table6[2] = "старое";
  
  var table7 = HashTable<int, String>();
  table7[1] = "новое";
  table7[2] = "новое";
  
  print('Таблица this до: $table6');
  table6.addAll(table7);
  print('Таблица this после: $table6'); // Все значения "новое"
}

