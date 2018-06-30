import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/route_util.dart';
import 'package:daily_purify/common/constant.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/theme_list_model.dart';
import 'package:daily_purify/mvp/presenter/theme_list_presenter.dart';
import 'package:daily_purify/mvp/presenter/theme_list_presenter_impl.dart';
import 'package:daily_purify/pages/drawer_page.dart';
import 'package:daily_purify/widget/common_divider.dart';
import 'package:daily_purify/widget/common_snakeBar.dart';
import 'package:flutter/material.dart';
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

enum AppBarBehavior { normal, pinned, floating, snapping }

class _ThemeListPageState extends State<ThemeListPage>
    implements ThemeListView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

//  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
//      ScaffoldState>();

  final double _appBarHeight = 256.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  String _title = Constant.themeTitle;

  ScrollController _scrollController;

  ThemeListPresenter _themeListPresenter;

  List<ThemeListStoriesModel> _normalDatas = [];

  List<ThemeListEditorsModel> _editorDatas = [];

  List<Widget> _widgets = [];

  String _barBg = Constant.defBg;

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

  Widget _buildEditor() {
    //横向控件的集合
    List<Widget> editors = [];

    //主编
    Widget lableWidget = new Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: new Text(
        '主编',
        style: new TextStyle(fontSize: 14.0),
      ),
    );

    editors.add(lableWidget);

    //循环加入主编的头像
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

    //组装
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

  Widget _buildNewItem(ThemeListStoriesModel item) {
    Widget widget;

    switch (item.itemType) {
      case ThemeListStoriesModel.itemTypeEditor:
        widget = _buildEditor();
        break;
      case ThemeListStoriesModel.itemTypeNormal:
        widget = _buildNormalItem(item);
        break;
    }
    return widget;
  }

  _refreshItems() {
    for (ThemeListStoriesModel model in _normalDatas) {
      _widgets.add(_buildNewItem(model));
    }

    setState(() {});
  }

  Widget _buildList(BuildContext context) {
    var content = new CustomScrollView(
      //没有铺满也可以滑动
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: <Widget>[
        new SliverAppBar(
          expandedHeight: _appBarHeight,
          pinned: _appBarBehavior == AppBarBehavior.pinned,
          floating: _appBarBehavior == AppBarBehavior.floating ||
              _appBarBehavior == AppBarBehavior.snapping,
          snap: _appBarBehavior == AppBarBehavior.snapping,
          flexibleSpace: new FlexibleSpaceBar(
            //标题
            title: Text('$_title'),
            centerTitle: true,
            //背景图
            background: new FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _barBg,
                fit: BoxFit.fitHeight),
          ),
        ),
        new SliverList(
          delegate: new SliverChildListDelegate(
              new List<Widget>.generate(_normalDatas.length, (int i) {
            return _buildNewItem(_normalDatas[i]);
          })),
        ),
      ],
    );

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
//      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: new Drawer(
        child: new DrawerPage(),
      ),
      body: _buildList(context),
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

    if (_isSlideUp) {
      List<ThemeListStoriesModel> normalList = model.data.stories;
      _normalDatas.addAll(normalList);
    } else {
      _themeListModel = model.data;
      List<ThemeListStoriesModel> normalList = model.data.stories;
      List<ThemeListEditorsModel> editorList = _themeListModel.editors;

      _themeListModel = model.data;

      _barBg = _themeListModel.image;

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

    }

    _refreshItems();
  }
}
