import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'pdfFiles.dart';

class pdfUpload extends StatefulWidget {
  @override
  _pdfUploadState createState() => _pdfUploadState();
}

class _pdfUploadState extends State<pdfUpload> {
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
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              CustomTextField(
                data: Icons.drive_file_rename_outline,
                hintText: "write name of pdf:",
                specifer: 1,
                isObsecure: false,
                controller: _nametextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              ElevatedButton(
                onPressed: () {
                  uploadPdfBook();
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
                  'upload pdf',
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

  uploadPdfBook() async {
    if (_nametextEditingController.text.isNotEmpty) {
      String pdfID = DateTime.now().microsecondsSinceEpoch.toString();


      File file = await FilePicker.getFile(type: FileType.custom);

      String fileName = "$pdfID";

      if(file!=null)
      savePDF(file, fileName);

    }
    else {
      displayDialog("Please fill name of  pdf Book ..");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  void savePDF(File file, String fileName) async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Uploading , Please Wait..",
          );
        });


    final StorageReference storageReference = FirebaseStorage.instance.ref().child("PDFBooks");

    StorageUploadTask uploadTask = storageReference.child("pdfBook_$fileName").putFile(file);



    print("storing in firebase fished and start now download url of pdf book ");

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String url = await taskSnapshot.ref.getDownloadURL();

    documentFileUpload(url, fileName);
  }

  void documentFileUpload(String url, String name) {

    Firestore.instance.collection("BookPdf").document(name).setData({
      "urlPicture":
          'https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/static%20pictures%2Fdigital-book-logo.jpg?alt=media&token=ce97ddb8-9bbc-492f-9009-59f0d16e26ad',
      "urlPdf": url,
      'publisher':
          BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userName),
      "name": _nametextEditingController.text,
      "uid": BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userUID),
    }).then((value) {
      print("book pdf uploaded......................................................................");
    });

    _nametextEditingController.clear();
    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (c) => pdfFiles());
    Navigator.pushReplacement(context, route);
  }
}
