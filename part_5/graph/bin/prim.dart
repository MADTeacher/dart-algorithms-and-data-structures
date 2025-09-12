import 'package:graph/collections.dart';
import 'package:graph/graph.dart';

// Узел, используемый в алгоритме Прима
class _PrimNode<T> implements IKey {
  final T start;
  final T finish;
  final int weight;

  const _PrimNode(this.start, this.finish, this.weight);

  @override
  int key() => weight;

  @override
  String name() => start.toString();
}

// Алгоритм Прима для нахождения минимального остовного дерева
// Возвращает новый граф, представляющий минимальное остовное дерево
Graph<T> prim<T extends Comparable<T>>(Graph<T> graph, T start) {
  final mySet = GraphSet<T>();
  final mst = Graph<T>();

  mySet.add(start);

  while (mySet.size() != graph.amountVertexes()) {
    final heap = Heap<_PrimNode<T>>(graph.amountEdges());

    void foreachVertex(T vertex) {
      void edgesForeach(AdjacentEdge<T> edge) {
        if (mySet.contains(edge.finishEdge)) {
          return;
        }
        heap.insert(_PrimNode(vertex, edge.finishEdge, edge.weight));
      }

      graph.forEachAdjacentEdge(vertex, edgesForeach);
    }

    mySet.forEach(foreachVertex);

    while (!heap.isEmpty()) {
      final edge = heap.remove();
      mst.addEdge(edge.start, edge.finish, edge.weight);
      mySet.add(edge.finish);
      break;
    }
  }

  return mst;
}

void main() {
  final vertexes = [
    const Edge("A", "B", 13),
    const Edge("A", "C", 6),
    const Edge("A", "F", 4),
    const Edge("B", "C", 7),
    const Edge("B", "F", 7),
    const Edge("B", "E", 5),
    const Edge("C", "E", 1),
    const Edge("C", "F", 8),
    const Edge("E", "F", 9),
  ];

  final graph = Graph<String>();

  for (final edge in vertexes) {
    graph.addEdge(edge.startEdge, edge.finishEdge, edge.weight);
  }

  final mst = prim(graph, "C");
  print(mst.amountVertexes() == graph.amountVertexes());
  print("---------Вершины-----------");
  mst.printAllVertexes();
  print("---------Ребра-----------");
  mst.printAllEdges();
}
