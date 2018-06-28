import 'package:flutter/material.dart';
import 'package:daily_purify/pages/home_page.dart';
import 'package:daily_purify/common/routes_name.dart';
import 'package:daily_purify/pages/Login_page.dart';

void main() {
  runApp(new MaterialApp(
      routes: <String, WidgetBuilder>{
        RoutesName.routesHomePage: (BuildContext context) => new HomePage(),
        RoutesName.routesRegistPage: (BuildContext context) => new LoginPage(),
      },
      home: new HomePage()));
}
