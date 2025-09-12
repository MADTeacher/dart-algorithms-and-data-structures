import 'package:graph/collections.dart';
import 'package:graph/graph.dart';

// Узел, используемый в алгоритме Дейкстры
class _DijkstraNode<T> implements IKey {
  T vertex;
  int distance;
  _DijkstraNode<T>? predecessor;

  _DijkstraNode(this.vertex, this.distance, [this.predecessor]);

  @override
  int key() => distance;

  @override
  String name() => vertex.toString();
}

// Алгоритм Дейкстры для поиска кратчайшего пути
// Возвращаем кортеж (путь, стоимость), где путь - это
// кратчайший путь от начала до конца
// а стоимость - это общее расстояние
(List<T>, int) dijkstra<T extends Comparable<T>>(
    Graph<T> graph, T start, T end) {
  final heap = Heap<_DijkstraNode<T>>(graph.amountVertexes(), true);
  final nodes = <T, _DijkstraNode<T>>{};

  // Инициализируем все узлы с бесконечным расстоянием
  graph.forEachVertex((vertex) {
    final node = _DijkstraNode<T>(vertex, 999999999);
    heap.insert(node);
    nodes[vertex] = node;
  });

  // Устанавливаем расстояние до начальной вершины равным 0
  nodes[start]!.distance = 0;
  heap.change(nodes[start]!);

  // Основной цикл алгоритма
  while (!heap.isEmpty()) {
    final v = heap.remove();

    void calc(AdjacentEdge<T> edge) {
      final node = nodes[edge.finishEdge];
      if (node == null) return;

      if (v.distance + edge.weight < node.distance) {
        node.distance = v.distance + edge.weight;
        node.predecessor = v;
        heap.change(node);
      }
    }

    graph.forEachAdjacentEdge(v.vertex, calc);

    if (v.vertex == end) {
      final path = <T>[];
      final cost = v.distance;
      _DijkstraNode<T>? it = v;

      while (it != null) {
        path.add(it.vertex);
        it = it.predecessor;
      }

      return (path, cost);
    }
  }

  return (<T>[], 0);
}

void main() {
  final vertexes = [
    const Edge("A", "B", 8),
    const Edge("A", "C", 5),
    const Edge("B", "D", 1),
    const Edge("B", "E", 13),
    const Edge("C", "F", 14),
    const Edge("C", "D", 10),
    const Edge("F", "D", 9),
    const Edge("F", "E", 6),
    const Edge("D", "E", 8),
  ];

  final graph = Graph<String>();

  for (final edge in vertexes) {
    graph.addEdge(edge.startEdge, edge.finishEdge, edge.weight);
  }

  final (path, cost) = dijkstra(graph, "E", "A");
  print('Path: $path with cost: $cost');
}
