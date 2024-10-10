// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double elevation;

  const GradientFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.elevation = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF04bbff),
            Color(0xFF515dff),
          ],
        ),
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: elevation,
        constraints: BoxConstraints.tightFor(
          width: 56.0,
          height: 56.0,
        ),
        shape: CircleBorder(),
        child: child,
      ),
    );
  }
}
