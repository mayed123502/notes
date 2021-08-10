import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:completeapp1/auth/sing_in.dart';
import 'package:completeapp1/screens/addNot.dart';
import 'package:completeapp1/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Notes"),
        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.logout),
            ),
            onTap: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignIn(),
                        ),
                      ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddNote(),
            ),
          );
        },
      ),
      body: Container(
        child: FutureBuilder(
          future: notesref
              .where("userid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        NotesBuild(
                          notes: snapshot.data.docs[i]['note'],
                          title: snapshot.data.docs[i]['title'],
                        ),
                      ],
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen(),
                  ));
            },
          ),
        ]),
      ),
    );
  }
}

class NotesBuild extends StatelessWidget {
  final docsId;
  final String title;
  final String notes;

  NotesBuild({this.docsId, this.title, this.notes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(color: Colors.teal.withOpacity(.5)),
        child: ListTile(
          tileColor: Colors.teal.withOpacity(.7),
          title: Text(title),
          subtitle: Text(notes),
        ),
      ),
    );
  }
}
