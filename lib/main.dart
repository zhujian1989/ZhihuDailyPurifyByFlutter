import 'package:flutter/material.dart';
import 'package:daily_purify/pages/home_page.dart';
import 'package:daily_purify/common/routes_name.dart';
void main() {
  runApp(new MaterialApp(
      routes: <String, WidgetBuilder>{
        RoutesName.routesHomePage: (BuildContext context) => new HomePage(),
        },
      home: new HomePage()));
}
