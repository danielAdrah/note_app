// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Gradient gradient;
  double? width = 90;
  SecondaryButton(
      {super.key,
      this.onPressed,
      required this.title,
      required this.gradient,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        height: 40,
        minWidth: width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // color: Colors.transparent,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
