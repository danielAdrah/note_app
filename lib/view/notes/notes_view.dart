// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/theme.dart';

import '../../components/custom_floating_button.dart';
import '../../components/custombuttonauth.dart';
import '../../components/gradient_icon.dart';
import '../../components/gradient_text.dart';
import '../../components/secondary_button.dart';
import 'add_note.dart';
import 'edit_note.dart';

class NoteView extends StatefulWidget {
  final String docID;
  final String title;
  const NoteView({super.key, required this.docID, required this.title});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  //in this list we will store the data from the categories collection to display it
  List<QueryDocumentSnapshot> categoryData = [];

  bool isLoading = true;

  getNotes() async {
    //here we create a subcollection for every category we have in the categories collection
    //and we bring them to display
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docID)
        .collection('note')
        .get();

    categoryData.addAll(data.docs);
    isLoading = false;
    setState(() {});
  }

  //===

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: GradientText(
            widget.title,
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
        backgroundColor: ThemeColor.appBar,
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: 380),
        curve: Curves.decelerate,
        child: GradientFloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNote(
                      docID: widget.docID,
                      title: widget.title,
                    )));
          },
        ),
      ),
      // FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => AddNote(
      //               docID: widget.docID,
      //               title: widget.title,
      //             )));
      //   },
      //   backgroundColor: Colors.orange,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),

      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ThemeColor.icons,
              ),
            )
          : categoryData.isEmpty
              ? Center(
                  child: ZoomIn(
                    delay: Duration(milliseconds: 350),
                    curve: Curves.decelerate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/add.png",
                          height: 120,
                          width: 120,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "There are no notes in this category \n Please add note first",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView.builder(
                      itemCount: categoryData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            customDialog(context, index);
                          },
                          child: FadeInUp(
                            delay: Duration(milliseconds: 400),
                            curve: Curves.decelerate,
                            child: Card(
                              margin: EdgeInsets.only(bottom: 20),
                              color: ThemeColor.card,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Text("${categoryData[index]['note']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: ThemeColor.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
    );
  }

  Future<dynamic> customDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: GradientIcon(
              icon: Icons.info_outline,
              gradient: LinearGradient(colors: [
                Color(0xFF515dff),
                Color(0xFF04bbff),
              ]),
              size: 70,
            ),
            backgroundColor: ThemeColor.card,
            title: Center(
                child: Text(
              "What do you want to do ?",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: ThemeColor.white),
            )),
            actions: [
              CustomButtonAuth(
                title: "Edit",
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditNote(
                          condition: categoryData[index]['url'],
                          image: categoryData[index]['url'],
                          noteID: categoryData[index].id,
                          categoryID: widget.docID,
                          oldNote: categoryData[index]['note'])));
                },
              ),
              SecondaryButton(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 241, 109, 100),
                    const Color.fromARGB(255, 133, 16, 7)
                  ],
                ),
                title: "Delete",
                onPressed: () async {
                  // deleteNote(categoryData[index].id);
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(widget.docID)
                      .collection('note')
                      .doc(categoryData[index].id)
                      .delete();
                  //here we checked if the note has an image
                  //if it does we delete it from the storage
                  // so we pass the image url to dlete it
                  if (categoryData[index]['url'] != "None") {
                    FirebaseStorage.instance
                        .refFromURL(categoryData[index]['url'])
                        .delete();
                  }

                  Navigator.of(context).pushReplacementNamed('home');
                },
              ),
            ],
          );
        });
  }
}
