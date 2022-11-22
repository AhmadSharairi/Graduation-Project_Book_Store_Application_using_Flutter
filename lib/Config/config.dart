import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookStoreUsers {
  static const String appName = 'BookStore';

  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore;

  static bool see = false;

  static int transporterNovels = 0;
  static int numberNovels = 0;
  //static bool enter=false;

  static final String userName = 'name';
  static final String bookId = 'bookId';
  static final String userEmail = 'email';
  //static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';
  static final String phoneNumber = "phoneNumber";
  static final String userPassword = "password";

  //static final

}
