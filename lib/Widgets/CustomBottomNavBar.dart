import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profilePage.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/upload/uploadBook.dart';
import 'package:gradproject/Messager/messagePage.dart';

enum MenuState { Home, Upload, search, message, profile, logout }

class CustomBottomNavBar extends StatelessWidget {
  // DataUser user;

  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFF783201),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.house_outlined,
                    size: 33,
                    color: MenuState.Home == selectedMenu
                        ? Colors.black
                        : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  }),
              IconButton(
                icon: Icon(
                  Icons.upload_outlined,
                  size: 33,
                  color: MenuState.Upload == selectedMenu
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => UploadPage());
                  Navigator.push(context, route);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.message_outlined,
                  size: 33,
                  color: MenuState.message == selectedMenu
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (c) => messagePage());
                  Navigator.push(context, route);
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .where("uid",
                        isEqualTo: BookStoreUsers.sharedPreferences
                            .getString(BookStoreUsers.userUID))
                    .snapshots(),
                builder: (context, dataSnapShot) {
                  if (!dataSnapShot.hasData) {
                    return Icon(Icons.airplanemode_active);
                  }
                  DataUser user =
                      DataUser.fromJson(dataSnapShot.data.documents[0].data);
                  return IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      size: 33,
                      color: MenuState.profile == selectedMenu
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => profilePage(user: user));
                      Navigator.push(context, route);
                    },
                  );

                  //profilePage(user, context);
                },
              ),
            ],
          )),
    );
  }
}
