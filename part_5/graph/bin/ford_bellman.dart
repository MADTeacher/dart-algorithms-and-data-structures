import 'package:graph/graph.dart';

// Узел, используемый в алгоритме Форда-Беллмана
class _Node<T> {
  int cost;
  T? predecessor;

  _Node(this.cost, [this.predecessor]);
}

// Алгоритм Форда-Беллмана для нахождения кратчайшего пути с
// обнаружением ребер с отрицательным весом
// Возвращает кортеж (путь, стоимость), где путь - это кратчайший
// путь от начала до конца. Если обнаружен отрицательный цикл, то
// возвращаем пустой список
(List<T>, int) fordBellman<T extends Comparable<T>>(
    Graph<T> graph, T start, T end) {
  final nodes = <T, _Node<T>>{};

  // Инициализируем все узлы с бесконечной стоимостью
  graph.forEachVertex((vertex) {
    nodes[vertex] = _Node<T>(999999999);
  });

  nodes[start]!.cost = 0;

  final amountVertex = graph.amountVertexes();

  void calc(Edge<T> edge) {
    final cost = nodes[edge.startEdge]!.cost + edge.weight;
    if (cost < nodes[edge.finishEdge]!.cost) {
      nodes[edge.finishEdge]!.cost = cost;
      nodes[edge.finishEdge]!.predecessor = edge.startEdge;
    }
  }

  for (int i = 0; i < amountVertex - 1; i++) {
    graph.forEachEdge(calc);
  }

  // Проверка на наличие отрицательных циклов
  bool hasNegativeLoop = false;

  void negativeSearch(Edge<T> edge) {
    if (nodes[edge.startEdge]!.cost + edge.weight <
        nodes[edge.finishEdge]!.cost) {
      hasNegativeLoop = true;
    }
  }

  graph.forEachEdge(negativeSearch);

  if (hasNegativeLoop) {
    return (<T>[], 0);
  }

  // Восстановление пути
  T? vertex = end;
  final path = <T>[];

  while (vertex != null) {
    path.add(vertex);
    vertex = nodes[vertex]!.predecessor;
  }

  return (path.reversed.toList(), nodes[end]!.cost);
}

void main() {
  final vertexes = [
    const Edge("A", "B", -3),
    const Edge("B", "A", 4),
    const Edge("B", "C", 5),
    const Edge("B", "F", 7),
    const Edge("C", "E", 1),
    const Edge("C", "A", 6),
    const Edge("E", "B", 5),
    const Edge("E", "F", 6),
    const Edge("F", "A", -4),
    const Edge("F", "C", 8),
  ];

  final graph = Graph<String>(isDirected: true);

  for (final edge in vertexes) {
    graph.addEdge(edge.startEdge, edge.finishEdge, edge.weight);
  }

  var (path, cost) = fordBellman(graph, "E", "C");
  print('Path: $path with cost: $cost');

  (path, cost) = fordBellman(graph, "E", "A");
  print('Path: $path with cost: $cost');

  (path, cost) = fordBellman(graph, "A", "E");
  print('Path: $path with cost: $cost');
}
