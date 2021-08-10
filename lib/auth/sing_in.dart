import 'package:completeapp1/auth/sign_up.dart';
import 'package:completeapp1/dialog.dart';
import 'package:completeapp1/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.toString().trim(),
              password: passwordController.text.toString().trim());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
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
            Container(
              padding: EdgeInsets.all(0),
              child: Image(image: AssetImage('images/singin.png')),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(200)),
            ),
            Text(
              'SING IN',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
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
                      print(emailController.text);
                      print(passwordController.text);
                      UserCredential response = await signIn();
                      if (response != null) {
                        showLoading(context);
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
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignUp()));
                },
                child: Text("Register an account ?"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
