import 'stack_array.dart';

// Временная сложность: O(n)
// Память: O(n)
int calculate(String s) {
  final stack = StackArray<int>();
  int result = 0;
  int number = 0;
  int sign = 1; // 1 для '+', -1 для '-'

  for (int i = 0; i < s.length; i++) {
    final char = s[i];

    if (char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
      // Строим число из цифр
      number = number * 10 + (char.codeUnitAt(0) - '0'.codeUnitAt(0));
    } else if (char == '+') {
      // Добавляем предыдущее число к результату
      result += sign * number;
      number = 0;
      sign = 1;
    } else if (char == '-') {
      // Добавляем предыдущее число к результату
      result += sign * number;
      number = 0;
      sign = -1;
    } else if (char == '(') {
      // Сохраняем текущий результат и знак в стек
      stack.push(result);
      stack.push(sign);
      // Сбрасываем для нового подвыражения
      result = 0;
      sign = 1;
    } else if (char == ')') {
      // Завершаем текущее подвыражение
      result += sign * number;
      number = 0;

      // Восстанавливаем предыдущий знак и результат
      result *= stack.pop(); // предыдущий знак
      result += stack.pop(); // предыдущий результат
    }
    // Игнорируем пробелы
  }

  // Добавляем последнее число
  result += sign * number;

  return result;
}

void main() {
  print(calculate("1 + 1")); // 2
  print(calculate(" 2-1 + 2 ")); // 3
  print(calculate("(1+(4+5+2)-3)+(6+8)")); // 23
}
