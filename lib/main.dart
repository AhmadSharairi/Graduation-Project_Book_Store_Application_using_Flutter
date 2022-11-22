import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:gradproject/Config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode

  print(
      "getPermission,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.........................,,,,,,,,,,,,,");
  await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  BookStoreUsers.auth = FirebaseAuth.instance;
  BookStoreUsers.sharedPreferences = await SharedPreferences.getInstance();
  BookStoreUsers.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BookStore',
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DisplaySpalsh();
  }

  DisplaySpalsh() {
    Timer(Duration(seconds: 5), () async {
      if (await BookStoreUsers.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => Home());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 500.0,
        height: 600.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/welcome.jpg"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400.0,
              ),
              Text(
                "WELCOME TO THE BOOKSTORE",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 120,
                endIndent: 120,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
