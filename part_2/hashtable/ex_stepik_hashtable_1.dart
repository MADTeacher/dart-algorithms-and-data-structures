import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода containsValue
extension HashTableContainsValue<K, V> on HashTable<K, V> {
  /// Поиск по значению
  /// Возвращает true, если указанное значение value встречается 
  /// хотя бы в одной паре в таблице, и false в противном случае.
  /// Сложность: O(n), где n - количество элементов в таблице
  bool containsValue(V value) {
    // Используем forEach для обхода всех элементов
    // Прерываем поиск при первом найденном значении
    try {
      forEach((key, val) {
        if (val == value) {
          throw _FoundException(); // Используем исключение для раннего выхода
        }
      });
      return false;
    } on _FoundException {
      return true;
    }
  }
}

// Вспомогательный класс для раннего выхода из forEach
class _FoundException implements Exception {}

void main() {
  // Тест 1: Значение найдено
  var table1 = HashTable<int, String>();
  table1[1] = "Banana";
  table1[2] = "Apple";
  
  print('Таблица: $table1');
  print('containsValue("Apple"): ${table1.containsValue("Apple")}'); // true
  print('containsValue("Cherry"): ${table1.containsValue("Cherry")}'); // false
  print('');
  
  // Тест 2: Пустая таблица
  var table2 = HashTable<String, int>();
  print('Пустая таблица: $table2');
  print('containsValue(5): ${table2.containsValue(5)}'); // false
  print('');
  
  // Тест 3: Несколько одинаковых значений
  var table3 = HashTable<int, String>();
  table3[1] = "Apple";
  table3[2] = "Banana";
  table3[3] = "Apple";
  
  print('Таблица с дубликатами: $table3');
  print('containsValue("Apple"): ${table3.containsValue("Apple")}'); // true
  print('containsValue("Cherry"): ${table3.containsValue("Cherry")}'); // false
}

