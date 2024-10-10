// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Categorytextfield extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const Categorytextfield(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      validator: validator,
      maxLines: 5,
      
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: hinttext,
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
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
