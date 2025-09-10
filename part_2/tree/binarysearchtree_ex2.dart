import 'binarysearchtree.dart';


void main() {
  var tree = BinarySearchTree<int, String>();
  tree[20] = 'root';
  tree[10] = 'left';
  tree[30] = 'right';
  tree[5] = 'left-left';
  tree[15] = 'left-right';
  tree[25] = 'right-left';
  tree[35] = 'right-right';
  tree[3] = 'left-left-left';
  tree[7] = 'left-left-right';
  tree[12] = 'left-right-left';
  tree[18] = 'left-right-right';
  
  print('Структура дерева:');
  print(tree);
  
  // Поиск LCA для узлов в разных поддеревьях
  print('LCA(5, 15) = ${tree.lowestCommonAncestor(5, 15)}');
  print('LCA(3, 18) = ${tree.lowestCommonAncestor(3, 18)}');
  print('LCA(25, 35) = ${tree.lowestCommonAncestor(25, 35)}');
  print('LCA(10, 30) = ${tree.lowestCommonAncestor(10, 30)}');
  
  // Поиск LCA, когда один узел является предком другого
  print('LCA(10, 5) = ${tree.lowestCommonAncestor(10, 5)}');
  
  // Поиск LCA для одинаковых узлов
  print('LCA(15, 15) = ${tree.lowestCommonAncestor(15, 15)}');
  
  // Поиск LCA узлов в одном поддереве
  print('LCA(3, 7) = ${tree.lowestCommonAncestor(3, 7)}');
  
  // Поиск LCA с несуществующими узлами
  print('LCA(100, 5) = ${tree.lowestCommonAncestor(100, 5)}');
}
