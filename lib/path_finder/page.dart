import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pathfinder_visualization_flutter/model/node.dart';
import 'package:pathfinder_visualization_flutter/path_finder/bloc.dart';
import 'package:pathfinder_visualization_flutter/utils.dart';
import 'package:pathfinder_visualization_flutter/widget/button.dart';
import 'package:pathfinder_visualization_flutter/widget/hint.dart';
import 'package:pathfinder_visualization_flutter/widget/node_field.dart';

class PathFinderPage extends ConsumerWidget {
  const PathFinderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridNodes = ref.watch(gridProvider);
    String hint = ref.watch(hintProvider);
    final bloc = ref.watch(pathFinderProvider);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // Android
          statusBarIconBrightness: Brightness.dark,
          // IOS
          statusBarBrightness: Brightness.light,
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 5,
              ),
              child: Text(
                'Path',
                style: Utils.bodyStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Utils.primaryColor,
              ),
              child: Text(
                'Finder',
                style: Utils.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button(
                    onPressed: () {
                      ref
                          .read(pathFinderProvider)
                          .changeClickState(ClickState.start);
                    },
                    text: "Select Start Point",
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Button(
                    onPressed: () {
                      ref
                          .read(pathFinderProvider)
                          .changeClickState(ClickState.finish);
                    },
                    text: "Select End Point",
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: () {
                  ref
                      .read(pathFinderProvider)
                      .changeClickState(ClickState.wall);
                },
                text: "Select Wall",
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: ref.read(pathFinderProvider).startFindingPath,
                text: "Start Finding Path",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hint : Select $hint",
                    style: Utils.bodyStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Visibility(
                    visible: bloc.isVisualized,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: ElevatedButton.icon(
                      label: const Text("Clear Board"),
                      icon: const Icon(Icons.delete_outline_rounded),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                      ),
                      onPressed: ref.read(pathFinderProvider).clearGrid,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: gridNodes.map((row) {
                  return Row(
                    children: row.map((node) {
                      return GestureDetector(
                        onTap: () =>
                            ref.read(pathFinderProvider).onNodeTapped(node),
                        child: NodeField(node: node),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  ...nodeLabels
                      .map(
                        (node) => Hint(
                          text: node.text ?? '',
                          color: node.color,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
