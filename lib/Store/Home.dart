import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Models/section_title.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Store/MyBook.dart';
import 'package:gradproject/Store/NovelPage.dart';
import 'package:gradproject/Store/TawjihiPage.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import '../Book_Details/product_page.dart';
import '../Book_Pdf/pdfFiles.dart';
import '../Widgets/loadingWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),
        ),
        backgroundColor: Color(0xFFF8F3F0),
        body: SingleChildScrollView(
            child: Column(children: [
          // SizedBox(height: screenSize.height*0.01,),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: (20)),
            child: SectionTitle(
              color: Color(0xff122636),
              title: " The Readers :",
              press: () {},
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.14,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              slivers: [
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("users").snapshots(),
                  builder: (context, dataSnapShot) {
                    return !dataSnapShot.hasData
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: circularProgress(),
                            ),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              DataUser user = DataUser.fromJson(
                                  dataSnapShot.data.documents[index].data);
                              return DisplayForUser(user, context);
                            },
                            itemCount: dataSnapShot.data.documents.length,
                          );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: (5)),
          Column(
            children: [
              // SizedBox(height: screenSize.height*0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: (20)),
                child: SectionTitle(
                  color: Color(0xff122636),
                  title: "Category :",
                  press: () {},
                ),
              ),
              SizedBox(height: (5)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SpecialOfferCard(
                      image: "images/Image Banner 3.png",
                      category: "Science",
                      press: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => SciencePage());
                        Navigator.push(context, route);
                      },
                    ),
                    SpecialOfferCard(
                      image: "images/Image Banner 2.jpg",
                      category: "Novels",
                      press: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => NovelsPage());
                        Navigator.push(context, route);
                      },
                    ),
                    SpecialOfferCard(
                      image: "images/Image Banner 4.PNG",
                      category: "Tawjihi",
                      press: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => TawjihiPage());
                        Navigator.push(context, route);
                      },
                    ),
                    SpecialOfferCard(
                      image: "images/Image Banner 5.png",
                      category: "PDF",
                      press: () {
                        Route route =
                            MaterialPageRoute(builder: (context) => pdfFiles());
                        Navigator.push(context, route);

                        print(
                            "height: $screenSize.height ................. width :$screenSize.width");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: (15)),
          Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (20)),
              child: SectionTitle(
                  title: "Recent Books :", color: Colors.black, press: () {}),
            ),
            SizedBox(
              height: 7,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (0)),
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.30,
                child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    slivers: [
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Books")
                            .limit(6)
                            .orderBy("publishedDate", descending: true)
                            .snapshots(),
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: circularProgress(),
                                  ),
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
                    ]),
              ),
            ),
          ]),
        ])),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.Home),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget DisplayForUser(DataUser dataUser, BuildContext context) {
  return InkWell(
    onTap: () {
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyBook(dataUser: dataUser)));
    },
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 39.0,
            backgroundColor: Color(0xff122636),
            child: CircleAvatar(
              radius: 37.0,
              backgroundImage: NetworkImage(dataUser.url),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(
            //width: screenSize.width-100,
            child: Text(
              dataUser.Name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget sourceInfo(Book book, BuildContext context) {
  Size sizeScreen = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.only(
        right: (20 / 375.0) * sizeScreen.width,
        left: (10 / 375.0) * sizeScreen.width), //(40 / 375.0)*sizeScreen.height
    child: SizedBox(
      height: sizeScreen.height * 0.6,
      child: GestureDetector(
        onTap: () {
          Route route =
              MaterialPageRoute(builder: (c) => ProductPage(BookModel: book));
          Navigator.push(context, route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Color(0xFFDC5F1F),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Hero(
                  tag: book.bookId.toString(),
                  child: Image.network(book.thumbnailUrl[0]),
                ),
              ),
            ),
            //const SizedBox(height:3),
            Text(
              book.newTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xff122636)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  book.city,
                  style: TextStyle(
                    fontSize: (18 / 375.0) * sizeScreen.width,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  book.price.toString() + " JD",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF820120)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.category,
    @required this.image,
    @required this.press,
  }) : super(key: key);

  final String category, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: (242),
          height: (100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (15.0),
                    vertical: (10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: (18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
