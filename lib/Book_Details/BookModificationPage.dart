import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:image_picker/image_picker.dart';

class BookModificationPage extends StatefulWidget {
  final Book itemModel;
  BookModificationPage({this.itemModel});

  @override
  _BookModificationPageState createState() => _BookModificationPageState();
}

class _BookModificationPageState extends State<BookModificationPage> {
  var downloadUrl = new List(5);
  int imageSelector;

  File file;
  File file1;
  File file2;
  File file3;
  File file4;

  //String userImageUrl = "";

  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();

  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _desicriptiontextEditingController =
      TextEditingController();
  final TextEditingController _statustextEditingController =
      TextEditingController();
  final TextEditingController _numberTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordtextEditingController =
      TextEditingController();
  String city = "";
  String purpose = "";
  String category = "";
  String selectedCity = "choice city :";
  String selectedCategory = "choice category :";
  String selectedPurpose = "choice purpose :";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44),
                bottomRight: Radius.circular(44)),
            child: MyDrawer(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Image.network(widget.itemModel.thumbnailUrl[0]),
                    ),
                    Positioned(
                      right: 150,
                      bottom: 20,
                      child: SizedBox(
                        height: 66,
                        width: 66,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.white),
                          ),
                          color: Color(0xFFF5F6F9),
                          onPressed: () {
                            imageSelector = 0;
                            takeImage(context, imageSelector);
                          },
                          child: Center(child: Icon(Icons.camera_alt_outlined)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            imageSelector = 1;
                            return takeImage(context, imageSelector);
                          },
                          child: CircleAvatar(
                            radius: screenSize.width * 0.1,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                file1 == null ? null : FileImage(file1),
                            child: file1 == null
                                ? Image.network(
                                    widget.itemModel.thumbnailUrl[1])
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            imageSelector = 2;
                            return takeImage(context, imageSelector);
                          },
                          child: CircleAvatar(
                            radius: screenSize.width * 0.1,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                file2 == null ? null : FileImage(file2),
                            child: file2 == null
                                ? Image.network(
                                    widget.itemModel.thumbnailUrl[2])
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            imageSelector = 3;
                            return takeImage(context, imageSelector);
                          },
                          child: CircleAvatar(
                            radius: screenSize.width * 0.1,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                file3 == null ? null : FileImage(file3),
                            child: file3 == null
                                ? Image.network(
                                    widget.itemModel.thumbnailUrl[3])
                                : null,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            imageSelector = 4;
                            return takeImage(context, imageSelector);
                          },
                          child: CircleAvatar(
                            radius: screenSize.width * 0.1,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                file4 == null ? null : FileImage(file4),
                            child: file4 == null
                                ? Image.network(
                                    widget.itemModel.thumbnailUrl[4])
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Form(
                      key: _fromkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            specifer: 1,
                            controller: _nametextEditingController,
                            data: Icons.drive_file_rename_outline,
                            hintText: "title : ",
                            isObsecure: false,
                          ),
                          CustomTextField(
                            specifer: 1,
                            controller: _desicriptiontextEditingController,
                            data: Icons.description,
                            hintText: " description about Book :",
                            isObsecure: false,
                          ),
                          CustomTextField(
                            specifer: 0,
                            controller: _numberTextEditingController,
                            data: Icons.money,
                            hintText: "price : ",
                            isObsecure: false,
                          ),
                          CustomTextField(
                            specifer: 1,
                            controller: _statustextEditingController,
                            data: Icons.high_quality_sharp,
                            hintText: "Status(New or Used) : ",
                            isObsecure: true,
                          ),
                          Container(
                            color: Colors.white,
                            width: screenSize.width * 0.92,
                            height: screenSize.height * 0.1,
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on_outlined,
                                color: Colors.blue,
                              ),
                              title: Container(
                                width: 250.0,
                                child: DropdownButton(
                                  value: this.selectedCity,
                                  hint: Text(
                                    "City : ",
                                    style: TextStyle(color: Color(0xFFAA0601)),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Irbid"),
                                        ],
                                      ),
                                      value: "Irbid",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Amman"),
                                        ],
                                      ),
                                      value: "Amman",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Zarqa"),
                                        ],
                                      ),
                                      value: "Zarqa",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Jarash"),
                                        ],
                                      ),
                                      value: "Jarash",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Salt"),
                                        ],
                                      ),
                                      value: "Salt",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Ajloun"),
                                        ],
                                      ),
                                      value: "Ajloun",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Aqaba"),
                                        ],
                                      ),
                                      value: "Aqaba",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Madaba"),
                                        ],
                                      ),
                                      value: "Madaba",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Mafraq"),
                                        ],
                                      ),
                                      value: "Mafraq",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Karak"),
                                        ],
                                      ),
                                      value: "Karak",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Ma`an"),
                                        ],
                                      ),
                                      value: "Ma`an",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Tafila"),
                                        ],
                                      ),
                                      value: "Tafila",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("choice city :"),
                                        ],
                                      ),
                                      value: "choice city :",
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    city = value;
                                    setState(() {
                                      this.selectedCity = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Container(
                            color: Colors.white70,
                            width: screenSize.width * 0.92,
                            height: screenSize.height * 0.1,
                            child: ListTile(
                              leading: Icon(
                                Icons.category,
                                color: Colors.blue,
                              ),
                              title: Container(
                                width: 250.0,
                                child: DropdownButton(
                                  value: this.selectedCategory,
                                  hint: Text(
                                    "Category : ",
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.logout),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Science"),
                                        ],
                                      ),
                                      value: "Science",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Tawjihi"),
                                        ],
                                      ),
                                      value: "Tawjihi",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Novels"),
                                        ],
                                      ),
                                      value: "Novels",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("choice category :"),
                                        ],
                                      ),
                                      value: "choice category :",
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    category = value;
                                    setState(() {
                                      this.selectedCategory = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          Container(
                            color: Colors.white70,
                            width: screenSize.width * 0.92,
                            height: screenSize.height * 0.1,
                            child: ListTile(
                              leading: Icon(
                                Icons.link,
                                color: Colors.blue,
                              ),
                              title: Container(
                                width: 250.0,
                                child: DropdownButton(
                                  value: this.selectedPurpose,
                                  hint: Text(
                                    "purpose : ",
                                    style: TextStyle(color: Colors.pink),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.logout),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Sale"),
                                        ],
                                      ),
                                      value: "Sale",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Donation or Exchange"),
                                        ],
                                      ),
                                      value: "Donation or Exchange",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Donation"),
                                        ],
                                      ),
                                      value: "Donation",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Exchange"),
                                        ],
                                      ),
                                      value: "Exchange",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("Sale or Exchange "),
                                        ],
                                      ),
                                      value: "Sale or Exchange",
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Text("choice purpose :"),
                                        ],
                                      ),
                                      value: "choice purpose :",
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    purpose = value;
                                    setState(() {
                                      this.selectedPurpose = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deleteBook(widget.itemModel);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 9,
                            backgroundColor: Colors.lightBlueAccent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Delete Book',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.09,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            changeBookData(widget.itemModel);
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
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      height: 4.0,
                      width: screenSize.width * 0.8,
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(
                      height: 15.0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  takeImage(mContext, int imageSelector) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff122636), width: 4),
            borderRadius: BorderRadius.circular(150),
          ),
          title: Center(
            child: Text(
              "item Image :",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Center(
                child: Text("Capture With Camera",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: () => capturePhotoWithCamera(imageSelector),
            ),
            SimpleDialogOption(
              child: Center(
                child: Text("Select From Gallery",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: () => pickPhotoFromGallery(imageSelector),
            ),
            SimpleDialogOption(
              child: Center(
                child: Text("Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera(int imageSelector) async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      switch (imageSelector) {
        case 0:
          file = imageFile;
          break;

        case 1:
          file1 = imageFile;
          break;

        case 2:
          file2 = imageFile;
          break;

        case 3:
          file3 = imageFile;
          break;

        case 4:
          file4 = imageFile;
          break;
      }
    });
  }

  pickPhotoFromGallery(int imageSelector) async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      switch (imageSelector) {
        case 0:
          file = imageFile;
          break;

        case 1:
          file1 = imageFile;
          break;

        case 2:
          file2 = imageFile;
          break;

        case 3:
          file3 = imageFile;
          break;

        case 4:
          file4 = imageFile;
          break;
      }
    });
  }

  updatePhotoToFirebase(Book model, File image, File image1, File image2,
      File image3, File image4) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Books");

    if (image != null) {
      print(
          "image0.............................................................");
      StorageUploadTask uploadTask = storageReference
          .child("product_${model.bookId} 0.jpg")
          .putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      downloadUrl[0] = await taskSnapshot.ref.getDownloadURL();
    } else {
      downloadUrl[0] = model.thumbnailUrl[0];
    }
    if (image1 != null) {
      print(
          "image1.............................................................");

      StorageUploadTask uploadTask1 = storageReference
          .child("product_${model.bookId} 1.jpg")
          .putFile(image1);
      StorageTaskSnapshot taskSnapshot1 = await uploadTask1.onComplete;
      downloadUrl[1] = await taskSnapshot1.ref.getDownloadURL();
    } else {
      downloadUrl[1] = model.thumbnailUrl[1];
    }
    if (image2 != null) {
      print(
          "image2.............................................................");
      StorageUploadTask uploadTask2 = storageReference
          .child("product_${model.bookId} 2.jpg")
          .putFile(image2);
      StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
      downloadUrl[2] = await taskSnapshot2.ref.getDownloadURL();
    } else {
      downloadUrl[2] = model.thumbnailUrl[2];
    }

    if (image3 != null) {
      print(
          "image3.............................................................");

      StorageUploadTask uploadTask3 = storageReference
          .child("product_${model.bookId} 3.jpg")
          .putFile(image3);
      StorageTaskSnapshot taskSnapshot3 = await uploadTask3.onComplete;
      downloadUrl[3] = await taskSnapshot3.ref.getDownloadURL();
    } else {
      downloadUrl[3] = model.thumbnailUrl[3];
    }

    if (image4 != null) {
      print(
          "image4.............................................................");

      StorageUploadTask uploadTask4 = storageReference
          .child("product_${model.bookId} 4.jpg")
          .putFile(image4);
      StorageTaskSnapshot taskSnapshot4 = await uploadTask4.onComplete;
      downloadUrl[4] = await taskSnapshot4.ref.getDownloadURL();
    } else {
      downloadUrl[4] = model.thumbnailUrl[4];
    }

    Firestore.instance
        .collection("Books")
        .document(model.bookId)
        .updateData({'thumbnailUrl': downloadUrl})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    //print("done");
    //Navigator.pop(context);
  }

  changeBookData(Book model) async {
    // ignore: non_constant_identifier_names
    bool SignChange = false;

    if (file != null ||
        file1 != null ||
        file2 != null ||
        file3 != null ||
        file4 != null) {
      await updatePhotoToFirebase(model, file, file1, file2, file3, file4);
      SignChange = true;
    }

    if (_nametextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({
        'title': _nametextEditingController.text.toUpperCase(),
        "caseSearch":
            setSearchParam(_nametextEditingController.text.toUpperCase()),
      }).then((value) {
        SignChange = true;
        _nametextEditingController.clear();
        print("User Updated in fireStore");
      }).catchError((error) {
        SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }

    if (_desicriptiontextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({
        'description': _desicriptiontextEditingController.text
      }).then((value) {
        SignChange = true;
        _desicriptiontextEditingController.clear();
        print("User Updated in fireStore");
      }).catchError((error) {
        SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }

    if (_numberTextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({
        'price': int.parse(_numberTextEditingController.text),
      }).then((value) {
        SignChange = true;
        _numberTextEditingController.clear();
        print("User Updated in fireStore");
      }).catchError((error) {
        SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }

    if (_statustextEditingController.text.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({'status': _statustextEditingController.text}).then(
              (value) {
        SignChange = true;
        _statustextEditingController.clear();
        print("User Updated in fireStore");
      }).catchError((error) {
        SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }

    if (city.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({'city': city}).then((value) {
        // SignChange = true;
        print("User Updated in fireStore");
      }).catchError((error) {
        // SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }
    if (category.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({'category': category}).then((value) {
        //  SignChange = true;
        print("User Updated in fireStore");
      }).catchError((error) {
        //SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }
    if (purpose.isNotEmpty) {
      await Firestore.instance
          .collection("Books")
          .document(model.bookId)
          .updateData({'purpose': purpose}).then((value) {
        //  SignChange = true;
        print("User Updated in fireStore");
      }).catchError((error) {
        //SignChange = false;
        print("Failed to update user in firestore: $error");
      });
    }

    if (SignChange) {
      Fluttertoast.showToast(
        msg: "it\'s Done",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "Please fill some data .",
          );
        },
      );
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  deleteBook(Book model) async {
    await Firestore.instance
        .collection("Books")
        .document(model.bookId)
        .delete()
        .then((value) {
      print("User Updated in fireStore");
      Route route = MaterialPageRoute(builder: (context) => Home());
      Navigator.pushReplacement(context, route);
    }).catchError((error) {
      print("Failed to update user in firestore: $error");
    });
  }
}
