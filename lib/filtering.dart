import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filtering extends StatefulWidget {
  const Filtering({super.key});

  @override
  State<Filtering> createState() => _FilteringState();
}

class _FilteringState extends State<Filtering> {
  List data = [];

  initialData() async {
    //this page is an example of filtering in firebase
    //to filter we use [where] clause which take
    //the field to search and filter and the condition to filter
    //in our case we return the users that thier age is equal to 30
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot userdata = await users.where("age", isEqualTo: 30).get();
    userdata.docs.forEach((element) {
      data.add(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    initialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('filter'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  data[index]['username'],
                  style: TextStyle(fontSize: 30),
                ),
                subtitle: Text("age : ${data[index]['age']}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
