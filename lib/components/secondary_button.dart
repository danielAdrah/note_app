// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  Color color;
  SecondaryButton(
      {super.key, this.onPressed, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/img/button.jpg")),
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        height: 40,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // color: Colors.transparent,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
