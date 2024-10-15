// ignore_for_file: use_build_context_synchronously, unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/categoryTextField.dart';
import '../../components/custombuttonauth.dart';
import '../../components/gradient_icon.dart';
import '../../components/gradient_text.dart';
import '../../theme.dart';

class EditCategory extends StatefulWidget {
  final String docID;
  final String oldName;
  const EditCategory({super.key, required this.docID, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController categoryName = TextEditingController();
  bool addLoading = false;
  //==============
  //here we create a collection to store categories
  //this collection name is categories
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> editCategory() async {
    //here we update the doc with the certain id
    if (formState.currentState!.validate()) {
      //we check is the user entered value for the category name
      try {
        setState(() {
          addLoading = true;
        });
        //this is to update the category with the id i pass it from the database
        //and here we edited the name
        await categories.doc(widget.docID).update({
          "name": categoryName.text,
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

  @override
  void initState() {
    super.initState();
    //to display the old name when we open this page
    categoryName.text = widget.oldName;
  }

  //=============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: GradientText(
            'E D I T  C A T E G O R Y ',
            gradient: LinearGradient(colors: [
              Color(0xFF04bbff),
              Color(0xFF515dff),
            ]),
            style: TextStyle(fontSize: 22),
          ),
        ),
        leading: FadeInLeft(
          delay: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
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
        ),
        centerTitle: true,
        backgroundColor: ThemeColor.appBar,
        foregroundColor: Colors.white,
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
                child: ZoomIn(
                    delay: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    child: Image.asset("assets/img/edit-file.png")),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: FadeInUp(
                  delay: Duration(milliseconds: 350),
                  curve: Curves.decelerate,
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
              ),
              addLoading
                  ? CircularProgressIndicator(
                      color: ThemeColor.icons,
                    )
                  : FadeInUp(
                      delay: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: CustomButtonAuth(
                        title: "Edit",
                        onPressed: () {
                          editCategory();
                          categoryName.clear();
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
