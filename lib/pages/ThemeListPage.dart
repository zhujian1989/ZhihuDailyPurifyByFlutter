import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/RouteUtil.dart';
import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/ThemeListModel.dart';
import 'package:daily_purify/mvp/presenter/ThemeListPresenter.dart';
import 'package:daily_purify/mvp/presenter/ThemeListPresenterImpl.dart';
import 'package:daily_purify/pages/DrawerPage.dart';
import 'package:daily_purify/widget/CommonDivider.dart';
import 'package:daily_purify/widget/CommonLoadingDialog.dart';
import 'package:daily_purify/widget/CommonSnakeBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:transparent_image/transparent_image.dart';

class ThemeListPage extends StatefulWidget {
  final String themeId;

  ThemeListPage(this.themeId, {Key key}) : super(key: key);

  @override
  _ThemeListPageState createState() {
    _ThemeListPageState view = new _ThemeListPageState();
    ThemeListPresenter presenter = new ThemeListPresenterImpl(view);
    presenter.init();
    return view;
  }
}

class _ThemeListPageState extends State<ThemeListPage>
    implements ThemeListView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  String _title = Constant.themeTitle;

  ScrollController _scrollController;

  ThemeListPresenter _themeListPresenter;

  List<ThemeListStoriesModel> _normalDatas = [];

  List<ThemeListEditorsModel> _editorDatas = [];

  ThemeListModel _themeListModel;

  bool _isSlideUp = false;

  int _curStoryId;

  void _scrollListener() {
    //滑到最底部刷新
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<Null> _refreshData() {
    _isSlideUp = false;

    final Completer<Null> completer = new Completer<Null>();

    _themeListPresenter.loadThemeList(widget.themeId, null);

    completer.complete(null);

    return completer.future;
  }

  Future<Null> _loadData() {
    _isSlideUp = true;

    final Completer<Null> completer = new Completer<Null>();

    _themeListPresenter.loadThemeList(widget.themeId, '$_curStoryId');

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    _refreshData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget _buildBanner() {
    return new FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _themeListModel.image,
        fit: BoxFit.fitWidth);
  }

  Widget _buildEditor() {
    List<Widget> editors = [];
    Widget lableWidget = new Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: new Text(
        '主编',
        style: new TextStyle(fontSize: 14.0),
      ),
    );

    editors.add(lableWidget);
    for (ThemeListEditorsModel model in _editorDatas) {
      Widget headView = new InkWell(
        onTap: () {
          RouteUtil.route2Web(context, model.name, model.url);
        },
        child: new Padding(
            padding: const EdgeInsets.only(
                left: 6.0, right: 6.0, top: 12.0, bottom: 12.0),
            child: new CircleAvatar(
              radius: 12.0,
              backgroundImage: new NetworkImage(model.avatar),
            )),
      );
      editors.add(headView);
    }

    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: new Row(
            children: editors,
          ),
        ),
        CommonDivider.buildDivider(),
      ],
    );
  }

  Widget _buildNormalItem(ThemeListStoriesModel item) {
    final List images = item.images;
    final String title = item.title;
    final int id = item.id;
    bool hasImage = (null != images && images.isNotEmpty);

    if (hasImage) {
      return new InkWell(
          onTap: () {
            RouteUtil.route2Detail(context, '$id');
          },
          child: new Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: new SizedBox(
                height: Constant.normalItemHeight,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            title,
                            style: new TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new SizedBox(
                            height: 80.0,
                            width: 80.0,
                            child: new Image.network(images[0]),
                          ),
                        )
                      ],
                    ),
                    new Expanded(
                      child: new Align(
                        alignment: Alignment.bottomCenter,
                        child: CommonDivider.buildDivider(),
                      ),
                    ),
                  ],
                ),
              )));
    } else {
      return new InkWell(
          onTap: () {
            RouteUtil.route2Detail(context, '$id');
          },
          child: new Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: new SizedBox(
                height: Constant.normalItemHeight,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new SizedBox(
                            height: Constant.normalItemHeight,
                            child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                title,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    new Expanded(
                      child: new Align(
                        alignment: Alignment.bottomCenter,
                        child: CommonDivider.buildDivider(),
                      ),
                    ),
                  ],
                ),
              )));
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final ThemeListStoriesModel item = _normalDatas[index];

    Widget widget;

    switch (item.itemType) {
      case ThemeListStoriesModel.itemTypeBanner:
        widget = _buildBanner();
        break;
      case ThemeListStoriesModel.itemTypeEditor:
        widget = _buildEditor();
        break;
      case ThemeListStoriesModel.itemTypeNormal:
        widget = _buildNormalItem(item);
        break;
    }
    return widget;
  }

  Widget buildList(BuildContext context) {
    var content;

    if (_normalDatas.isEmpty) {
      content = ProgressDialog.buildProgressDialog();
    } else {
      content = new ListView.builder(
        //设置physics属性总是可滚动
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _normalDatas.length,
        itemBuilder: _buildItem,
      );
    }

    var _refreshIndicator = new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      child: content,
    );

    return _refreshIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('$_title'),
        centerTitle: true,
      ), //头部的标题AppBar
      drawer: new Drawer(
        child: new DrawerPage(),
      ),
      body: buildList(context),
    );
  }

  @override
  setPresenter(ThemeListPresenter presenter) {
    _themeListPresenter = presenter;
  }

  @override
  void onLoadThemeListFail() {
    // TODO: implement onLoadThemeListFail
  }

  @override
  void onLoadThemeListSuc(BaseModel<ThemeListModel> model) {

    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }

    _themeListModel = model.data;

    List<ThemeListStoriesModel> normalList = _themeListModel.stories;

    if (_isSlideUp) {
      _normalDatas.addAll(normalList);
    } else {
      List<ThemeListEditorsModel> editorList = _themeListModel.editors;

      _title = _themeListModel.name;

      _normalDatas.clear();
      _editorDatas.clear();

      _normalDatas = normalList;
      _editorDatas = editorList;
      _curStoryId = _normalDatas[0].id;

      if (null != _editorDatas && _editorDatas.isNotEmpty) {
        ThemeListStoriesModel fakeItem = new ThemeListStoriesModel();
        fakeItem.setItemType(ThemeListStoriesModel.itemTypeEditor);
        _normalDatas.insert(0, fakeItem);
      }

      if (null != _themeListModel.image) {
        ThemeListStoriesModel fakeItem = new ThemeListStoriesModel();
        fakeItem.setItemType(ThemeListStoriesModel.itemTypeBanner);
        _normalDatas.insert(0, fakeItem);
      }
    }

    setState(() {});
  }
}
