import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profile_menu.dart';
import 'package:gradproject/ProfilePage/profile_pic.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'dart:io';
import 'MyEmail.dart';
import 'MyName.dart';
import 'MyPassword.dart';
import 'MyPhoneNumber.dart';

class profilePage extends StatefulWidget {
  final DataUser user;
  profilePage({this.user});

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  File file;
  String userImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.profile),
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              ProfilePic(
                user: widget.user,
              ),
              SizedBox(height: 20),
              ProfileMenu(
                text: "My name:",
                icon2: Icons.arrow_forward_ios,
                icon: Icons.drive_file_rename_outline,
                press: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyName(widget.user)))
                },
              ),
              ProfileMenu(
                text: "My phone Number",
                icon: Icons.phone,
                icon2: Icons.arrow_forward_ios,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPhoneNumber(widget.user)));
                },
              ),
              ProfileMenu(
                text: "My Email:",
                icon2: Icons.arrow_forward_ios,
                icon: Icons.email_outlined,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyEmail(widget.user)));
                },
              ),
              ProfileMenu(
                text: "My password:",
                icon2: Icons.arrow_forward_ios,
                icon: Icons.lock_outline,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPassword(widget.user)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateDataToFirebase() async {
    if (_nametextEditingController.text.isNotEmpty ||
        _phoneNumberTextEditingController.text.isNotEmpty ||
        _emailtextEditingController.text.isNotEmpty ||
        _passwordTextEditingController.text.isNotEmpty) {
      if (_nametextEditingController.text.isNotEmpty) {
        await Firestore.instance
            .collection("users")
            .document(BookStoreUsers.sharedPreferences
                .getString(BookStoreUsers.userUID))
            .updateData({'name': _nametextEditingController.text})
            .then((value) => print("User Updated in fireStore"))
            .catchError((error) {
              print("Failed to update user in firestore: $error");
              showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Please write your Name ",
                  );
                },
              );
            });

        Fluttertoast.showToast(
          msg: "it\'s Done .......",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _nametextEditingController.clear();
      }

      if (_phoneNumberTextEditingController.text.isNotEmpty) {
        await Firestore.instance
            .collection("users")
            .document(BookStoreUsers.sharedPreferences
                .getString(BookStoreUsers.userUID))
            .updateData({'phoneNumber': _phoneNumberTextEditingController.text})
            .then((value) => print("User Updated in fireStore"))
            .catchError((error) {
              print("Failed to update user in firestore: $error");
              showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Please write your phone ",
                  );
                },
              );
            });

        Fluttertoast.showToast(
          msg: "it\'s Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _phoneNumberTextEditingController.clear();
      }

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
      }

      if (_passwordTextEditingController.text.isNotEmpty) {
        FirebaseUser firebaseUser = await BookStoreUsers.auth.currentUser();
        await firebaseUser
            .updatePassword(_passwordTextEditingController.text)
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
                .updateData({'password': _passwordTextEditingController.text})
                .then((value) => print("User Updated in fireStore"))
                .catchError((error) =>
                    print("Failed to update user in firestore: $error"));

            _passwordTextEditingController.clear();
          },
        ).catchError((onError) {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Your password should be more than 6 characters .",
              );
            },
          );
        });
      }
    } else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "fill one of them at least ",
          );
        },
      );
  }
}
