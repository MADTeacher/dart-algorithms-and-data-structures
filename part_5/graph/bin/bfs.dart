import 'dart:io';

import 'package:graph/collections.dart';
import 'package:graph/graph.dart';

// Алгоритм поиска в ширину
// graph - граф для поиска
// start - начальная вершина
// walkFunc - функция, вызываемая для каждой посещенной вершины.
// Чтобы остановить поиск, функция должна вернуть true
void bfs<T extends Comparable<T>>(
    Graph<T> graph, T start, bool Function(T) walkFunc) {
  final queue = Queue<T>();
  final visited = GraphSet<T>();
  queue.enqueue(start);

  void foreachEdge(AdjacentEdge<T> edge) {
    if (!visited.contains(edge.finishEdge)) {
      queue.enqueue(edge.finishEdge);
    }
  }

  while (!queue.isEmpty()) {
    final vertex = queue.dequeue();

    if (walkFunc(vertex)) {
      return;
    }

    visited.add(vertex);
    graph.forEachAdjacentEdge(vertex, foreachEdge);
  }
}

void main() {
  final vertexes = [
    const Edge("A", "B"),
    const Edge("A", "C"),
    const Edge("C", "F"),
    const Edge("C", "G"),
    const Edge("G", "M"),
    const Edge("G", "N"),
    const Edge("B", "D"),
    const Edge("B", "E"),
    const Edge("D", "H"),
    const Edge("D", "I"),
    const Edge("D", "J"),
    const Edge("E", "K"),
    const Edge("E", "L"),
  ];

  final graph = Graph<String>();

  for (final edge in vertexes) {
    graph.addEdgeWithoutWeight(edge.startEdge, edge.finishEdge);
  }

  bool bfsWalk(String vertex) {
    stdout.write('$vertex ');
    return vertex == "K";
  }

  bfs(graph, "A", bfsWalk);
  print('');

  // ----------------Путь---------------------
  final path = <String>[];

  bool bfsWalkWithPath(String vertex) {
    path.add(vertex);
    return vertex == "K";
  }

  bfs(graph, "A", bfsWalkWithPath);

  path.reversed.toList();
  final minPath = ["K"];
  String find = "K";

  for (final vertex in path.reversed) {
    if (graph.vertexes[vertex]!.contains(AdjacentEdge<String>(find))) {
      minPath.add(vertex);
      find = vertex;
    }
  }

  print(minPath.reversed.toList());
}
