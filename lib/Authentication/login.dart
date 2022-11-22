import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import "dart:core";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screeHight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                'images/login.jpg',
                height: 200.0,
                width: 600,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please  Login To Your Account..",
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 13.0),
              ),
            ),
            Form(
              key: _fromkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                    specifer: 1,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                    specifer: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            // ignore: deprecated_member_use
            SizedBox(
              width: 350.0,
              // ignore: deprecated_member_use
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  _emailtextEditingController.text.isNotEmpty &&
                          _passwordtextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please Fill Email And Password",
                            );
                          });
                },
                color: Colors.blueAccent,
                child: Text(
                  "Log In ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),

            Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    // ignore: deprecated_member_use
                    child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        signinWithGoogle();
                      },
                      icon: Image.asset('images/Google_logo.jpg'),
                      label: Text(
                        'Sign in with Google ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    // Timer(Duration(seconds: 20), ()=>print("20
    // seconds 20 seconds   20 seconds 20 seconds  20 seconds 20 seconds  20 seconds 20 seconds"),);

    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating , Please Wait",
          );
        });

    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailtextEditingController.text.trim(),
      password: _passwordtextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => Home());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    print("he is reading data now in readData");

    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await BookStoreUsers.sharedPreferences.setString(
          BookStoreUsers.phoneNumber,
          dataSnapshot.data[BookStoreUsers.phoneNumber]);
      await BookStoreUsers.sharedPreferences.setString(
          BookStoreUsers.userPassword,
          dataSnapshot.data[BookStoreUsers.userPassword]);
      await BookStoreUsers.sharedPreferences.setString(
          BookStoreUsers.userAvatarUrl,
          dataSnapshot.data[BookStoreUsers.userAvatarUrl]);
      await BookStoreUsers.sharedPreferences.setString(
          BookStoreUsers.userUID, dataSnapshot.data[BookStoreUsers.userUID]);
      await BookStoreUsers.sharedPreferences.setString(BookStoreUsers.userEmail,
          dataSnapshot.data[BookStoreUsers.userEmail]);
      await BookStoreUsers.sharedPreferences.setString(
          BookStoreUsers.userName, dataSnapshot.data[BookStoreUsers.userName]);
    });

    print("he is finishing data now in readData");
  }

  Future signinWithGoogle() async {
    FirebaseUser firebaseUser1;

    print("first .....................................");
    final signInGoogle = GoogleSignIn();
    final googleUsers = await signInGoogle.signIn();
    print("second .....................................");

    if (googleUsers != null) {
      print(
          "googleUsers !=null...................................................");

      final googleAuth = await googleUsers.authentication;
      if (googleAuth.idToken != null) {
        print(
            "idToken!=null.......................................................");

        final userCredential = await _auth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ))
            .then((value) {
          print("......................................in THEN NOW (before) ");
          firebaseUser1 = value.user;
          print("......................................in THEN NOW (after) ");
          print(
              "......................................in THEN NOW::::::::::: $firebaseUser1 ");
        });
        print(
            "userCredential.then((value) => value.user);............................................");
        if (firebaseUser1 != null) {
          saveUserInfoToFireStore(firebaseUser1).then((s) {
            //  Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => Home());
            Navigator.push(context, route);
          });
        }
      } else {
        print("............googleAuth.idToken===null.............");
      }
    } else {
      print("google user ==null .............................");
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fuser) async {
    Firestore.instance.collection("users").document(fuser.uid).setData({
      "uid": fuser.uid,
      "email": fuser.email,
      "name": fuser.displayName,
      "url": fuser.photoUrl,
      "caseSearch": setSearchParam(fuser.displayName.toUpperCase()),
      "phoneNumber":
          fuser.phoneNumber != null ? fuser.phoneNumber : "No phoneNumber",
      "password": fuser.phoneNumber != null
          ? "Your Password is Secure from Google!"
          : " Your Password is Secure from Google!",
    });
    await BookStoreUsers.sharedPreferences
        .setString(BookStoreUsers.userUID, fuser.uid);
    await BookStoreUsers.sharedPreferences
        .setString(BookStoreUsers.userEmail, fuser.email);
    await BookStoreUsers.sharedPreferences
        .setString(BookStoreUsers.userPassword, fuser.providerId);
    await BookStoreUsers.sharedPreferences
        .setString(BookStoreUsers.userName, fuser.displayName);
    await BookStoreUsers.sharedPreferences
        .setString(BookStoreUsers.userAvatarUrl, fuser.photoUrl);
    await BookStoreUsers.sharedPreferences.setString(BookStoreUsers.phoneNumber,
        fuser.phoneNumber != null ? fuser.phoneNumber : "No phoneNumber");
  }

  setSearchParam(String caseNumber) {
    // ignore: deprecated_member_use
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}
