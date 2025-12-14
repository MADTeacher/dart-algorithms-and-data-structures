import 'hashtable_v.1.dart';

// Расширение HashTable для добавления метода removeAllValues
extension HashTableRemoveAllValues<K, V> on HashTable<K, V> {
  /// Массовое удаление по значению
  /// Удаляет все ключи, у которых значение равно заданному value.
  /// Важно: корректно обрабатывает случаи, когда в одной корзине 
  /// несколько узлов с таким значением подряд.
  /// 
  /// Примечание: Для полной реализации с прямым доступом к внутренней структуре
  /// этот метод должен быть частью класса HashTable, а не расширением.
  /// Здесь используется подход через сбор ключей и их последующее удаление.
  void removeAllValues(V value) {
    // Собираем все ключи, которые нужно удалить
    List<K> keysToRemove = [];
    forEach((key, val) {
      if (val == value) {
        keysToRemove.add(key);
      }
    });
    
    // Удаляем все найденные ключи
    for (var key in keysToRemove) {
      remove(key);
    }
  }
}

void main() {
  // Тест 1: Базовый пример - удаление одного значения
  var table1 = HashTable<String, int>();
  table1["a"] = 5;
  table1["b"] = 10;
  table1["c"] = 5;
  
  print('Таблица до: $table1');
  table1.removeAllValues(5);
  print('Таблица после removeAllValues(5): $table1'); // {"b": 10}
  print('Длина: ${table1.length}'); // 1
  print('');
  
  // Тест 2: Сложный случай - несколько узлов с одинаковым значением подряд
  // Создадим ситуацию с коллизиями (узлы в одной корзине)
  var table2 = HashTable<int, int>();
  // Используем ключи, которые могут попасть в одну корзину
  // Для демонстрации создадим таблицу и добавим элементы
  table2[0] = 5;
  table2[16] = 5; // Может попасть в ту же корзину (если размер 16)
  table2[32] = 5; // Может попасть в ту же корзину
  table2[1] = 9;
  
  print('Таблица до: $table2');
  print('Длина до: ${table2.length}');
  table2.removeAllValues(5);
  print('Таблица после removeAllValues(5): $table2');
  print('Длина после: ${table2.length}'); // Должна быть 1
  print('');
  
  // Тест 3: Удаление всех элементов
  var table3 = HashTable<String, String>();
  table3["a"] = "test";
  table3["b"] = "test";
  table3["c"] = "test";
  
  print('Таблица до: $table3');
  table3.removeAllValues("test");
  print('Таблица после removeAllValues("test"): $table3'); // {}
  print('Длина: ${table3.length}'); // 0
  print('Пустая: ${table3.isEmpty}'); // true
  print('');
  
  // Тест 4: Удаление несуществующего значения
  var table4 = HashTable<int, int>();
  table4[1] = 10;
  table4[2] = 20;
  
  print('Таблица до: $table4');
  table4.removeAllValues(99);
  print('Таблица после removeAllValues(99): $table4'); // Не изменилась
  print('Длина: ${table4.length}'); // 2
  print('');
  
  // Тест 5: Пустая таблица
  var table5 = HashTable<String, int>();
  print('Пустая таблица: $table5');
  table5.removeAllValues(5);
  print('После removeAllValues(5): $table5'); // Осталась пустой
  print('Длина: ${table5.length}'); // 0
}

