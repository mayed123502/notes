import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:completeapp1/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser.email);

    return Scaffold(appBar: AppBar(title: Text("My Profile"),centerTitle: true,),
        body: Container(
      child: FutureBuilder(
        future: notesref
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  print(snapshot.data.docs[i]['email']);
                  print(FirebaseAuth.instance.currentUser.uid);

                  return Column(
                    children: [
                      SizedBox(height: 10),
                      NotesBuild(
                        notes: snapshot.data.docs[i]['email'],
                        title: snapshot.data.docs[i]['username'],
                      ),

                    ],
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}
