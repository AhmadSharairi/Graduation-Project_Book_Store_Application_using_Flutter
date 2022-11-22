import 'dart:io';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Models/BookPdf.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'pdfUpload.dart';

class pdfFiles extends StatefulWidget {
  @override
  pdfFilesState createState() => pdfFilesState();
}

class pdfFilesState extends State<pdfFiles> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //  width = MediaQuery.of(context).size.width;
    // height = MediaQuery.of(context).size.height;

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
          body: Column(
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
                      "Welcome To PDF Books",
                      emboss: false,
                      size: 25,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.025),
              Container(
                width: screenSize.width * 4.0,
                height: screenSize.height * 0.66,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  slivers: [
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection("BookPdf").snapshots(),
                      builder: (context, dataSnapShot) {
                        return !dataSnapShot.hasData
                            ? SliverToBoxAdapter(
                                child: Center(
                                    child: Text(
                                  "There are no PDF books",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.redAccent),
                                )),
                              )
                            : SliverStaggeredGrid.countBuilder(
                                crossAxisCount: 1,
                                staggeredTileBuilder: (c) =>
                                    StaggeredTile.fit(1),
                                itemBuilder: (context, index) {
                                  BookPdf model = BookPdf.fromJson(
                                      dataSnapShot.data.documents[index].data);
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => pdfUpload());
              Navigator.push(context, route);
            },
            child: Icon(Icons.picture_as_pdf_outlined //library_add
                ),
          ),
        ),
      ),
    );
  }
}

Widget sourceInfo(BookPdf book, BuildContext context) {
  var dio = Dio();
  Size sizeScreen = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.only(
        right: (20 / 375.0) * sizeScreen.width,
        left: (10 / 375.0) * sizeScreen.width), //(40 / 375.0)*sizeScreen.height
    child: SizedBox(
      height: sizeScreen.height * .6,
      child: GestureDetector(
        onTap: () async {
          String path = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          String fullPath = "$path/${book.name}.pdf";

          print(
              "herere................................................................................................");
          download2(dio, book.pdfUrl, fullPath);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all((10 / 375.0) * sizeScreen.width),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(book.urlPicture),
            ),
            //const SizedBox(height:3),
            Flexible(
              child: Text(
                book.name,
                //overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("users")
                      .where("uid", isEqualTo: book.uid)
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    if (!dataSnapShot.hasData) {
                      return CircularProgressIndicator();
                    }
                    DataUser user =
                        DataUser.fromJson(dataSnapShot.data.documents[0].data);
                    return Flexible(
                      child: Text(
                        user.Name,
                        style: TextStyle(
                          fontSize: (18 / 375.0) * sizeScreen.width,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future download2(Dio dio, String url, String savePath) async {
  //get pdf from link
  Response response = await dio.get(
    url,
    onReceiveProgress: showDownloadProgress,
    //Received data with List<int>
    options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        }),
  );

  //write in download folder
  File file = File(savePath);
  var raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();
}

showDownloadProgress(received, total) {
  if (total != -1) {
    String s1 = ((received / total * 100).toStringAsFixed(0) + "%");

    if (s1 == "100%")
      Fluttertoast.showToast(
        msg: "it\'s Downloaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightBlueAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
}
