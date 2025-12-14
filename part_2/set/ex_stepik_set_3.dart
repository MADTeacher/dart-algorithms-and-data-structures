import 'set.dart';

/// Расширение для реализации переключателя (Toggle)
extension MySetToggle<T> on MySet<T> {
  /// Переключает состояние элемента в множестве
  /// 
  /// Если element уже есть в множестве — удаляет его.
  /// Если element нет — добавляет его.
  void toggle(T element) {
    if (isContains(element)) {
      remove(element);
    } else {
      add(element);
    }
  }
}

void main() {
  final mySet = MySet<int>();
  mySet.add(1);
  mySet.add(2);
  
  print('Начальное множество: $mySet');
  // {1, 2}
  
  // Переключаем элемент, который уже есть
  mySet.toggle(2);
  print('После toggle(2): $mySet');
  // Ожидаемый результат: {1}
  
  // Переключаем элемент, которого нет
  mySet.toggle(5);
  print('После toggle(5): $mySet');
  // Ожидаемый результат: {1, 5}
  
  // Переключаем снова
  mySet.toggle(5);
  print('После toggle(5) снова: $mySet');
  // Ожидаемый результат: {1}
}



