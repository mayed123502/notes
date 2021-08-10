import 'package:completeapp1/auth/sing_in.dart';
import 'package:completeapp1/dialog.dart';
import 'package:completeapp1/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  SignUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.toString().trim(),
              password: passwordController.text.toString().trim());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .add({
          'email': emailController.text.toString().trim(),
          'password': passwordController.text.toString().trim(),
          'username': usernameController.text.toString().trim(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
            ),
            Container(
              height: 200,
              width: 200,
              padding: EdgeInsets.all(0),
              child: Image(image: AssetImage('images/signup.png')),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(200)),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'SING UP',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                validator: (val) {
                  if (val.length > 100) {
                    return "UserName can't to be larger than 100 letter";
                  }
                  if (val.length < 4) {
                    return "UserName can't to be less than 4 letter";
                  }
                  return null;
                },
                controller: usernameController,
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'USER-NAME',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.5),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                validator: (val) =>
                    !val.contains('@') ? 'Not a valid email.' : null,
                controller: emailController,
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'EMAIL',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.5),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                validator: (val) {
                  if (val.length > 100) {
                    return "Password can't to be larger than 100 letter";
                  }
                  if (val.length < 4) {
                    return "Password can't to be less than 4 letter";
                  }
                  return null;
                },
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'PASSWORD',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.5),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        showLoading(context);

                        UserCredential response = await SignUp();
                        if (response != null) {
                          addUser();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                          );
                        }

                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignIn()));
                },
                child: Text("Login"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
