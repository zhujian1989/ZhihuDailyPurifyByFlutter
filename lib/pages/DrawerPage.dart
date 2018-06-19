import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/RouteUtil.dart';
import 'package:daily_purify/Utils/SPUtil.dart';
import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/ThemeModel.dart';
import 'package:daily_purify/mvp/presenter/ThemePresenter.dart';
import 'package:daily_purify/mvp/presenter/ThemePresenterImpl.dart';
import 'package:daily_purify/widget/CommonDivider.dart';
import 'package:daily_purify/widget/CommonLoadingDialog.dart';
import 'package:daily_purify/widget/CommonSnakeBar.dart';
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

  List<Widget> _themeWidgetList = [];

  List<ThemeModel> _themeList = [];

  List<String> _localCollectThemes = [];

  @override
  void initState() {
    super.initState();
    SPUtil.getStringList(Constant.spCollectThemes).then((list) {
      if (null != list && list.isNotEmpty) {
        _localCollectThemes = list;
      }
    }).catchError(print);
    _loadData();
  }

  Future<Null> _loadData() {
    final Completer<Null> completer = new Completer<Null>();

    _themePresenter?.loadThemes();

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  bool _isCollectTheme(String id) {
    SPUtil.getStringList(Constant.spCollectThemes).then((list) {
      if (null != list && list.isNotEmpty) {
        _localCollectThemes = list;
      }
    }).catchError(print);

    if (null != _localCollectThemes && _localCollectThemes.isNotEmpty) {
      if (_localCollectThemes.contains(id)) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  _collectTheme(String id) {
    SPUtil.getStringList(Constant.spCollectThemes).then((list) {
      if (null != list && list.isNotEmpty) {
        _localCollectThemes = list;
      }
    }).catchError(print);

    if (_isCollectTheme(id)) {
      _localCollectThemes.remove(id);
    } else {
      _localCollectThemes.add(id);
    }

    SPUtil.setStringList(Constant.spCollectThemes, _localCollectThemes);

    _refreshItems();
  }

  _refreshItems() {
    _themeWidgetList.clear();

    _themeWidgetList.add(_buildDrawer());
    _themeWidgetList.add(_buildHomeItem());
    _themeWidgetList.add(CommonDivider.buildDivider());

    for (ThemeModel model in _themeList) {
      _themeWidgetList.add(_buildOtherItem(model));
      _themeWidgetList.add(CommonDivider.buildDivider());
    }

    setState(() {});
  }

  Widget _buildDrawer() {
    print('_buildDrawer');
    return new UserAccountsDrawerHeader(
      accountName: new Text('$_name'),
      accountEmail: new Text('370159662@qq.com'),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: new NetworkImage(
            'http://n.sinaimg.cn/translate/20170726/Zjd3-fyiiahz2863063.jpg'),
      ),
    );
  }

  Widget _buildHomeItem() {
    print('_buildHomeItem');
    return new InkWell(
      onTap: () {
        Navigator.of(context).pop();
        RouteUtil.route2Home(context);
      },
      child: new Padding(
          padding: const EdgeInsets.only(
              left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
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
    print('_buildOtherItem');
//    bool b = _isCollectTheme('${model.id}');
//    print('${model.id}: $b');
    return new InkWell(
      onTap: () {
        Navigator.of(context).pop();
        RouteUtil.route2ThemeList(context, '${model.id}');
      },
      child: new ListTile(
        trailing: new GestureDetector(
          onTap: () {
            _collectTheme('${model.id}');
          },
          child: _isCollectTheme('${model.id}')
              ? new Icon(Icons.done)
              : new Icon(Icons.add),
        ),
        title: new Text('${model.name}',
            style: new TextStyle(color: Colors.grey[700], fontSize: 18.0)),
      ),
    );
  }

  Widget _buildBody() {
    if (null != _themeWidgetList && _themeWidgetList.isNotEmpty) {
      return new ListView(
        padding: const EdgeInsets.only(),
        //_themeWidgetList 是一个widget集合
        children: _themeWidgetList,
      );
    } else {
      return ProgressDialog.buildProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // TODO: implement build
    return _buildBody();
  }

  @override
  void onLoadThemesFail() {
    // TODO: implement onLoadThemesFail
  }

  @override
  void onLoadThemesSuc(BaseModel<List<ThemeModel>> model) {
    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }
    _themeList = model.data;

    _refreshItems();
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
