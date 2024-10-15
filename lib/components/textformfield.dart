// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  Widget prefixIcon;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      this.validator,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: hinttext,
          prefixIcon: prefixIcon,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Color(0xFF444444),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 92, 92, 92)))),
    );
  }
}
