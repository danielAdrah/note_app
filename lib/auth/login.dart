// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, unused_local_variable, avoid_print, use_build_context_synchronously, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/gradient_icon.dart';
import '../components/secondary_button.dart';
import '../components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/upload_button.dart';
import '../theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  //=======

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    //take me to the home page after it is done
    Navigator.of(context).pushReplacementNamed("home");
  }

//==========
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
                    child: const CustomLogoAuth()),
                Container(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 650),
                  child: Text("Login",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.white)),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 750),
                  child: Text("Login To Continue Using The App",
                      style: TextStyle(color: ThemeColor.white)),
                ),
                Container(height: 20),
                FadeInDown(
                  delay: Duration(milliseconds: 850),
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: ThemeColor.white),
                  ),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 950),
                  child: CustomTextForm(
                    prefixIcon: GradientIcon(
                      icon: Icons.email,
                      size: 25,
                      gradient: LinearGradient(colors: [
                        ThemeColor.white,
                        Color(0xFF555555),
                      ]),
                    ),
                    hinttext: "ُEnter Your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                    },
                  ),
                ),
                Container(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 1050),
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
                  delay: Duration(milliseconds: 1150),
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
                FadeInRight(
                  delay: Duration(milliseconds: 1700),
                  child: InkWell(
                    onTap: () async {
                      if (email.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("please enter your email first")));
                        return;
                      }

                      try {
                        //this for sending an link to the email that the user forget its password
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("A link has been send to your email")));
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(fontSize: 14, color: ThemeColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? CircularProgressIndicator(
                  color: ThemeColor.icons,
                )
              : FadeInDown(
                  delay: Duration(milliseconds: 1250),
                  child: CustomButtonAuth(
                      title: "login",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (credential.user!.emailVerified) {
                              //here we check if the user has verified his account
                              //if he so we will take hin to the home page
                              //if he is not we will tell him to do it
                              Navigator.of(context)
                                  .pushReplacementNamed('home');
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              custom_dialog(
                                  context, "Please verify your email");
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content:
                              //             Text('please verify your email.')));
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              custom_dialog(
                                  context, "No user found for that email");
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              custom_dialog(context,
                                  "Wrong password provided for that user");
                            }

                            custom_dialog(context, e.code.toString());
                          }
                        } else {
                          print("not valid");
                        }
                      }),
                ),
          Container(height: 20),

          FadeInDown(
            delay: Duration(milliseconds: 1350),
            child: MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.red[700],
                textColor: Colors.white,
                onPressed: () {
                  signInWithGoogle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login With Google  "),
                    Image.asset(
                      "assets/img/4.png",
                      width: 20,
                    )
                  ],
                )),
          ),
          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          FadeInDown(
            delay: Duration(milliseconds: 1450),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signUp");
              },
              child: Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Don't Have An Account ? ",
                      style: TextStyle(color: ThemeColor.white)),
                  TextSpan(
                      text: "Register",
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
