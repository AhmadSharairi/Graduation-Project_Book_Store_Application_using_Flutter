import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';



class TawjihiPage extends StatefulWidget {
  @override
  _TawjihiPageState createState() => _TawjihiPageState();
}

class _TawjihiPageState extends State<TawjihiPage> {




  String selectedPurpose = "choice purpose :";
  String purpose = "";



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    //  width = MediaQuery.of(context).size.width;
    //  height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44),
                bottomRight: Radius.circular(44)),
            child: MyDrawer(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.025),
                ClayContainer(
                  color: Color(0xFFDC5F1C),
                  height: 95,
                  width: 390,
                  customBorderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(150, 150),
                    bottomLeft: Radius.circular(50),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ClayText(
                        "Welcome To Tawjihi Books",
                        emboss: false,
                        size: 25,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.025),

                ListTile(
                  leading: Icon(
                    Icons.link,
                    color: Colors.red,
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
                              Text("choice purpose :",
                                  style: TextStyle(color: Colors.red)),
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






                Container(
                  width: screenSize.width * 4.0,
                  height: screenSize.height * 0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [


                      if(purpose=="choice purpose :" || purpose.isEmpty)
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Books")
                              .where("category", isEqualTo: "Tawjihi")
                              .orderBy("publishedDate", descending: true)
                              .snapshots(),
                          builder: (context, dataSnapShot) {

                            return !dataSnapShot.hasData
                                ? SliverToBoxAdapter(
                              child: Center(
                                  child: Text(
                                    "There are no Tawjihi books",
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

                      if(selectedPurpose!="choice purpose :")
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Books")
                              .where('purpose',isEqualTo: purpose)
                              .where("category", isEqualTo: "Tawjihi")
                              .orderBy("publishedDate", descending: true)
                              .snapshots(),
                          builder: (context, dataSnapShot) {

                            return !dataSnapShot.hasData
                                ? SliverToBoxAdapter(
                              child: Center(
                                  child: Text(
                                    "There are no Tawjihi books",
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
        ),
      ),
    );
  }
}
