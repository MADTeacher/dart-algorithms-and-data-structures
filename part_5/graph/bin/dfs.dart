import 'dart:io';

import 'package:graph/collections.dart';
import 'package:graph/graph.dart';

bool _isFound = false;

// Алгоритм поиска в глубину
// graph - граф для поиска
// start - начальная вершина
// walkFunc - функция, вызываемая для каждой посещенной вершины.
// Чтобы остановить поиск, функция должна вернуть true
void dfs<T extends Comparable<T>>(
    Graph<T> graph, T start, bool Function(T) walkFunc) {
  final visited = GraphSet<T>();
  _isFound = false;
  _dfsRecursive(graph, start, visited, walkFunc);
}

void _dfsRecursive<T extends Comparable<T>>(
    Graph<T> graph, T start, GraphSet<T> visited, bool Function(T) walkFunc) {
  visited.add(start);

  _isFound = walkFunc(start);
  if (_isFound) {
    return;
  }

  void foreachEdge(AdjacentEdge<T> edge) {
    if (_isFound) {
      return;
    }
    if (!visited.contains(edge.finishEdge)) {
      _dfsRecursive(graph, edge.finishEdge, visited, walkFunc);
    }
  }

  graph.forEachAdjacentEdge(start, foreachEdge);
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

  bool dfsWalk(String vertex) {
    stdout.write('$vertex ');
    return vertex == "K";
  }

  dfs(graph, "A", dfsWalk);
  print('');

  // ----------------Путь---------------------
  final path = <String>[];

  bool dfsWalkWithPath(String vertex) {
    path.add(vertex);
    return vertex == "K";
  }

  dfs(graph, "A", dfsWalkWithPath);

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
