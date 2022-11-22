import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradproject/Book_Details/BookModificationPage.dart';
import 'package:gradproject/Book_Details/picturePage.dart';
import 'package:gradproject/Messager/chatScreen.dart';

class ProductPage extends StatefulWidget {
  final Book BookModel;
  ProductPage({this.BookModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final ItemModel itemModel;
  //
  // _ProductPageState(this.itemModel);

  // int quantityOfItem = 1;
  String s1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //s1=widget.itemModel.bookId.toString();
    // print("okhuyigutfdytrdsrtezarwarestrydfufgiuhiuhguiyftdyt"+s1);
    modification(widget.BookModel);
  }

  bool showNumber = false;

  bool showButton = false;
  @override
  Widget build(BuildContext context) {
    //  ItemModel userUID=widget.itemModel.userUID as ItemModel;
    // String s=userUID.toString();
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
          body: ListView(
            children: [
              ProductImages(book: widget.BookModel),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: (20 / 375.0) * screenSize.width,
                          ),
                          child: Center(
                            child: Text(
                              widget.BookModel.newTitle,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.watch_later_outlined,
                            color: Color(0xff122636),
                          ),
                          title: Text(
                            (DateFormat("d/M/y :")
                                .add_jm()
                                .format(widget.BookModel.publishedDate.toDate())
                                .toString()),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff122636),
                            ),
                          ),
                        ),
                        ListTile(
                          subtitle: Text(
                            widget.BookModel.description,
                            maxLines: 4,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          leading: Icon(
                            Icons.description,
                            color: Colors.blue,
                          ),
                          title: Text(
                            "Description :",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                            subtitle: Text(
                              widget.BookModel.city,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                            ),
                            title: Text(
                              "City :",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money_outlined,
                            color: Colors.blue,
                          ),
                          subtitle: Text(
                            widget.BookModel.price.toString() + " JD",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          title: Text(
                            "Price:",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                            leading: Icon(
                              Icons.category,
                              color: Colors.blue,
                            ),
                            subtitle: Text(
                              widget.BookModel.category,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            title: Text(
                              "Category :",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                          leading: Icon(
                            Icons.high_quality_outlined,
                            color: Colors.blue,
                          ),
                          subtitle: Text(
                            widget.BookModel.status,
                            style: TextStyle(fontSize: 20.0),
                            maxLines: 1,
                          ),
                          title: Text(
                            "Status:",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.description,
                              color: Colors.blue,
                            ),
                            subtitle: Text(
                              widget.BookModel.purpose,
                              maxLines: 4,
                            ),
                            title: Text(
                              "Purpose:",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("users")
                              .where("uid", isEqualTo: widget.BookModel.userUID)
                              .snapshots(),
                          builder: (context, dataSnapShot) {
                            if (!dataSnapShot.hasData) {
                              return CircularProgressIndicator();
                            }
                            DataUser user = DataUser.fromJson(
                                dataSnapShot.data.documents[0].data);
                            return userInfo(user, context);
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showNumber = true;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Communicate Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Visibility(
            visible: showButton,
            child: FloatingActionButton(
              backgroundColor: Color(0xff122636),
              onPressed: () {
                modification(widget.BookModel);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookModificationPage(itemModel: widget.BookModel),
                  ),
                );
              },
              // tooltip: 'Increment',
              child: Icon(Icons.settings),
            ),
          ),
        ),
      ),
    );
  }

  modification(Book model) {
    if (BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userUID) ==
        model.userUID)
      setState(() {
        showButton = true;
      });
  }

  Widget userInfo(DataUser user, BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Visibility(
      visible: showNumber,
      child: Container(
        height: screenSize.height * 0.22,
        width: screenSize.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Visibility(
            visible: showNumber,
            child: ListTile(
              leading: Icon(
                Icons.phone_outlined,
                color: Colors.red,
              ),
              title: Text(
                user.phoneNumber,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          Visibility(
            visible: showNumber,
            child: InkWell(


              onTap: () {
                  var chatRoomId = getChatRoomIdByUsernames(
                      BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userUID),
                      user.uid);
                  Map<String, dynamic> chatRoomInformation = {
                    "users": [
                      BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userUID),
                      user.uid
                    ]
                  };
                  createChatRoom(chatRoomId, chatRoomInformation);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              hisName: user.Name,
                              profilePicUrl: user.url,
                              hisUid: user.uid)));

              },
              child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(user.Name),
                  subtitle: Text("Click here to talk "),
                  leading: Container(
                    width: 49,
                    height: 45,
                    child: Hero(
                      tag: user.Name,
                      child: CircleAvatar(
                        radius: 31,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 33.0,
                          backgroundImage: NetworkImage(user.url),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  getChatRoomIdByUsernames(String myName, String hisName) {
    if (myName.substring(0, 1).codeUnitAt(0) >
        hisName.substring(0, 1).codeUnitAt(0)) {
      return "$hisName\_$myName";
    } else {
      return "$myName\_$hisName";
    }
  }

  createChatRoom(String chatRoomId, Map chatRoomInformation) async {
    final snapShot = await Firestore.instance
        .collection("chatrooms")
        .document(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists it dont need build new one
      return true;
    }
    else
    {
      // chatroom does not exists let is build one
      return Firestore.instance
          .collection("chatrooms")
          .document(chatRoomId)
          .setData(chatRoomInformation);
    }
  }
}
