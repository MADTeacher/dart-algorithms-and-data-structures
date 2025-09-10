import 'queue_array.dart';

// Класс для представления человека в очереди
class Person {
  int originalIndex; // Изначальный номер в очереди
  int ticketsNeeded; // Количество билетов, которые нужно купить

  Person(this.originalIndex, this.ticketsNeeded);

  @override
  String toString() => 'Person($originalIndex, $ticketsNeeded)';
}

// Функция для вычисления времени, необходимого k-му человеку
// для покупки всех билетов
// Временная сложность: O(n)
// Память: O(n)
int timeRequiredToBuy(List<int> tickets, int k) {
  var queue = ArrayQueue<Person>();

  // Заполняем очередь людьми
  for (int i = 0; i < tickets.length; i++) {
    queue.enqueue(Person(i, tickets[i]));
  }

  int time = 0;

  // Симулируем процесс покупки билетов
  while (!queue.isEmpty) {
    var currentPerson = queue.dequeue();
    time++; // Тратим 1 секунду на покупку билета

    currentPerson.ticketsNeeded--;

    // Если это искомый k-й человек и он купил все билеты
    if (currentPerson.originalIndex == k && currentPerson.ticketsNeeded == 0) {
      return time;
    }

    // Если человек еще нуждается в билетах,
    // ставим его в конец очереди
    if (currentPerson.ticketsNeeded > 0) {
      queue.enqueue(currentPerson);
    }
  }

  return time;
}

void main() {
  var k = 2;
  int result = timeRequiredToBuy([2, 3, 5, 5, 2, 1], k);
  print('tickets = [2,3,5,5,2,1], k = $k');
  print('Время для $k-го человека: $result секунд\n');
}
