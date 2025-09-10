import 'binarysearchtree.dart';

void main() {
  var tree = BinarySearchTree<int, String>();
  print('Высота пустого дерева: ${tree.height}');

  tree[10] = 'root';
  print('Высота дерева с одним узлом: ${tree.height}');

  // Формируем сбалансированное дерево
  tree.clear();
  tree[10] = 'a';
  tree[5] = 'b';
  tree[15] = 'c';
  tree[3] = 'd';
  tree[7] = 'e';
  tree[12] = 'f';
  tree[18] = 'g';

  print('Высота сбалансированного дерева: ${tree.height}');

  // Формируем небалансированное дерево (левосторонний список)
  tree.clear();
  for (int i = 10; i >= 1; i--) {
    tree[i] = 'node$i';
  }

  print('Высота небалансированного дерева (левосторонний): ${tree.height}');

  // Формируем небалансированное дерево (правосторонний список)
  tree.clear();
  for (int i = 1; i <= 8; i++) {
    tree[i] = 'node$i';
  }

  print('Высота небалансированного дерева (правосторонний): ${tree.height}');
}
