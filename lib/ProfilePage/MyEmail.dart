import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'DataUser.dart';

class MyEmail extends StatefulWidget {
  final DataUser user;
  MyEmail(this.user);

  @override
  _MyEmailState createState() => _MyEmailState();
}

class _MyEmailState extends State<MyEmail> {
  final TextEditingController _emailtextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 160.0),
              Row(
                children: [
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  Text(
                    "Your Email : ",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.02,
                  ),
                  Flexible(
                    child: Text(
                      widget.user.Email,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              CustomTextField(
                data: Icons.email_outlined,
                hintText: "write your new Email:",
                specifer: 1,
                isObsecure: false,
                controller: _emailtextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              ElevatedButton(
                onPressed: () {
                  updateDataToFirebase();
                },
                style: OutlinedButton.styleFrom(
                  elevation: 9,
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateDataToFirebase() async {
    if (_emailtextEditingController.text.isNotEmpty) {
      FirebaseUser firebaseUser = await BookStoreUsers.auth.currentUser();
      await firebaseUser
          .updateEmail(_emailtextEditingController.text.trim())
          .then(
        (value) async {
          Fluttertoast.showToast(
            msg: "it\'s Done",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            //timeInSecForIosWeb: 1,
            backgroundColor: Colors.lightBlueAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          await Firestore.instance
              .collection("users")
              .document(BookStoreUsers.sharedPreferences
                  .getString(BookStoreUsers.userUID))
              .updateData({'email': _emailtextEditingController.text})
              .then((value) => print("User Updated in fireStore"))
              .catchError((error) =>
                  print("Failed to update user in firestore: $error"));

          _emailtextEditingController.clear();
        },
      ).catchError((onError) {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "write your Email correctly .",
            );
          },
        );
      });
    } else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "fill the Email ",
          );
        },
      );
  }
}
