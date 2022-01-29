import 'package:flutter/material.dart';
import 'package:pathfinder_visualization_flutter/utils.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  const Button({
    Key? key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text ?? ""),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        primary: Utils.primaryColor,
      ),
    );
  }
}
