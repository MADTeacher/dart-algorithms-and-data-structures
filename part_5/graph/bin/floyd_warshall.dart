import 'package:graph/graph.dart';

// Алгоритм Флойда-Уоршелла для нахождения кратчайших путей
// между всеми парами вершин. Возвращает матрицу стоимостей,
// где costMatrix[u][v] представляет кратчайшее расстояние от u до v
Map<T, Map<T, int>> floydWarshall<T extends Comparable<T>>(Graph<T> graph) {
  final costMatrix = <T, Map<T, int>>{};

  // Инициализация матрицы стоимостей с весами прямых ребер
  void vertexInit(T vertex) {
    costMatrix[vertex] = <T, int>{};

    void edgeInit(AdjacentEdge<T> edge) {
      costMatrix[vertex]![edge.finishEdge] = edge.weight;
    }

    graph.forEachAdjacentEdge(vertex, edgeInit);
  }

  graph.forEachVertex(vertexInit);

  // Основной алгоритм Флойда-Уоршелла
  for (final k in graph.vertexes.keys) {
    for (final u in graph.vertexes.keys) {
      for (final v in graph.vertexes.keys) {
        bool ok = false, ok1 = false, ok2 = false;

        // Проверяем, существует ли путь u -> k
        if (costMatrix.containsKey(u) && costMatrix[u]!.containsKey(k)) {
          ok1 = true;
        }

        // Проверяем, существует ли путь k -> v
        if (costMatrix.containsKey(k) && costMatrix[k]!.containsKey(v)) {
          ok2 = true;
        }

        if (!ok1 || !ok2) {
          continue;
        }

        int oldCost = 0;
        // Проверяем, существует ли прямой путь u -> v
        if (costMatrix.containsKey(u) && costMatrix[u]!.containsKey(v)) {
          oldCost = costMatrix[u]![v]!;
          ok = true;
        }

        final newCost = costMatrix[u]![k]! + costMatrix[k]![v]!;

        if (ok) {
          if (newCost < oldCost) {
            costMatrix[u]![v] = newCost;
          }
        } else {
          costMatrix[u]![v] = newCost;
        }
      }
    }
  }

  return costMatrix;
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

  final costMatrix = floydWarshall(graph);
  for (final entry in costMatrix.entries) {
    print('Key: ${entry.key}, Val: ${entry.value}');
  }
}
