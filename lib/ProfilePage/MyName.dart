import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'DataUser.dart';

class MyName extends StatefulWidget {
  final DataUser user;
  MyName(this.user);
  @override
  _MyNameState createState() => _MyNameState();
}

class _MyNameState extends State<MyName> {
  final TextEditingController _nametextEditingController =
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
                    "Your Name : ",
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
                      widget.user.Name,
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
                data: Icons.drive_file_rename_outline,
                hintText: "write your new name",
                specifer: 1,
                isObsecure: false,
                controller: _nametextEditingController,
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

  updateDataToFirebase() async {
    if (_nametextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("users")
          .document(BookStoreUsers.sharedPreferences
              .getString(BookStoreUsers.userUID))
          .updateData({
        "caseSearch":
            setSearchParam(_nametextEditingController.text.toUpperCase()),
        'name': _nametextEditingController.text
      }).then((value) {
        _nametextEditingController.clear();

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
              message: "Please write your Name ",
            );
          },
        );
      });
    } else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "fill the name ",
          );
        },
      );
  }
}
