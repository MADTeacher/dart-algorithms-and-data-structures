import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода merge
extension HashTableMerge<K, V> on HashTable<K, V> {
  /// Умное слияние (Merge)
  /// Принимает ключ, новое значение и функцию разрешения конфликтов.
  /// Если ключа нет в таблице: просто добавляет пару key: value.
  /// Если ключ есть: вызывает remappingFunction, передав ей текущее значение 
  /// из таблицы и переданное value. Результат функции записывает как новое значение.
  V merge(K key, V value, V Function(V existingValue, V newValue) remappingFunction) {
    if (containsKey(key)) {
      V existingValue = get(key)!;
      V mergedValue = remappingFunction(existingValue, value);
      add(key, mergedValue);
      return mergedValue;
    } else {
      add(key, value);
      return value;
    }
  }
}

void main() {
  // Тест 1: Ключ существует - объединение значений
  var table1 = HashTable<String, int>();
  table1["a"] = 10;
  
  print('Таблица до: $table1');
  var result1 = table1.merge("a", 1, (old, newVal) => old + newVal);
  print('Результат merge: $result1'); // 11
  print('Таблица после: $table1'); // {"a": 11}
  print('');
  
  // Тест 2: Ключ не существует - простое добавление
  print('Таблица до: $table1');
  var result2 = table1.merge("b", 5, (old, newVal) => old + newVal);
  print('Результат merge: $result2'); // 5
  print('Таблица после: $table1'); // {"a": 11, "b": 5}
  print('');
  
  // Тест 3: Подсчет слов (пример использования)
  var wordCount = HashTable<String, int>();
  
  List<String> words = ["apple", "banana", "apple", "cherry", "banana", "apple"];
  
  for (var word in words) {
    wordCount.merge(word, 1, (old, newVal) => old + newVal);
  }
  
  print('Подсчет слов: $wordCount');
  print('Количество "apple": ${wordCount["apple"]}'); // 3
  print('Количество "banana": ${wordCount["banana"]}'); // 2
  print('Количество "cherry": ${wordCount["cherry"]}'); // 1
  print('');
  
  // Тест 4: Конкатенация строк
  var table2 = HashTable<String, String>();
  table2["prefix"] = "Hello";
  
  print('Таблица до: $table2');
  table2.merge("prefix", " World", (old, newVal) => old + newVal);
  print('Таблица после: $table2'); // {"prefix": "Hello World"}
  print('');
  
  // Тест 5: Умножение значений
  var table3 = HashTable<int, int>();
  table3[1] = 5;
  
  print('Таблица до: $table3');
  table3.merge(1, 3, (old, newVal) => old * newVal);
  print('Таблица после: $table3'); // {1: 15}
}

