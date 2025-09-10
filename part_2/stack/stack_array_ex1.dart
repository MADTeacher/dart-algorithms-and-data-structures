import 'stack_array.dart';

void main() {
  // Временная сложность: O(n)
  // Память: O(n)
  final strList = ['(ads)as(dd)', '(ad(s)as(dd)', ''];

  for (final str in strList) {
    var stack = StackArray<String>();
    print('Строка: $str');

    bool isBalanced = true;

    // Используем runes для итерации по символам строки
    for (final rune in str.runes) {
      final char = String.fromCharCode(rune);
      if (char == '(') {
        stack.push(char); // Добавляем открывающую скобку в стек
      } else if (char == ')') {
        if (stack.isEmpty) {
          isBalanced = false;
          break;
        }
        try {
          stack.pop(); // Удаляем открывающую скобку из стека
        } on StateError {
          // Если возникает ошибка при извлечении, то
          // скобки несбалансированы
          isBalanced = false;
          break;
        }
      }
    }

    // Проверяем, сбалансированы ли скобки
    isBalanced = isBalanced && stack.isEmpty;
    print('Скобки сбалансированы: $isBalanced');
    print('');
  }
}
