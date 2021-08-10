import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:completeapp1/dialog.dart';
import 'package:completeapp1/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  addNotes(BuildContext context) {
    showLoading(context);
    CollectionReference users = FirebaseFirestore.instance.collection('notes');
    return users
        .add({
          'title': titleController.text.toString().trim(),
          'note': noteController.text.toString().trim(),
          "userid": FirebaseAuth.instance.currentUser.uid
        })
        .then((value) => print("notes Added"))
        .catchError((error) => print("Failed to add notes: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Note"),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (val) {
                      if (val.length > 30) {
                        return "Title can't to be larger than 30 letter";
                      }
                      if (val.length < 2) {
                        return "Title can't to be less than 2 letter";
                      }
                      return null;
                    },
                    maxLength: 30,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Title Note",
                        prefixIcon: Icon(Icons.note)),
                  ),
                  TextFormField(
                    controller: noteController,
                    validator: (val) {
                      if (val.length > 255) {
                        return "Notes can't to be larger than 255 letter";
                      }
                      if (val.length < 10) {
                        return "Notes can't to be less than 10 letter";
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 3,
                    maxLength: 200,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Note",
                        prefixIcon: Icon(Icons.note)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await addNotes(context);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()));
                    },
                    textColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    child: Text(
                      "Add Note",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
