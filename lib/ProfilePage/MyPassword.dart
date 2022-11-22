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

class MyPassword extends StatefulWidget {
  final DataUser user;
  MyPassword(this.user);
  @override
  _MyPasswordState createState() => _MyPasswordState();
}

class _MyPasswordState extends State<MyPassword> {
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordtextEditingController =
      TextEditingController();
  final TextEditingController _c1passwordtextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool showPass = false;

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
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              CustomTextField(
                data: Icons.lock_outline,
                hintText: "write your old password",
                specifer: 1,
                isObsecure: true,
                controller: _passwordTextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              CustomTextField(
                data: Icons.lock_outline,
                hintText: "write your new password",
                specifer: 1,
                isObsecure: true,
                controller: _cpasswordtextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
              CustomTextField(
                data: Icons.lock_outline,
                hintText: "write your new password again ",
                specifer: 1,
                isObsecure: true,
                controller: _c1passwordtextEditingController,
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
    if (BookStoreUsers.sharedPreferences
            .getString(BookStoreUsers.userPassword)
            .toString() ==
        _passwordTextEditingController.text) {
      if (_c1passwordtextEditingController.text ==
          _cpasswordtextEditingController.text) {
        FirebaseUser firebaseUser = await BookStoreUsers.auth.currentUser();
        await firebaseUser
            .updatePassword(_cpasswordtextEditingController.text)
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
                .updateData({'password': _cpasswordtextEditingController.text})
                .then((value) => print(
                    "User Updated in fireStore..................................."))
                .catchError((error) => print(
                    "Failed to update user in firestore.............................: $error"));

            _passwordTextEditingController.clear();
            _cpasswordtextEditingController.clear();
            _c1passwordtextEditingController.clear();
          },
        ).catchError((onError) {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "write your password correctly.",
              );
            },
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: " passwords don\'t match ",
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "your old password does not correct",
          );
        },
      );
    }
  }
}
