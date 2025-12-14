import 'set.dart';

/// Расширение для реализации декартова произведения
extension MySetCartesianProduct<T> on MySet<T> {
  /// Декартово произведение двух множеств
  /// 
  /// Возвращает новое множество, состоящее из списков (пар).
  /// Для каждого элемента a из this и каждого элемента b из other
  /// создается список [a, b].
  /// 
  /// [E] - тип элементов второго множества
  MySet<List<dynamic>> cartesianProduct<E>(MySet<E> other) {
    final result = MySet<List<dynamic>>();
    
    // Для каждого элемента из текущего множества
    for (var elementA in this) {
      // Для каждого элемента из другого множества
      for (var elementB in other) {
        // Создаем пару [a, b]
        result.add([elementA, elementB]);
      }
    }
    
    return result;
  }
}

void main() {
  final setA = MySet<int>();
  setA.add(1);
  setA.add(2);
  
  final setB = MySet<String>();
  setB.add('x');
  setB.add('y');
  
  print('Set A (int): $setA');
  print('Set B (String): $setB');
  
  final product = setA.cartesianProduct(setB);
  print('Декартово произведение: $product');
  // Ожидаемый результат: {[1, 'x'], [1, 'y'], [2, 'x'], [2, 'y']}
  // (порядок пар внутри сета не важен)
  
  // Дополнительный пример с числами
  final setC = MySet<int>();
  setC.add(10);
  setC.add(20);
  
  final setD = MySet<int>();
  setD.add(100);
  setD.add(200);
  
  final product2 = setC.cartesianProduct(setD);
  print('\nSet C: $setC');
  print('Set D: $setD');
  print('Декартово произведение C x D: $product2');
}



