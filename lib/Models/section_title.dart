import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final Color color;
  const SectionTitle({
    Key key,
    @required this.title,
    this.color,
    @required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: (18),
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }
}
