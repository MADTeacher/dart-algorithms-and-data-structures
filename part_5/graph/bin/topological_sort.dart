import 'package:graph/graph.dart';

// Алгоритм топологической сортировки
// Возвращаем кортеж (sortedList, levelMap, isSuccessful),
// где sortedList содержит вершины в топологическом порядке,
// levelMap сопоставляет каждой вершине ее уровень,
// а isSuccessful указывает на то, была ли сортировка возможна
(List<T>, Map<T, int>, bool) topologicalSort<T extends Comparable<T>>(
    Graph<T> graph) {
  final inDegree = <T, int>{};

  void decDegree(AdjacentEdge<T> edge) {
    inDegree[edge.finishEdge] = inDegree[edge.finishEdge]! - 1;
  }

  void foreachEdge(Edge<T> edge) {
    if (!inDegree.containsKey(edge.startEdge)) {
      inDegree[edge.startEdge] = 0;
    }

    if (inDegree.containsKey(edge.finishEdge)) {
      inDegree[edge.finishEdge] = inDegree[edge.finishEdge]! + 1;
    } else {
      inDegree[edge.finishEdge] = 1;
    }
  }

  graph.forEachEdge(foreachEdge);

  final resultList = <T>[];
  final resultDict = <T, int>{};
  int countLevel = 0;

  while (inDegree.isNotEmpty) {
    final tempList = <T>[];

    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        tempList.add(entry.key);
        resultDict[entry.key] = countLevel;
      }
    }

    if (tempList.isEmpty) {
      return (<T>[], <T, int>{}, false);
    }

    for (final vertex in tempList) {
      graph.forEachAdjacentEdge(vertex, decDegree);
      inDegree.remove(vertex);
      resultList.add(vertex);
    }

    countLevel++;
  }

  return (resultList, resultDict, true);
}

void main() {
  final graph = Graph<String>(isDirected: true);

  graph.addEdgeWithoutWeight("A", "B");
  graph.addEdgeWithoutWeight("A", "D");
  graph.addEdgeWithoutWeight("B", "C");
  graph.addEdgeWithoutWeight("B", "D");
  graph.addEdgeWithoutWeight("C", "E");
  graph.addEdgeWithoutWeight("D", "E");
  graph.addEdgeWithoutWeight("D", "F");
  graph.addEdgeWithoutWeight("E", "F");

  final (topList, topDict, ok) = topologicalSort(graph);
  print(topList);
  print(topDict);
  print('Топологическая сортировка прошла успешно: $ok');
}
