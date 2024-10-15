// ignore_for_file: use_build_context_synchronously, unused_local_variable, body_might_complete_normally_nullable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/components/note_text_field.dart';
import '../../components/custombuttonauth.dart';
import '../../components/gradient_icon.dart';
import '../../components/gradient_text.dart';
import '../../components/upload_button.dart';
import '../../theme.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String docID;
  final String title;
  const AddNote({super.key, required this.docID, required this.title});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController noteName = TextEditingController();
  bool addLoading = false;
  bool imgLoading = false;
  File? file;
  String? url;
  //==============

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgLoading = true;
    });
    if (image != null) {
      file = File(image.path);
      var imageName = basename(image.path);

      var refStorage = FirebaseStorage.instance.ref("images/$imageName");
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    setState(() {});
    setState(() {
      imgLoading = false;
    });
  }

  //=============
  Future<void> addNote(BuildContext context) async {
    //here we want to reach every collection for each doc(category) and add a doc (note)
    //and then display it
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docID)
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
        DocumentReference response = await notes.add({'note': noteName.text, 'url':url ?? 'None'});
        setState(() {
          addLoading = false;
        });

        //after he adds the cateogry take the user back to the home page
        Navigator.of(context).pushReplacementNamed('home');
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

  //=============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GradientText(
          "A D D N O T E ",
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
              addLoading
                  ? CircularProgressIndicator(
                      color: ThemeColor.icons,
                    )
                  : CustomButtonAuth(
                      title: "Add",
                      onPressed: () {
                        addNote(context);
                        noteName.clear();
                      },
                    ),
              SizedBox(height: 15),
              imgLoading
                  ? CircularProgressIndicator(
                      color: ThemeColor.icons,
                    )
                  : FadeInUp(
                      delay: Duration(milliseconds: 800),
                      curve: Curves.decelerate,
                      child: UploadButton(
                        title: "Upload Image",
                        isSelected: url == null ? false : true,
                        onPressed: () async {
                          await getImage();
                        },
                      ),
                    ),
              SizedBox(height: 40),
              if (url != null)
                SizedBox(
                  child: Image.network(
                    url!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
