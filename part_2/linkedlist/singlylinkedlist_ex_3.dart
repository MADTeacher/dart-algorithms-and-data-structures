import 'singlylinkedlist.dart';

// Итеративный алгоритм слияния двух отсортированных списков
// Временная сложность: O(m + n), где m и n - длины списков
// Память: O(m + n) 
SinglyLinkedList<T> mergeSortedLists<T extends Comparable<dynamic>>(
    SinglyLinkedList<T> list1, SinglyLinkedList<T> list2) {
  
  // Создаем новый список для результата
  var mergedList = SinglyLinkedList<T>();
  
  // Получаем итераторы для обоих списков
  var iter1 = list1.iterator;
  var iter2 = list2.iterator;
  
  // Проверяем, есть ли элементы в списках
  bool hasNext1 = iter1.moveNext();
  bool hasNext2 = iter2.moveNext();
  
  // Сливаем списки, сравнивая элементы
  while (hasNext1 && hasNext2) {
    if (iter1.current.compareTo(iter2.current) <= 0) {
      // Элемент из первого списка меньше или равен
      mergedList.push(iter1.current);
      hasNext1 = iter1.moveNext();
    } else {
      // Элемент из второго списка меньше
      mergedList.push(iter2.current);
      hasNext2 = iter2.moveNext();
    }
  }
  
  // Добавляем оставшиеся элементы из первого списка
  while (hasNext1) {
    mergedList.push(iter1.current);
    hasNext1 = iter1.moveNext();
  }
  
  // Добавляем оставшиеся элементы из второго списка
  while (hasNext2) {
    mergedList.push(iter2.current);
    hasNext2 = iter2.moveNext();
  }
  
  return mergedList;
}

// Рекурсивный алгоритм слияния двух отсортированных списков
// Временная сложность: O(m + n), где m и n - длины списков
// Память: O(m + n) + O(m + n) для стека рекурсии
SinglyLinkedList<T> mergeSortedListsRecursive<T extends Comparable<dynamic>>(
    SinglyLinkedList<T> list1, SinglyLinkedList<T> list2) {
  
  // Создаем новый список для результата
  var mergedList = SinglyLinkedList<T>();
  
  // Конвертируем списки в обычные массивы для рекурсивной обработки
  List<T> array1 = list1.toList();
  List<T> array2 = list2.toList();
  
  // Вызываем рекурсивную функцию слияния
  List<T> mergedArray = _mergeRecursive(array1, array2);
  
  // Создаем результирующий список из mergedArray
  for (T element in mergedArray) {
    mergedList.push(element);
  }
  
  return mergedList;
}

// Рекурсивная функция слияния двух отсортированных массивов
List<T> _mergeRecursive<T extends Comparable<dynamic>>(List<T> list1, List<T> list2) {
  // Выход из рекурсии
  if (list1.isEmpty) return List.from(list2);
  if (list2.isEmpty) return List.from(list1);
  
  // Сравниваем первые элементы списков
  if (list1[0].compareTo(list2[0]) <= 0) {
    // Первый элемент из list1 меньше или равен
    // Добавляем его к результату и рекурсивно сливаем остальные
    return [list1[0]] + _mergeRecursive(list1.sublist(1), list2);
  } else {
    // Первый элемент из list2 меньше
    // Добавляем его к результату и рекурсивно сливаем остальные
    return [list2[0]] + _mergeRecursive(list1, list2.sublist(1));
  }
}

void main() {
  var list1 = SinglyLinkedList.from([1, 5, 7]);
  var list2 = SinglyLinkedList.from([2, 4, 6, 8]);
  
  print('Первый отсортированный список: $list1');
  print('Второй отсортированный список: $list2');
  
  var mergedList = mergeSortedLists(list1, list2);
  print('Результат слияния (итеративный): $mergedList');
  
  var recursiveResult = mergeSortedListsRecursive(list1, list2);
  print('Результат слияния (рекурсивный): $recursiveResult');
}
