import 'hashtable_v.1.dart';

// Расширение HashTable для добавления геттера keys
extension HashTableKeys<K, V> on HashTable<K, V> {
  /// Получение списка всех ключей
  /// Собирает все ключи, хранящиеся в данный момент в таблице, 
  /// в один список и возвращает его.
  /// Порядок ключей не важен (зависит от хешей).
  List<K> get keys {
    List<K> result = [];
    
    // Используем forEach для сбора всех ключей
    forEach((key, value) {
      result.add(key);
    });
    
    return result;
  }
}

void main() {
  // Тест 1: Обычная таблица
  var table1 = HashTable<String, int>();
  table1["id"] = 1;
  table1["score"] = 99;
  
  print('Таблица: $table1');
  var keys1 = table1.keys;
  print('Ключи: $keys1'); // ["id", "score"] (порядок может отличаться)
  print('Количество ключей: ${keys1.length}'); // 2
  print('');
  
  // Тест 2: Пустая таблица
  var table2 = HashTable<String, int>();
  print('Пустая таблица: $table2');
  var keys2 = table2.keys;
  print('Ключи: $keys2'); // []
  print('Количество ключей: ${keys2.length}'); // 0
  print('');
  
  // Тест 3: Таблица с несколькими элементами
  var table3 = HashTable<int, String>();
  table3[10] = "десять";
  table3[20] = "двадцать";
  table3[30] = "тридцать";
  
  print('Таблица: $table3');
  var keys3 = table3.keys;
  print('Ключи: $keys3');
  print('Количество ключей: ${keys3.length}'); // 3
}

