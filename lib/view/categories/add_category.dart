// ignore_for_file: use_build_context_synchronously, unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/home_page.dart';
import '../../components/categoryTextField.dart';
import '../../components/custombuttonauth.dart';
import '../../components/gradient_icon.dart';
import '../../components/gradient_text.dart';
import '../../theme.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController categoryName = TextEditingController();
  bool addLoading = false;
  //==============
  //here we create a collection to store categories
  //this collection name is categories
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> addCategory() async {
    //here we add documents to the collection we created
    //which takes the cateogry name to add it to the collection(doc name)
    if (formState.currentState!.validate()) {
      //we check is the user entered value for the category name
      try {
        setState(() {
          addLoading = true;
        });
        // we add the id to it so every user can add its own categories
        DocumentReference response = await categories.add({
          'name': categoryName.text,
          'id': FirebaseAuth.instance.currentUser!.uid
        });
        setState(() {
          addLoading = false;
        });

        //after he adds the cateogry take the user back to the home page
        Navigator.of(context).pushNamedAndRemoveUntil(
          'home',
          (route) => false,
        );
      } catch (e) {
        setState(() {
          addLoading = false;
        });
        print(e.toString());
      }
    }
  }

  //=============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GradientText(
          'A D D N O T E ',
          gradient: LinearGradient(colors: [
            Color(0xFF04bbff),
            Color(0xFF515dff),
          ]),
          style: TextStyle(fontSize: 22),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: GradientIcon(
            gradient: LinearGradient(colors: [
              Color(0xFF515dff),
              Color(0xFF04bbff),
            ]),
            icon: Icons.arrow_back_ios,
            size: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: ThemeColor.appBar,
        foregroundColor: ThemeColor.white,
      ),
      body: Form(
        key: formState,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 120),
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/img/edit-file.png"),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Categorytextfield(
                  hinttext: "Enter the category name",
                  mycontroller: categoryName,
                  validator: (val) {
                    if (val == "") {
                      return "Can't be empty";
                    }
                  },
                ),
              ),
              addLoading
                  ? CircularProgressIndicator(
                      color: ThemeColor.icons,
                    )
                  : CustomButtonAuth(
                      title: "Add",
                      onPressed: () {
                        addCategory();
                        categoryName.clear();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
