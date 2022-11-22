import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  //final String value1;
//  Function onChangedData;
  final int specifer;
  final IconData data;
  final String hintText;
  bool isObsecure = true;

  CustomTextField(
      {Key key,
      this.controller,
      this.specifer,
      this.data,
      this.hintText,
      this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          (Radius.circular(30.0)),
        ),
      ),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: specifer == 1 ? TextInputType.text : TextInputType.phone,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: isObsecure,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
