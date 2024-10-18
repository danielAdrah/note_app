// ignore_for_file: use_build_context_synchronously, unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/custombuttonauth.dart';
import '../../components/gradient_icon.dart';
import '../../components/gradient_text.dart';
import '../../components/note_text_field.dart';
import '../../home_page.dart';
import '../../theme.dart';

class EditNote extends StatefulWidget {
  final String noteID;
  final String categoryID;
  final String oldNote;
  final String image;
  final String condition;
  const EditNote({
    super.key,
    required this.noteID,
    required this.categoryID,
    required this.oldNote,
    required this.image,
    required this.condition,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController noteName = TextEditingController();
  bool addLoading = false;

  //==============

  Future<void> editNote() async {
    //here we want to reach every collection for each doc(category) and edit a doc (note)
    //and then display it
    //so first we go to the collection "categories" and we go to each one by the id
    //and then to each category we went to the "note collection"
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryID)
        .collection('note');

    //here we add documents to the collection we created
    //which takes the cateogry name to add it to the collection(doc name)
    if (formState.currentState!.validate()) {
      //we check is the user entered value for the category name
      try {
        setState(() {
          addLoading = true;
        });
        // we add the id to it so every user can add its own categories
        await notes.doc(widget.noteID).update({'note': noteName.text});
        setState(() {
          addLoading = false;
        });

        //after he adds the cateogry take the user back to the home page
        // Navigator.of(context as BuildContext).pushReplacementNamed('home');
        Get.to(HomePage());
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => NoteView(
        //             docID: widget.docID,
        //             title: widget.title,
        //           )),
        // );
      } catch (e) {
        setState(() {
          addLoading = false;
        });
        print(e.toString());
      }
    }
  }

//==================

  @override
  void initState() {
    super.initState();
    noteName.text = widget.oldNote;
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
            "E D I T N O T E ",
            gradient: LinearGradient(colors: [
              Color(0xFF04bbff),
              Color(0xFF515dff),
            ]),
            style: TextStyle(fontSize: 22),
          ),
        ),
        leading: FadeInLeft(
          delay: Duration(milliseconds: 250),
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
                  delay: Duration(milliseconds: 400),
                  curve: Curves.decelerate,
                  child: NoteTextField(
                    hinttext: "Enter your note ",
                    mycontroller: noteName,
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
                      delay: Duration(milliseconds: 650),
                      curve: Curves.decelerate,
                      child: CustomButtonAuth(
                        title: "Edit",
                        onPressed: () {
                          editNote();
                          noteName.clear();
                        },
                      ),
                    ),
              SizedBox(height: 50),
              if (widget.condition != "None")
                ZoomIn(
                  child: Image.network(
                    widget.image,
                    height: 200,
                    width: 350,
                    fit: BoxFit.fill,
                  ),
                ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
