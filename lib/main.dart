// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/firebase_options.dart';

import 'auth/signup.dart';
import 'filtering.dart';
import 'home_page.dart';
import 'view/categories/add_category.dart';
import 'view/categories/edit_category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  // dart pub global run flutterfire_cli:flutterfire configure
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('==============================User is currently signed out!');
      } else {
        print('==============================User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : Login(),
      routes: {
        "logIn": (context) => Login(),
        "signUp": (context) => SignUp(),
        "home": (context) => HomePage(),
        'addCategory': (context) => AddCategory(),
      },
    );
  }
}
