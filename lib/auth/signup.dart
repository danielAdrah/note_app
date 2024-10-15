// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, avoid_print, unused_local_variable, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/gradient_icon.dart';
import '../components/secondary_button.dart';
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

  bool isLoading = false;

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
                FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: CustomLogoAuth()),
                Container(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 650),
                  child: Text("SignUp",
                      style: TextStyle(
                          color: ThemeColor.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 750),
                  child: Text("SignUp To Continue Using The App",
                      style: TextStyle(color: ThemeColor.white)),
                ),
                Container(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 850),
                  child: Text(
                    "Username",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 950),
                  child: CustomTextForm(
                      prefixIcon: GradientIcon(
                        icon: Icons.person,
                        size: 30,
                        gradient: LinearGradient(
                            colors: [ThemeColor.white, Color(0xFF555555)]),
                      ),
                      validator: (val) {
                        if (val == "") {
                          return "Can't be empty";
                        }
                      },
                      hinttext: "ُEnter Your Name",
                      mycontroller: username),
                ),
                Container(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 1050),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 1150),
                  child: CustomTextForm(
                      prefixIcon: GradientIcon(
                        icon: Icons.email,
                        size: 25,
                        gradient: LinearGradient(
                            colors: [ThemeColor.white, Color(0xFF555555)]),
                      ),
                      validator: (val) {
                        if (val == "") {
                          return "Can't be empty";
                        }
                      },
                      hinttext: "ُEnter Your Email",
                      mycontroller: email),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 1250),
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 1350),
                  child: CustomTextForm(
                      prefixIcon: GradientIcon(
                        icon: Icons.lock,
                        size: 25,
                        gradient: LinearGradient(
                            colors: [ThemeColor.white, Color(0xFF555555)]),
                      ),
                      validator: (val) {
                        if (val == "") {
                          return "Can't be empty";
                        }
                      },
                      hinttext: "ُEnter Your Password",
                      mycontroller: password),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          isLoading
              ? CircularProgressIndicator(color: ThemeColor.icons)
              : FadeInDown(
                  delay: Duration(milliseconds: 1450),
                  child: CustomButtonAuth(
                      title: "SignUp",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            //after the user creates an account a link is send to it
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pushReplacementNamed("logIn");
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              custom_dialog(
                                  context, "The password provided is too weak");
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                              custom_dialog(context,
                                  "The account already exists for that email.");
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print(e);

                            custom_dialog(context, (e.toString()));
                          }
                        } else {
                          print("not valid");
                        }
                      }),
                ),
          Container(height: 20),
          FadeInDown(
            delay: Duration(milliseconds: 1550),
            child: InkWell(
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
                          color: ThemeColor.icons,
                          fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<dynamic> custom_dialog(BuildContext context, String title) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: GradientIcon(
              icon: CupertinoIcons.clear_circled,
              gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 241, 109, 100),
                const Color.fromARGB(255, 133, 16, 7)
              ]),
              size: 70,
            ),
            backgroundColor: ThemeColor.card,
            title: Center(
                child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: ThemeColor.white),
            )),
            actions: [
              Center(
                child: SecondaryButton(
                  width: 160,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(255, 241, 109, 100),
                      const Color.fromARGB(255, 133, 16, 7)
                    ],
                  ),
                  title: "Ok",
                  onPressed: () {
                    Navigator.of(context).pop();
                    // deleteCategory(categoryData[index].id);
                  },
                ),
              ),
            ],
          );
        });
  }
}
