// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const UploadButton(
      {super.key,
      this.onPressed,
      required this.title,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/img/button.jpg")),
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 59, 221, 94),
                  Color.fromARGB(255, 6, 114, 30),

                  // #04bbff
                  // #515dff
                ],
              )
            : LinearGradient(
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
        minWidth: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // color: Colors.transparent,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
