import 'set.dart';

/// Класс-наследник с переопределенными операторами равенства
/// 
/// В Dart extension не может переопределить методы Object (== и hashCode),
/// поэтому создаем класс-наследник
class MySetWithEquality<T> extends MySet<T> {
  MySetWithEquality();
  
  MySetWithEquality.from(Iterable<T> iterable) : super.from(iterable);
  
  /// Переопределение оператора равенства
  /// 
  /// Два множества считаются равными, если они содержат
  /// одинаковое количество элементов и все элементы первого
  /// множества содержатся во втором. Порядок добавления не важен.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    if (other is! MySet<T>) {
      return false;
    }
    
    // Если размеры разные, множества не равны
    if (length != other.length) {
      return false;
    }
    
    // Проверяем, что все элементы первого множества есть во втором
    for (var element in this) {
      if (!other.isContains(element)) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Переопределение hashCode для соответствия с operator ==
  /// 
  /// Два равных множества должны иметь одинаковый hashCode
  @override
  int get hashCode {
    // Используем XOR всех хешей элементов для создания хеша множества
    // Порядок не важен благодаря коммутативности XOR
    int hash = 0;
    for (var element in this) {
      hash ^= element.hashCode;
    }
    return hash;
  }
}

void main() {
  final setA = MySetWithEquality<int>();
  setA.add(1);
  setA.add(2);
  
  final setB = MySetWithEquality<int>();
  setB.add(2);
  setB.add(1);
  
  final setC = MySetWithEquality<int>();
  setC.add(1);
  setC.add(3);
  
  print('Set A: $setA');
  print('Set B: $setB');
  print('Set C: $setC');
  
  print('A == B? ${setA == setB}');
  // Ожидаемый результат: true (порядок не важен)
  
  print('A == C? ${setA == setC}');
  // Ожидаемый результат: false
  
  print('HashCode A: ${setA.hashCode}');
  print('HashCode B: ${setB.hashCode}');
  // Хеши должны быть одинаковыми для равных множеств
  
  // Проверка с использованием в Set для демонстрации
  final setOfSets = <MySetWithEquality<int>>{setA, setB, setC};
  print('Количество уникальных множеств в Set: ${setOfSets.length}');
  // setA и setB должны считаться одинаковыми
}

