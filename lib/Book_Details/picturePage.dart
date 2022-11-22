import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Models/Book.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.book,
  }) : super(key: key);

  final Book book;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          width: (238 / 375.0) * screenSize.width,
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              child: Hero(
                tag: widget.book.bookId.toString(),
                child: Image.network(widget.book.thumbnailUrl[selectedImage]),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return DetailScreen(
                      book: widget.book, selectedImage: selectedImage);
                }));
              },
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.book.thumbnailUrl.length,
                (index) => buildSmallProductPreview(index, context)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index, BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: (48 / 375.0) * screenSize.width,
        width: (48 / 375.0) * screenSize.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.black.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.book.thumbnailUrl[index]),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key key,
    @required this.book,
    @required this.selectedImage,
  }) : super(key: key);

  final Book book;
  final int selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: book.bookId.toString(),
            child: Image.network(book.thumbnailUrl[selectedImage]),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
