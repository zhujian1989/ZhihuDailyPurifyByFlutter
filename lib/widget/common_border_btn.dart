import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  final String btnName;
  final double btnHeight;
  final MaterialColor btnBorderColor;
  final double circular;
  final double fontSize;

  BorderButton(
      this.btnName, this.btnHeight, this.btnBorderColor, this.fontSize,this.circular);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      height: btnHeight,
      decoration: new BoxDecoration(
        border: new Border.all(
          width: 1.0,
          color: Colors.blue,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(circular)),
      ),
      child: new Text(
        btnName,
        style: new TextStyle(fontSize: fontSize),
      ),
    );
  }
}
