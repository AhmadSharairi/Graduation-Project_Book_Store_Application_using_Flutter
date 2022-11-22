import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  String hisName;
  String profilePicUrl;
  String hisUid;
  ChatScreen({this.hisName, this.profilePicUrl, this.hisUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextEdittingController = TextEditingController();
  String chatRoomId, messageId = "";
  Stream messageStream;
  File file;
  String messagePictureUrl;
String nameTall;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatRoomId = getChatRoomIdByUsernames(
        BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userUID),
        widget.hisUid);
    chatMessages();
    print(chatRoomId +
        "...................................................................................................");
    //getAndSetMessages();
  
  if(widget.hisName.length>15)
   {
     nameTall=widget.hisName.substring(0,12);
  nameTall=nameTall+"....";
   }
  else
    nameTall=widget.hisName;

  }

  getChatRoomIdByUsernames(String myName, String hisName) {
    if (myName.substring(0, 1).codeUnitAt(0) >
        hisName.substring(0, 1).codeUnitAt(0)) {
      return "$hisName\_$myName";
    } else {
      return "$myName\_$hisName";
    }
  }

  bool tapped = false;
  bool tapped1 = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
        child: MyDrawer(),
      ),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          Row(children: [
            //SizedBox(width: screenSize.width*0.15,),
            Hero(
              tag: widget.hisUid,
              child: CircleAvatar(
                radius: 26.5,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(widget.profilePicUrl),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.01,
            ),
            Center(
              child: Text(
              nameTall,
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.3,
            ),
          ]),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                // color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        takeImage(context);
                        // chatMessages();
                      },
                      onTapDown: (_) {
                        setState(() {
                          tapped1 = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          tapped1 = false;
                        });
                      },
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: tapped1 ? Colors.deepPurple : Colors.blueAccent,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 0.6,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: messageTextEdittingController,
                        onChanged: (value) {},
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type a message..",
                            hintStyle: TextStyle(
                                color: Colors.blueAccent.withOpacity(0.6))),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                        // chatMessages();
                      },
                      onTapDown: (_) {
                        setState(() {
                          tapped = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          tapped = false;
                        });
                      },
                      child: Icon(Icons.send,
                          color:
                              tapped ? Colors.deepPurple : Colors.blueAccent),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatMessages() {
    print(
        "hi ...............................................c00000000000000000000000...................................");

    return StreamBuilder(
      stream: Firestore.instance
          .collection("chatrooms")
          .document(chatRoomId)
          .collection("chats")
          .orderBy("ts", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.documents.length,
                reverse: true,
                itemBuilder: (context, index) {
                  print(
                      "hi ...............................................chatMessages....................................");
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return chatMessageTile(
                      ds['imgUrl'],
                      ds["message"],
                      BookStoreUsers.sharedPreferences
                              .getString(BookStoreUsers.userName) ==
                          ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget chatMessageTile(
    String pictureUrl,
    String message,
    bool sendByMe,
  ) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            message == ("picture sended")
                ? SizedBox(
                    height: screenSize.height * .5,
                  )
                : Text(""),
            SizedBox(
              height: screenSize.height * 0.05,
            ),
            sendByMe
                ? Text("")
                : CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(widget.profilePicUrl),
                    backgroundColor: Colors.transparent,
                  ),
          ],
        ),

        Flexible(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight:
                          sendByMe ? Radius.circular(0) : Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft:
                          sendByMe ? Radius.circular(24) : Radius.circular(0),
                    ),
                    color: message == 'picture sended'
                        ? Colors.white
                        : sendByMe
                            ? Colors.blue
                            : Colors.blueGrey,
                  ),
                  padding: EdgeInsets.all(10),
                  child: message == 'picture sended'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailScreen(profilePic: pictureUrl);
                              }));
                            },
                            child: Hero(
                              tag: pictureUrl.toString(),
                              child: Image.network(
                                pictureUrl,
                                height: screenSize.height * 0.5,
                                width: screenSize.width * 0.7,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          message,
                          style: TextStyle(color: Colors.white),
                        )),
            ],
          ),
        ),
        // ignore: unrelated_type_equality_checks
      ],
    );
  }

  takeImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff122636), width: 4),
            borderRadius: BorderRadius.circular(150),
          ),
          title: Center(
            child: Text(
              "Select Options :",
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
              onPressed: () => capturePhotoWithCamera(),
            ),
            SimpleDialogOption(
              child: Center(
                child: Text("Select From Gallery",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: () => pickPhotoFromGallery(),
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

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });

    if (file != null) updateToFirebase();
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });

    if (file != null) updateToFirebase();
  }

  updateToFirebase() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Upload Photo ....",
          );
        });
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("PictureMessages");
    String messagepicureId = (randomAlphaNumeric(12)).toString();

    print(
        "image0.............................................................");
    StorageUploadTask uploadTask =
        storageReference.child("message $messagepicureId .jpg").putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    messagePictureUrl = await taskSnapshot.ref.getDownloadURL();

    addMessagePicture();
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      Firestore.instance
          .collection("chatrooms")
          .document(chatRoomId)
          .collection("chats")
          .document(messageId)
          .setData({
        "message": message,
        "sendBy":
            BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userName),
        "ts": lastMessageTs,
        "imgUrl": messagePictureUrl,
      }).then((value) {
        Firestore.instance
            .collection("chatrooms")
            .document(chatRoomId)
            .updateData({
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": BookStoreUsers.sharedPreferences
              .getString(BookStoreUsers.userName),
        });

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.clear();
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  addMessagePicture() async {
    var lastMessageTs = DateTime.now();

    if (messageId == "") {
      messageId = randomAlphaNumeric(12);
    }

    await Firestore.instance
        .collection("chatrooms")
        .document(chatRoomId)
        .collection("chats")
        .document(messageId + DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      "message": 'picture sended',
      "sendBy":
          BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userName),
      "ts": lastMessageTs,
      "imgUrl": messagePictureUrl,
    }).then((value) async {
      await Firestore.instance
          .collection("chatrooms")
          .document(chatRoomId)
          .updateData({
        "lastMessage": 'picture sended',
        "lastMessageSendTs": lastMessageTs,
        "lastMessageSendBy":
            BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userName),
      });
    });
    Navigator.pop(context);
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key key,
    @required this.profilePic,
  }) : super(key: key);

  final String profilePic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: profilePic.toString(),
            child: Image.network(profilePic),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
