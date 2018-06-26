import 'package:flutter/material.dart';

const String wx = '微信好友';
const String wx_circle = '微信朋友圈';
const String sina = '新浪微博';
const String msg = '短信';
//const String qq = 'QQ好友';
//const String q_zone = 'QQ空间';
//const String copy_url = '复制链接';
//const String browser = '浏览器打开';

class Menu {
  final String title;
  final String icon;

  const Menu({this.title, this.icon});
}

const List<Menu> menus = const <Menu>[
  const Menu(title: wx, icon: "images/icon_wx.png"),
  const Menu(title: wx_circle, icon: "images/icon_circle.png"),
  const Menu(title: sina, icon: "images/icon_sina.png"),
  const Menu(title: msg, icon: "images/icon_msg.png"),
];

class CommonShare {
  static buildShareBottomPop(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
              height: 120.0,
              color: Colors.white,
              child: new GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                children: menus.map((Menu m) {
                  return new GestureDetector(
                    onTap: () {},
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: new Image.asset(
                              m.icon,
                              width: 40.0,
                              height: 40.0,
                            )),
                        new Text(m.title),
                      ],
                    ),
                  );
                }).toList(),
              ));
        });
  }
}
