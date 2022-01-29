import 'package:pathfinder_visualization_flutter/model/node.dart';
import 'package:pathfinder_visualization_flutter/utils.dart';

// Performs Dijkstra's algorithm;
List<Node> dijkstra({
  required List<List<Node>> grid,
  required Node startNode,
  required Node finishNode,
}) {
  List<Node> visitedNodesInOrder = [];

  startNode.distance = 0;
  List<Node> unvisitedNodes = getAllNodes(grid);
  unvisitedNodes.sort((a, b) => a.distance - b.distance);
  while (unvisitedNodes.isNotEmpty) {
    // sort unvisited distance
    unvisitedNodes.sort((a, b) => a.distance - b.distance);
    // iterate through all nodes once
    // means after get then delete from list
    // at first closest node should be [startMode]
    Node closestNode = unvisitedNodes[0];
    unvisitedNodes.removeAt(0);

    // will handle Latter
    // If we encounter a wall, we skip it.
    if (closestNode.isWall) continue;
    // If the closest node is at a distance of infinity,
    // we must be trapped and should therefore stop.
    if (closestNode.distance == Utils.maxValue) return visitedNodesInOrder;

    closestNode.isVisited = true; //visited node
    visitedNodesInOrder.add(closestNode);
    if (closestNode == finishNode) {
      return visitedNodesInOrder; // closest node found the finish node
    }
    updateUnvisitedNeighbors(closestNode, grid);
  }
  return visitedNodesInOrder;
}

void updateUnvisitedNeighbors(Node closestNode, List<List<Node>> grid) {
  var unvisitedNeighbors = getUnvisitedNeighbors(closestNode, grid);
  for (var neighbor in unvisitedNeighbors) {
    neighbor.distance = closestNode.distance + 1;
    neighbor.previousNode = closestNode;
  }
}

List<Node> getUnvisitedNeighbors(Node closestNode, List<List<Node>> grid) {
  int currentCol = closestNode.col;
  int currentRow = closestNode.row;
  List<Node> neighbours = [];

  /// if any, add neighbors that is above current node
  if (currentCol > 0) {
    neighbours.add(grid[currentCol - 1][currentRow]);
  }

  /// if any, add neighbors that is below current node
  if (currentCol < grid.length - 1) {
    neighbours.add(grid[currentCol + 1][currentRow]);
  }

  /// if any, add neighbors that that is to the left of the current node
  if (currentRow > 0) {
    neighbours.add(grid[currentCol][currentRow - 1]);
  }

  /// if any, add neighbours that that is to the right of current node
  /// why grid[0].length? becouse is has same length for every row
  if (currentRow < grid[0].length - 1) {
    neighbours.add(grid[currentCol][currentRow + 1]);
  }

  return neighbours.where((neighbour) => !neighbour.isVisited).toList();
}

List<Node> getAllNodes(List<List<Node>> grid) {
  List<Node> nodes = [];
  for (var row in grid) {
    for (var node in row) {
      nodes.add(node);
    }
  }
  return nodes;
}

/// only work after [dijkstra] called,
/// because it overwrite node so we can iterate through [Node.previousNode]
List<Node> getNodesInShortesPath({required Node finishNode}) {
  List<Node> nodesInShortestPathOrder = [];
  Node? currentNode = finishNode;
  while (currentNode != null) {
    nodesInShortestPathOrder.insert(0, currentNode);
    currentNode = currentNode.previousNode;
  }
  return nodesInShortestPathOrder;
}
