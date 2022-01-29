import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pathfinder_visualization_flutter/algoritm/dijkstra.dart';
import 'package:pathfinder_visualization_flutter/model/node.dart';
import 'package:pathfinder_visualization_flutter/utils.dart';

final gridProvider = StateProvider<List<List<Node>>>((ref) {
  List<List<Node>> gridNodes = [];
  for (var col = 0; col < 15; col++) {
    List<Node> currentRow = [];
    for (var row = 0; row < 15; row++) {
      currentRow.add(Node(col: col, row: row));
    }
    gridNodes.add(currentRow);
  }
  return gridNodes;
});

enum ClickState {
  start,
  finish,
  wall,
}

final hintProvider = StateProvider<String>((ref) {
  ClickState _currentState = ref.watch(pathFinderProvider).currentState;
  String value = "";
  if (_currentState == ClickState.start) {
    value = "Starting Point";
  } else if (_currentState == ClickState.finish) {
    value = "End Point";
  } else {
    value = "Walls / Barrier";
  }
  return value;
});

final pathFinderProvider = ChangeNotifierProvider(
  (ref) => PathFinderBloc(ref.read),
);

class PathFinderBloc extends ChangeNotifier {
  final Reader read;
  PathFinderBloc(this.read);

  Node? startNode;
  Node? finishNode;
  bool isVisualized = false;
  ClickState currentState = ClickState.start;

  void clearGrid() {
    List<List<Node>> gridNodes = read(gridProvider);
    for (List<Node> element in gridNodes) {
      for (Node item in element) {
        item.isStart = false;
        item.isFinish = false;
        item.isWall = false;
        item.isShortes = false;
        item.isVisited = false;
        item.distance = Utils.maxValue;
        item.previousNode = null;
      }
    }

    startNode = null;
    finishNode = null;
    isVisualized = false;
    currentState = ClickState.start;
    notifyListeners();
  }

  void changeClickState(ClickState value) {
    if (isVisualized) return;
    currentState = value;
    notifyListeners();
  }

  void onNodeTapped(Node node) {
    List<List<Node>> gridNodes = read(gridProvider);
    if (isVisualized) return;
    switch (currentState) {
      case ClickState.start:
        // in case if choose node that already have state (wall / start / finish)
        // then do nothing
        if (node.isWall) return;
        if (node.isStart) return;
        if (node.isFinish) return;

        // in case that already set start node
        // then delete previous starting node
        if (startNode != null) {
          gridNodes[startNode!.col][startNode!.row] = startNode!.copyWith(
            isStart: false,
          );
        }
        // overwrite current node in [gridNodes]
        // with new state [!node.isStart]
        var isStart = !node.isStart;
        gridNodes[node.col][node.row] = node.copyWith(
          isStart: isStart,
        );
        startNode = isStart ? node : null;
        break;
      case ClickState.finish:
        // in case if choose node that already have state (wall / start / finish)
        // then do nothing
        if (node.isWall) return;
        if (node.isStart) return;
        if (node.isFinish) return;

        // in case that already set finish node
        // then delete previous starting node
        if (finishNode != null) {
          gridNodes[finishNode!.col][finishNode!.row] = finishNode!.copyWith(
            isFinish: false,
          );
        }

        // overwrite current node in [gridNodes]
        // with new state [!node.isFinish]
        var isFinish = !node.isFinish;
        gridNodes[node.col][node.row] = node.copyWith(
          isFinish: isFinish,
        );
        finishNode = isFinish ? node : null;
        break;
      case ClickState.wall:
        // in case if choose node that already have state (start / finish)
        // then do nothing
        if (node.isStart) return;
        if (node.isFinish) return;

        var isWall = !node.isWall;
        gridNodes[node.col][node.row] = node.copyWith(
          isWall: isWall,
        );
        break;
    }
    notifyListeners();
  }

  void startFindingPath() async {
    List<List<Node>> gridNodes = read(gridProvider);
    if (isVisualized) return;
    if (startNode == null || finishNode == null) return;
    // set visualize to true so user
    // can't start another visualization when already visualized
    isVisualized = true;

    List<List<Node>> tempGrid = deepCopy(gridNodes);

    List<Node> visitedNodesInOrder = dijkstra(
      grid: tempGrid,
      startNode: tempGrid[startNode!.col][startNode!.row],
      finishNode: tempGrid[finishNode!.col][finishNode!.row],
    );

    List<Node> nodesInShortestPathOrder = getNodesInShortesPath(
      finishNode: tempGrid[finishNode!.col][finishNode!.row],
    );

    for (int i = 0; i <= visitedNodesInOrder.length; i++) {
      // if already animate all visited Nodes
      // then animate the shortest path
      if (i == visitedNodesInOrder.length) {
        for (int j = 0; j < nodesInShortestPathOrder.length; j++) {
          // delay every animation
          await Future.delayed(const Duration(milliseconds: 25));
          Node node = nodesInShortestPathOrder[j];
          gridNodes[node.col][node.row] = node.copyWith(
            isShortes: true,
          );
          notifyListeners();
        }
        return;
      }
      // delay every animation
      await Future.delayed(const Duration(milliseconds: 25));
      Node node = visitedNodesInOrder[i];
      gridNodes[node.col][node.row] = node;
      notifyListeners();
    }
  }

  List<List<Node>> deepCopy(List<List<Node>> gridNodes) {
    List<List<Node>> copy = [];
    for (List<Node> row in gridNodes) {
      List<Node> copyRow = [];
      for (Node node in row) {
        copyRow.add(
          Node(
            col: node.col,
            row: node.row,
            isStart: node.isStart,
            isFinish: node.isFinish,
            isWall: node.isWall,
            isShortes: node.isShortes,
            isVisited: node.isVisited,
            distance: node.distance,
            previousNode: node.previousNode,
          ),
        );
      }
      copy.add(copyRow);
    }
    return copy;
  }
}
