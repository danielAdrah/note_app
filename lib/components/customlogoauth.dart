// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: 80,
          height: 80,
          padding:
              const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 18),
          decoration: BoxDecoration(
              color: Color(0xFF555555),
              borderRadius: BorderRadius.circular(70)),
          child: Image.asset(
            "assets/img/logo.png",
            height: 50,
            // fit: BoxFit.fill,
          )),
    );
  }
}
