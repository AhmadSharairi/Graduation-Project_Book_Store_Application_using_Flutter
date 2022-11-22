import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Config/config.dart';
import '../Widgets/myDrawer.dart';
import '../Models/Book.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  String city = "";
  String category = "";
  String selectedCity = "choice city :";
  String selectedCategory = "choice category :";

  Stream<QuerySnapshot> documnetList;

  Future initSearch(String query,String city,String category) async {
    String capitalizedValue = query.toUpperCase();


    if (category.isNotEmpty && category != "choice category :"
        && city.isNotEmpty && city != "choice city :")
    {
      print(
          "........................................................... just city and category");

      documnetList = Firestore.instance
          .collection('Books')
          .where("city", isEqualTo: city)
          .where("category", isEqualTo: category)
          .snapshots();
    }

    else if (city.isNotEmpty && city != "choice city :")
    {
      print("........................................................... just city $capitalizedValue");

      documnetList = Firestore.instance
          .collection('Books')
          .where("city", isEqualTo: city)
          .snapshots();
    }

    else if (category.isNotEmpty && category != "choice category :")
      {
      print("........................................................... just name category");

      documnetList = Firestore.instance
          .collection('Books')
          .where("category", isEqualTo: category)
          .snapshots();
    }

    else if (category.isEmpty || category == "choice category :" || city.isEmpty || city != "choice city :")
      {
      print("........................................................... nothing");
      documnetList = Firestore.instance
          .collection('Books')

          .where('caseSearch', arrayContains: capitalizedValue)
          .snapshots();
    }









    setState(() {});
  }


  final TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //  width = MediaQuery.of(context).size.width;
    // height = MediaQuery.of(context).size.height;
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Search Page"),
            centerTitle: true,
            actions: [
              Container(
                width: screenSize.width * 0.15,
                height: screenSize.height * 0.01,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("users")
                      .where("uid",
                          isEqualTo: BookStoreUsers.sharedPreferences
                              .getString(BookStoreUsers.userUID))
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    if (!dataSnapShot.hasData) {
                      return CircularProgressIndicator();
                    }
                    DataUser user =
                        DataUser.fromJson(dataSnapShot.data.documents[0].data);
                    return smallPicture(user, context);
                  },
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.07,
              ),
            ],
            backgroundColor: Color(0xFF783201),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
          ),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44),
                bottomRight: Radius.circular(44)),
            child: MyDrawer(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all(
                      (Radius.circular(30.0)),
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.blue,
                      ),
                      hintText: "Search here by title  :",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2.0,
                            style: BorderStyle.solid),
                      ),
                    ),
                    // onChanged: (value) {
                    //   //capitalizedValue=value.toUpperCase();
                    //   initSearch(value);
                    // },
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
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
                          style: TextStyle(color: Colors.pink),
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
                  height: screenSize.height * 0.01,
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
                  height: screenSize.height * 0.01,
                ),
                SizedBox(height: screenSize.height * 0.001),

                ElevatedButton(
                  onPressed: () {
                    initSearch(searchController.text,city=='choice city :'?"":city,category=='choice category :'?"":category);
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
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),





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
                                      child: Text(
                                    "There are no books!",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.blue),
                                  )),
                                )
                              : SliverStaggeredGrid.countBuilder(
                                  crossAxisCount: 1,
                                  staggeredTileBuilder: (c) =>
                                      StaggeredTile.fit(1),
                                  itemBuilder: (context, index) {
                                    Book model = Book.fromJson(dataSnapShot
                                        .data.documents[index].data);
                                    return sourceInfo(model, context);
                                  },
                                  itemCount: dataSnapShot.data.documents.length,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              CustomBottomNavBar(selectedMenu: MenuState.search),
        ),
      ),
    );
  }
}
