import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'DataUser.dart';

class MyPhoneNumber extends StatefulWidget {
  final DataUser user;
  MyPhoneNumber(this.user);

  @override
  _MyPhoneNumberState createState() => _MyPhoneNumberState();
}

class _MyPhoneNumberState extends State<MyPhoneNumber> {
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  String bookId = "";

  bool makeStream = false;
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15.0),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.05,
                    ),
                    Text(
                      "Your phone Number : ",
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
                        widget.user.phoneNumber,
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
                  data: Icons.local_phone_outlined,
                  hintText: "Write your new phone number:",
                  specifer: 1,
                  isObsecure: false,
                  controller: _phoneNumberTextEditingController,
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
      ),
    );
  }

  updateDataToFirebase() async {
    if (_phoneNumberTextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("users")
          .document(BookStoreUsers.sharedPreferences
              .getString(BookStoreUsers.userUID))
          .updateData({
        'phoneNumber': _phoneNumberTextEditingController.text
      }).then((value) {
        _phoneNumberTextEditingController.clear();
        Fluttertoast.showToast(
          msg: "it\'s Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        print("User Updated in fireStore");
      }).catchError((error) {
        print("Failed to update user in firestore: $error");
        showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please write your phone1 ",
            );
          },
        );
      });
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
