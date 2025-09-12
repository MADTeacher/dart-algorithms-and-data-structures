import 'collections/set.dart';

// Класс, описывающий ребро в графе с начальной вершиной,
// конечной вершиной и весом
class Edge<T extends Comparable<T>> {
  final T startEdge;
  final T finishEdge;
  final int weight;

  const Edge(this.startEdge, this.finishEdge, [this.weight = 0]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Edge<T> &&
        other.startEdge.compareTo(startEdge) == 0 &&
        other.finishEdge.compareTo(finishEdge) == 0 &&
        other.weight.compareTo(weight) == 0;
  }

  @override
  int get hashCode => Object.hash(startEdge, finishEdge, weight);

  @override
  String toString() => 'Edge($startEdge -> $finishEdge, '
      'weight: $weight)';
}

// Класс, описывающий смежное ребро в графе
class AdjacentEdge<T extends Comparable<T>> {
  final T finishEdge;
  final int weight;

  const AdjacentEdge(this.finishEdge, [this.weight = 0]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdjacentEdge<T> &&
        other.finishEdge.compareTo(finishEdge) == 0 &&
        other.weight.compareTo(weight) == 0;
  }

  @override
  int get hashCode => Object.hash(finishEdge, weight);

  @override
  String toString() => 'AdjacentEdge($finishEdge, weight: $weight)';
}

// Обобщенная реализация графа с
// использованием списка смежности
class Graph<T extends Comparable<T>> {
  final Map<T, GraphSet<AdjacentEdge<T>>> vertexes = {};
  final bool isNotDirected;

  Graph({bool isDirected = false}) : isNotDirected = !isDirected;

  // Добавляем вершину в граф
  void addVertex(T vertex) {
    if (!vertexes.containsKey(vertex)) {
      vertexes[vertex] = GraphSet<AdjacentEdge<T>>();
    }
  }

  // Добавляем ребро между двумя вершинами с указанным весом
  void addEdge(T vertex1, T vertex2, int weight) {
    addVertex(vertex1);
    addVertex(vertex2);

    vertexes[vertex1]!.add(AdjacentEdge<T>(vertex2, weight));
    if (isNotDirected) {
      vertexes[vertex2]!.add(AdjacentEdge<T>(vertex1, weight));
    }
  }

  // Добавляем ребро без веса (вес = 0)
  void addEdgeWithoutWeight(T vertex1, T vertex2) {
    addEdge(vertex1, vertex2, 0);
  }

  // Выполняем функцию для каждой вершины в графе
  void forEachVertex(void Function(T) func) {
    for (final vertex in vertexes.keys) {
      func(vertex);
    }
  }

  // Выполняем функцию для каждого ребра в графе
  void forEachEdge(void Function(Edge<T>) func) {
    for (final entry in vertexes.entries) {
      final vertex1 = entry.key;
      final edges = entry.value;

      edges.forEach((adjacentEdge) {
        func(Edge<T>(vertex1, adjacentEdge.finishEdge, adjacentEdge.weight));
      });
    }
  }

  // Выполняем функцию для каждого смежного ребра вершины
  void forEachAdjacentEdge(T vertex, void Function(AdjacentEdge<T>) func) {
    if (vertexes.containsKey(vertex)) {
      final edges = vertexes[vertex]!;
      edges.forEach(func);
    }
  }

  // Возвращаем количество ребер в графе
  int amountEdges() {
    int count = 0;
    for (final edges in vertexes.values) {
      count += edges.size();
    }

    if (isNotDirected) {
      count ~/= 2;
    }

    return count;
  }

  // Возвращаем количество вершин в графе
  int amountVertexes() => vertexes.length;

  // Выводим в терминал все ребра графа
  void printAllEdges() {
    forEachEdge((edge) {
      print('Edge(V1: ${edge.startEdge}, V2: ${edge.finishEdge},'
          ' Weight: ${edge.weight})');
    });
  }

  // Выводим в терминал все вершины графа
  void printAllVertexes() {
    forEachVertex((vertex) {
      print('Vertex: $vertex');
    });
  }
}

// Пример класса City для демонстрации работы с графом
class City implements Comparable<City> {
  final String name;
  final int id;

  const City(this.name, this.id);

  @override
  String toString() => 'City($name,$id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City && other.name == name && other.id == id;
  }

  @override
  int get hashCode => Object.hash(name, id);

  @override
  int compareTo(City other) {
    return id.compareTo(other.id);
  }
}

void main() {
  final cityList = [
    const City("Saint Petersburg", 2),
    const City("Moscow", 1),
    const City("Pskov", 3),
    const City("Rostov-on-Don", 4),
    const City("Stavropol", 5),
    const City("Grozny", 7),
    const City("Gukovo", 6),
    const City("Kalach-na-Donu", 14),
    const City("Kansk", 13),
    const City("Mamonovo", 91),
    const City("Nizhnekamsk", 8),
    const City("Omsk", 9),
    const City("Oryol", 20),
  ];

  final graph = Graph<City>();

  for (final city in cityList) {
    graph.addVertex(city);
  }

  graph.addEdge(cityList[0], cityList[3], 1960);
  graph.addEdge(cityList[0], cityList[1], 1500);
  graph.addEdge(cityList[1], cityList[3], 460);
  graph.addEdge(cityList[3], cityList[6], 100);

  print(cityList.length == graph.amountVertexes());
  print("---------Вершины-----------");
  graph.printAllVertexes();
  print("---------Ребра-----------");
  graph.printAllEdges();
}
