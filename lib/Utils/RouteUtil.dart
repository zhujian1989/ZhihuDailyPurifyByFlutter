
import 'package:daily_purify/pages/CommentPage.dart';
import 'package:flutter/material.dart';
import 'package:daily_purify/widget/CommonWebView.dart';
import 'package:daily_purify/Utils/FixUrlUtil.dart';
import 'package:daily_purify/pages/StoryDetailPage.dart';
import 'package:daily_purify/pages/HomePage.dart';
import 'package:daily_purify/pages/ThemeListPage.dart';

class RouteUtil{

  static route2Web(BuildContext context, String title, String url) {
    if(null == url){
      return;
    }
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CommonWebView(title, FixUrlUtil.getFixUrl(url));
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  static route2Detail(BuildContext context, String id) {
    if(null == id){
      return;
    }
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new StoryDetailAppPage(id);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  static route2Home(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new HomePage();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }

  static route2ThemeList(BuildContext context,String themeId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ThemeListPage(themeId);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }


  static route2Comment(BuildContext context,String themeId) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new CommentPage(themeId);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new FadeTransition(
              opacity:
              new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }));
  }


}
