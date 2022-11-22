import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:image_picker/image_picker.dart';

import 'DataUser.dart';

class ProfilePic extends StatefulWidget {
  final DataUser user;
  ProfilePic({this.user});
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File file;
  String userImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.url),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFf5F6F9),
                onPressed: () {
                  takeImage(context);
                },
                child: Center(child: Icon(Icons.camera_alt_outlined)),
              ),
            ),
          )
        ],
      ),
    );
  }

  takeImage(mContext) {
    setState(() {});
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff122636), width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Book Image",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text("Capture With Camera",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: caputrePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Select From Gallery",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  caputrePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      file = imageFile;
    });
    updatePhotoToFirebase();
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
    updatePhotoToFirebase();
  }

  updatePhotoToFirebase() async {
    if (file != null) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "Upload Photo ....",
            );
          });

      String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(imageFileName);

      StorageUploadTask storageUploadTask = storageReference.putFile(file);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        userImageUrl = urlImage;
      });

      Firestore.instance
          .collection("users")
          .document(BookStoreUsers.sharedPreferences
              .getString(BookStoreUsers.userUID))
          .updateData({'url': userImageUrl})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      //print("done");
      Navigator.pop(context);
    } else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "Please Select An Image File .",
          );
        },
      );
  }
}
