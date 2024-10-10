// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/img/button.jpg")),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF04bbff),
            Color(0xFF515dff),

            // #04bbff
            // #515dff
          ],
        ),
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
