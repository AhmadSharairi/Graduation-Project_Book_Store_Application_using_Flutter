import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  //String searchKey;
  String purpose;
  String urlUser;
  String phoneNumber;
  String userUID;
  String bookId;
  String title;
  Timestamp publishedDate;
  List thumbnailUrl; //thumbnailUrl
  String description;
  String status;
  int price;
  String category;
  String city;
  String upperCaseTitle;
  String lowerCaseTitle;
  String newTitle;
  String userName;

  Book(
      {
        this.userName,
        this.urlUser,
        this.phoneNumber,
        this.bookId,
        this.userUID,
        this.newTitle,
        this.lowerCaseTitle,
        this.upperCaseTitle,
        this.title,
        this.publishedDate,
        this.thumbnailUrl,
        this.description,
        this.status,
        this.category,
        this.city,
        });

  Book.fromJson(Map<String, dynamic> json)
  {
    //String upperCaseTitle,lowerCaseTitle,newTitle;
    title = json['title'];
    upperCaseTitle=title.substring(0,1).toUpperCase();
    lowerCaseTitle=title.substring(1).toLowerCase();
    newTitle=upperCaseTitle+lowerCaseTitle;
    //searchKey=newTitle.substring(0,1);
    urlUser=json['urlUser'];
    userName=json['userName'];


    //shortInfo = json['shortInfo'];
    purpose= json['purpose'];
    bookId=json['bookId'];
    userUID=json['uid'];
    publishedDate = json['publishedDate'];
    phoneNumber = json['phoneNumber'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    status = json['status'];
    price = json['price'];
    category = json['category'];
    userName=json['userName'];
    city = json['city'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlUser']=this.urlUser;
    data['title'] = this.title;
    data['bookId']=this.bookId;
    data['purpose']=this.purpose;
    data['uid']=this.userUID;
    data['phoneNumber']=this.phoneNumber;

    // data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    data['category']=this.category;
    data['city']=this.city;

    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
