import 'hashtable.dart';

void main() {
  // HashTable создается с начальной емкостью умолчанию = 16
  // Порог для расширения: 16 * 0.75 = 12 элементов
  var hashtable = HashTable<int, String>();
  print('Количество занятых ячеек: ${hashtable.length}');

  print('\nДобавляем 12 элементов...');
  for (int i = 0; i < 12; i++) {
    hashtable[i] = 'Value $i';
  }

  print('Количество занятых ячеек: ${hashtable.length}');
  print(hashtable);
  print('');

  // Добавляем 13-й элемент, что должно
  // вызвать расширение хеш-таблицы
  hashtable[12] = 'Value 12';

  print('\nКоличество занятых ячеек: ${hashtable.length}');
  print(hashtable);
}
