// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';
import '../theme.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                const CustomLogoAuth(),
                Container(height: 20),
                Text("SignUp",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Container(height: 10),
                Text("SignUp To Continue Using The App",
                    style: TextStyle(color: ThemeColor.white)),
                Container(height: 20),
                Text(
                  "Username",
                  style: TextStyle(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                    hinttext: "ُEnter Your Name",
                    mycontroller: username),
                Container(height: 20),
                Text(
                  "Email",
                  style: TextStyle(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                    hinttext: "ُEnter Your Email",
                    mycontroller: email),
                Container(height: 10),
                Text(
                  "Password",
                  style: TextStyle(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                    hinttext: "ُEnter Your Password",
                    mycontroller: password),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(fontSize: 14, color: ThemeColor.white),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    //after the user creates an account a link is send to it
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.of(context).pushReplacementNamed("logIn");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("The password provided is too weak.")));
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "The account already exists for that email.")));
                    }
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                } else {
                  print("not valid");
                }
              }),
          Container(height: 20),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("logIn");
            },
            child: Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Have An Account ? ",
                    style: TextStyle(color: ThemeColor.white)),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: ThemeColor.icons, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
