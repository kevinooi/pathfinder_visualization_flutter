import 'package:flutter/material.dart';
import 'package:pathfinder_visualization_flutter/utils.dart';

class Node {
  int col;
  int row;
  bool isStart;
  bool isFinish;
  bool isWall;
  bool isShortes;
  bool isVisited;
  int distance;
  Node? previousNode;

  Node({
    required this.col,
    required this.row,
    this.isStart = false,
    this.isFinish = false,
    this.isWall = false,
    this.isShortes = false,
    this.isVisited = false,
    this.distance = Utils.maxValue,
    this.previousNode,
  });

  Node copyWith({
    int? col,
    int? row,
    bool? isStart,
    bool? isFinish,
    bool? isWall,
    bool? isShortes,
  }) {
    return Node(
      col: col ?? this.col,
      row: row ?? this.row,
      isStart: isStart ?? this.isStart,
      isFinish: isFinish ?? this.isFinish,
      isWall: isWall ?? this.isWall,
      isShortes: isShortes ?? this.isShortes,
    );
  }
}

class NodeLabel {
  final String? text;
  final Color? color;

  NodeLabel({
    this.text,
    this.color,
  });
}

List<NodeLabel> nodeLabels = [
  NodeLabel(text: 'Starting Point', color: Utils.startColor),
  NodeLabel(text: "End Point", color: Utils.endColor),
  NodeLabel(text: "Wall / Barrier", color: Utils.wallColor),
  NodeLabel(text: "Unvisited Path", color: Colors.white),
  NodeLabel(text: "Visited", color: Utils.visitedColor),
  NodeLabel(text: "Shortest Path", color: Utils.shortColor),
];
