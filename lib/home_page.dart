// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/theme.dart';
import 'package:note_app/view/categories/edit_category.dart';
import 'components/custom_floating_button.dart';
import 'components/custombuttonauth.dart';
import 'components/gradient_icon.dart';
import 'components/gradient_text.dart';
import 'components/secondary_button.dart';
import 'view/notes/notes_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //in this list we will store the data from the categories collection to display it
  List<QueryDocumentSnapshot> categoryData = [];

  bool isLoading = true;

  getCategories() async {
    //this will bring all the categories (documents) in this collection
    //we add the where clause so we will display only the categories for each user depending on the user id
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    categoryData.addAll(data.docs);
    isLoading = false;
    setState(() {});
  }

  //===
  deleteCategory(String id) async {
    //this for deleting a category(a doc from the collection)
    //which needs the doc id
    await FirebaseFirestore.instance.collection("categories").doc(id).delete();

    //to refresh the page after the delete
    Navigator.of(context).pushNamedAndRemoveUntil(
      'home',
      (route) => false,
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        backgroundColor: ThemeColor.appBar,

        centerTitle: true,
        //this is a text with a gradient color
        title: FadeInDown(
          delay: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: GradientText(
            'H O M E',
            gradient: LinearGradient(colors: [
              Color(0xFF04bbff),
              Color(0xFF515dff),
            ]),
            style: TextStyle(fontSize: 22),
          ),
        ),

        actions: [
          FadeInRight(
            delay: Duration(milliseconds: 350),
            curve: Curves.decelerate,
            child: IconButton(
              onPressed: () async {
                //this is for google signout
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();

                //this is for normal signout
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('logIn');
              },
              //this is an icon with a gradient color
              icon: GradientIcon(
                gradient: LinearGradient(colors: [
                  Color(0xFF515dff),
                  Color(0xFF04bbff),
                ]),
                icon: Icons.logout,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: 350),
        curve: Curves.decelerate,
        child: GradientFloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushNamed('addCategory');
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ThemeColor.icons,
              ),
            )
          : categoryData.isEmpty
              ? Center(
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
                        "There is nothing to display \n Please create a category first",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: GridView.builder(
                    itemCount: categoryData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 160),
                    itemBuilder: (context, index) {
                      if (index % 2 == 0) {
                        return FadeInLeft(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NoteView(
                                        docID: categoryData[index].id,
                                        title: "${categoryData[index]['name']}",
                                      )));
                            },
                            onLongPress: () {
                              custom_dialog(context, index);
                            },
                            child: Card(
                              color: ThemeColor.card,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/img/folder.png",
                                      height: 100,
                                    ),
                                    Text("${categoryData[index]['name']}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return FadeInRight(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NoteView(
                                        docID: categoryData[index].id,
                                        title: "${categoryData[index]['name']}",
                                      )));
                            },
                            onLongPress: () {
                              showDialog(
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
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditCategory(
                                                            docID: categoryData[
                                                                    index]
                                                                .id,
                                                            oldName:
                                                                categoryData[
                                                                        index]
                                                                    ['name'])));
                                          },
                                        ),
                                        SecondaryButton(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color.fromARGB(
                                                  255, 241, 109, 100),
                                              const Color.fromARGB(
                                                  255, 133, 16, 7)
                                            ],
                                          ),
                                          title: "Delete",
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteCategory(
                                                categoryData[index].id);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Card(
                              color: ThemeColor.card,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/img/folder.png",
                                      height: 100,
                                    ),
                                    Text("${categoryData[index]['name']}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
    );
  }

  Future<dynamic> custom_dialog(BuildContext context, int index) {
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
                      builder: (context) => EditCategory(
                          docID: categoryData[index].id,
                          oldName: categoryData[index]['name'])));
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
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteCategory(categoryData[index].id);
                },
              ),
            ],
          );
        });
  }
}
