import 'package:flutter/material.dart';


class CommonSnakeBar{
  static  buildSnakeBar(BuildContext context,String str) {
    final snackBar = new SnackBar(content: new Text(str));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

