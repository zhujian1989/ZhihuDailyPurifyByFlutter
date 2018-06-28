import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/cache_util.dart';
import 'package:daily_purify/Utils/route_util.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/theme_model.dart';
import 'package:daily_purify/mvp/presenter/theme_presenter.dart';
import 'package:daily_purify/mvp/presenter/theme_presenter_impl.dart';
import 'package:daily_purify/widget/common_loading_dialog.dart';
import 'package:daily_purify/widget/common_retry.dart';
import 'package:daily_purify/widget/common_snakeBar.dart';
import 'package:flutter/material.dart';

class DrawerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _DrawerBodyState view = new _DrawerBodyState();
    ThemePresenter presenter = new ThemePresenterImpl(view);
    presenter.init();
    return view;
  }
}

class _DrawerBodyState extends State<DrawerBody> implements ThemeView {
  String _name = 'jzhu';

  ThemePresenter _themePresenter;

  List<ThemeModel> _themeList = [];

  bool _isShowRetry = false;

  @override
  void initState() {
    super.initState();

    //由于每次进入drawer都会刷新，所以先做个简单的缓存，这个列表不会出现经常发生变化
    _themeList = CacheUtil.getInstance().getThemeListCache();

    if (null != _themeList && _themeList.isNotEmpty) {
      return;
    }

    _loadData();
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    _themePresenter?.loadThemes();

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  Widget _buildDrawer() {
    return new UserAccountsDrawerHeader(
      onDetailsPressed: (){

      },
      accountName: new Text('$_name'),
      accountEmail: new Text('370159662@qq.com'),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: new NetworkImage(
            'http://n.sinaimg.cn/translate/20170726/Zjd3-fyiiahz2863063.jpg'),
      ),
    );
  }

  Widget _buildHomeItem() {
    return new InkWell(
      onTap: () {
        Navigator.of(context).pop();
        RouteUtil.route2Home(context);
      },
      child: new Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: new Row(
            children: <Widget>[
              new Icon(Icons.home, color: Colors.blue, size: 36.0),
              new Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: new Text('首页',
                      style:
                          new TextStyle(color: Colors.blue, fontSize: 18.0))),
            ],
          )),
    );
  }

  Widget _buildOtherItem(ThemeModel model) {
    return new InkWell(
      onTap: () {
        Navigator.of(context).pop();
        RouteUtil.route2ThemeList(context, '${model.id}');
      },
      child: new ListTile(
        trailing: new Icon(Icons.keyboard_arrow_right),
        title: new Text('${model.name}',
            style: new TextStyle(color: Colors.grey[700], fontSize: 18.0)),
      ),
    );
  }

  Widget _buildList(){
    return new MediaQuery.removePadding(
      context: context,
      // DrawerHeader consumes top MediaQuery padding.
      removeTop: true,
      child: new Expanded(
          child: new ListView(
            children: <Widget>[
              new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _themeList.map((ThemeModel model) {
                  return _buildOtherItem(model);
                }).toList(),
              ),
            ],
          )),
    );
  }


  Widget _buildBody() {
    if (null != _themeList && _themeList.isNotEmpty) {
      return new Column(
        children: <Widget>[
          _buildDrawer(),
          _buildHomeItem(),
          new Divider(height: 1.0),
          _buildList()
        ],
      );
    } else {

      var content ;

      if (_isShowRetry) {
        _isShowRetry = false;
        content = CommonRetry.buildRetry(_loadData);
      } else {
        content = ProgressDialog.buildProgressDialog();
      }

      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  @override
  void onLoadThemesFail() {
    _isShowRetry = true;
  }

  @override
  void onLoadThemesSuc(BaseModel<List<ThemeModel>> model) {
    if (model.code != HttpStatus.OK) {
      _isShowRetry = true;
      return;
    }

    _themeList = model.data;

    CacheUtil.getInstance().setThemeListCache(_themeList);

    setState(() {});
  }

  @override
  setPresenter(ThemePresenter presenter) {
    _themePresenter = presenter;
  }
}

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new DrawerBody(),
    );
  }
}
