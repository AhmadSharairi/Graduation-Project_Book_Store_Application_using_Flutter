import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Messager/chatScreen.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

class messagePage extends StatefulWidget {
  @override
  _messagePageState createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  Stream<QuerySnapshot> documnetList;

  // Stream chatRoomsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomsList();
  }

  bool isNotSearching = true;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
        child: MyDrawer(),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.message),
      appBar: AppBar(
        backgroundColor: Color(0xFF783201),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text("Message page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.6,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty)
                          isNotSearching = false;
                        else
                          isNotSearching = true;

                        initSearch(value);

                        setState(() {});
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search by name :"),
                    )),
                  ],
                ),
              ),
              if (isNotSearching == false)
                Container(
                  width: screenSize.width * 4.0,
                  height: screenSize.height * 0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [
                      StreamBuilder<QuerySnapshot>(
                        stream: documnetList,
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text(
                                        "There are no users",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.blue),
                                      ),
                                    ],
                                  )),
                                )
                              : SliverStaggeredGrid.countBuilder(
                                  crossAxisCount: 1,
                                  staggeredTileBuilder: (c) =>
                                      StaggeredTile.fit(1),
                                  itemBuilder: (context, index) {
                                    DataUser user = DataUser.fromJson(
                                        dataSnapShot.data.documents[index].data);
                                    return searchListUserTile(user, context);
                                  },
                                  itemCount: dataSnapShot.data.documents.length,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              if (isNotSearching) chatRoomsList(),
            ],
          ),
        ),
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

  Future initSearch(String query) async {
    String capitalizedValue = query.toUpperCase();

    documnetList = Firestore.instance
        .collection('users')
        .where('caseSearch', arrayContains: capitalizedValue)
        .snapshots();

    setState(() {});
  }

  Widget searchListUserTile(DataUser user, BuildContext context) {
    return GestureDetector(
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
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Hero(
              tag: user.uid,
              child: CircleAvatar(
                radius: 31.5,
                backgroundColor: Color(0xff122636),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(user.url),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(width: 12),
            Flexible(
                child: Text(
              user.Name,
              maxLines: 2,
            ))
          ],
        ),
      ),
    );
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

  Widget chatRoomsList() {
    print("chat room list ..........................................");

    return StreamBuilder(
      stream: Firestore.instance
          .collection("chatrooms")
          .orderBy("lastMessageSendTs", descending: true)
          .where("users", arrayContains: BookStoreUsers.sharedPreferences
                  .getString(BookStoreUsers.userUID))
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  if (ds['users'][0] ==
                      BookStoreUsers.sharedPreferences
                          .getString(BookStoreUsers.userUID))
                    return ChatRoomListTile(ds['users'][1], ds["lastMessage"],
                        ds['lastMessageSendBy']);
                  else
                    return ChatRoomListTile(ds['users'][0], ds["lastMessage"],
                        ds['lastMessageSendBy']);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}














class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, uid, lastMessageSendBy;

  ChatRoomListTile(
    this.uid,
    this.lastMessage,
    this.lastMessageSendBy,
  );

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl, hisName,nameTall;

  @override
  void initState() {
    //  getUserInfo();
    super.initState();


    // if(hisName.length>15)
    // {
    //   nameTall=hisName.substring(0,12);
    //   nameTall=nameTall+"...";
    // }
    // else
    //   nameTall=hisName;
    //



  }

  @override
  Widget build(BuildContext context) {
    print("I am now in build function for chat room list tile..............................................................................");
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .where("uid", isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, dataSnapShot) {
        if (dataSnapShot.hasData) {
          print("I am now in if statement function builder  for chat room list tile..............................................................................");
          DataUser user =
              DataUser.fromJson(dataSnapShot.data.documents[0].data);
          return smallPicture(user);
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Widget smallPicture(DataUser user) {
    String showTalk;

    if (widget.lastMessageSendBy ==
        BookStoreUsers.sharedPreferences.getString(BookStoreUsers.userName))
      showTalk = 'Me';
    else
      showTalk = widget.lastMessageSendBy.length>15?widget.lastMessageSendBy.substring(0,12)+"...":widget.lastMessageSendBy;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      hisName: user.Name,
                      profilePicUrl: user.url,
                      hisUid: widget.uid,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Hero(
              tag: user.Name,
              child: CircleAvatar(
                radius: 31.5,
                backgroundColor: Color(0xff122636),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(user.url),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),

            // ClipRRect(
            //   borderRadius: BorderRadius.circular(30),
            //   child: Image.network(
            //     profilePicUrl,
            //     height: 40,
            //     width: 40,
            //   ),
            // ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.Name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(showTalk + " : "),
                      Flexible(
                        child: Text(
                          widget.lastMessage,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
