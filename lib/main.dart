import 'package:flutter/material.dart';
import 'package:daily_purify/pages/HomePage.dart';
import 'package:daily_purify/common/RoutesName.dart';
void main() {
  runApp(new MaterialApp(
      routes: <String, WidgetBuilder>{
        RoutesName.routesHomePage: (BuildContext context) => new HomePage(),
        },
      home: new HomePage()));
}
