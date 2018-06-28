import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/date_util.dart';
import 'package:daily_purify/Utils/route_util.dart';
import 'package:daily_purify/common/constant.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/hot_news_model.dart';
import 'package:daily_purify/mvp/presenter/stories_presenter.dart';
import 'package:daily_purify/mvp/presenter/stories_presenter_impl.dart';
import 'package:daily_purify/pages/drawer_page.dart';
import 'package:daily_purify/widget/common_divider.dart';
import 'package:daily_purify/widget/common_loading_dialog.dart';
import 'package:daily_purify/widget/common_retry.dart';
import 'package:daily_purify/widget/home_banner.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    _HomePageState view = new _HomePageState();
    StoriesPresenter presenter = new StoriesPresenterImpl(view);
    presenter.init();
    return view;
  }
}

class _HomePageState extends State<HomePage> implements StoriesView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  String _title = Constant.todayHot;

  List<DateTime> _dateTimeList = new List<DateTime>();

  List _dateTimeOffsetList = new List();

  ScrollController _scrollController;

  StoriesPresenter _storiesPresenter;

  List<HotNewsStoriesModel> _normalDatas = new List<HotNewsStoriesModel>();

  List<HotNewsTopStoriesModel> _topDatas = new List<HotNewsTopStoriesModel>();

  bool _isSlideUp = false;

  String _curDate;

  DateTime _curDateTime;

  bool _isShowRetry = false;

  void _scrollListener() {
    _computeShowtTitle(_scrollController.offset);

    //滑到最底部刷新
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  //用了个很原始方法计算 问题：导致多次刷新
  _computeShowtTitle(double offset) {
    //滑动监听改变title
    if (_dateTimeOffsetList.isNotEmpty) {
      if (offset.round() < _dateTimeOffsetList[0]) {
        _title = Constant.todayHot;
        setState(() {});
        return;
      }

      for (int i = 0; i < _dateTimeOffsetList.length; i++) {
        if (i != _dateTimeOffsetList.length - 1) {
          if (offset.round() >= _dateTimeOffsetList[i].round() &&
              _dateTimeOffsetList[i + 1].round() >= offset.round()) {
            String dateTime = DateUtil.formatDateWithWeek(
                _dateTimeList[i].subtract(new Duration(days: 1)));

            if (dateTime != _title) {
              setState(() {
                _title = dateTime;
              });
            }

            break;
          }
        } else {
          if (offset.round() >= _dateTimeOffsetList[i].round() &&
              _dateTimeOffsetList[i].round() >= offset.round()) {
            String dateTime = DateUtil.formatDateWithWeek(
                _dateTimeList[i].subtract(new Duration(days: 1)));

            if (dateTime != _title) {
              setState(() {
                _title = dateTime;
              });
            }
            break;
          }
        }

        if (i != _dateTimeOffsetList.length - 1) {
          if (offset.round() < _dateTimeOffsetList[i + 1].round() &&
              offset.round() > _dateTimeOffsetList[i].round()) {
            String dateTime = DateUtil.formatDateWithWeek(_dateTimeList[i]);

            if (dateTime != _title) {
              setState(() {
                _title = dateTime;
              });
            }
            break;
          }
        } else {
          if (offset.round() < _dateTimeOffsetList[i].round() &&
              offset.round() > _dateTimeOffsetList[i].round()) {
            String dateTime = DateUtil.formatDateWithWeek(_dateTimeList[i]);

            if (dateTime != _title) {
              setState(() {
                _title = dateTime;
              });
            }
            break;
          }
        }
      }
    }
  }

  Future<Null> _refreshData() {
    _isSlideUp = false;

    final Completer<Null> completer = new Completer<Null>();

    _curDateTime = new DateTime.now();

    _curDate = DateUtil.formatDateSimple(_curDateTime);

    _storiesPresenter.loadNews(null);

    completer.complete(null);

    return completer.future;
  }

  Future<Null> _loadData() {
    _isSlideUp = true;

    final Completer<Null> completer = new Completer<Null>();

    _curDateTime = _curDateTime.subtract(new Duration(days: 1));

    _curDate = DateUtil.formatDateSimple(_curDateTime);

    _storiesPresenter.loadNews(_curDate);

    setState(() {});

    completer.complete(null);

    return completer.future;
  }

  //根据type组装数据
  Widget _buildItem(BuildContext context, int index) {
    final HotNewsStoriesModel item = _normalDatas[index];

    Widget widget;

    switch (item.itemType) {
      case HotNewsStoriesModel.itemTypeBanner:
        widget = new HomeBanner(_topDatas, Constant.bannerHeight);
        break;
      case HotNewsStoriesModel.itemTypeNormal:
        widget = _buildNormalItem(item);
        break;
      case HotNewsStoriesModel.itemTypeDate:
        widget = _buildDateTimeItem(item);
        break;
    }
    return widget;
  }

  Widget _buildDateTimeItem(HotNewsStoriesModel item) {
    final String dateTime = item.curDate;

    return new Container(
      color: Colors.blue,
      height: Constant.dateTimeItemHeight,
      child: new Center(
        child: new Text(
          dateTime,
          style: new TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildNormalItem(HotNewsStoriesModel item) {
    final String imgUrl = item.images[0];
    final String title = item.title;
    final int id = item.id;
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
                          child: new Image.network(imgUrl),
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
  }

  Widget _buildList(BuildContext context) {
    var content;

    if (null == _normalDatas || _normalDatas.isEmpty) {
      if (_isShowRetry) {
        _isShowRetry = false;
        content = CommonRetry.buildRetry(_refreshData);
      } else {
        content = ProgressDialog.buildProgressDialog();
      }
    } else {
      content = new ListView.builder(
        //设置physics属性总是可滚动
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _normalDatas.length,
        itemBuilder: _buildItem,
      );
    }

    var _refreshIndicator = new NotificationListener(
      onNotification: _onNotification,
      child: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: content,
      ),
    );

    return _refreshIndicator;
  }

  bool _onNotification<Notification>(Notification n) {
    if (n is ScrollEndNotification) {
      //滑动结束刷新？体验不是很好，待定
      //setState(() {});
    }

    return true;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('$_title'), //动态改变title
        centerTitle: true, // 居中
      ), //头部的标题AppBar
      drawer: new Drawer(
        child: new DrawerPage(),
      ),
      body: _buildList(context),
    );
  }

  @override
  void onLoadNewsFail() {
    if (!_isSlideUp) {
      _isShowRetry = true;
      setState(() {});
    }
  }

  @override
  void onLoadNewsSuc(BaseModel<HotNewsModel> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      if (!_isSlideUp) {
        _isShowRetry = true;
        setState(() {});
      }
      return;
    }

    HotNewsModel hotNewsModel = model.data;

    List<HotNewsStoriesModel> normalList = hotNewsModel.stories;

    List<HotNewsTopStoriesModel> topList = hotNewsModel.topStories;

    if (_isSlideUp) {
      HotNewsStoriesModel dateItem = new HotNewsStoriesModel();
      dateItem.setItemType(HotNewsStoriesModel.itemTypeDate);
      dateItem.setCurDate(_curDateTime);
      _normalDatas.add(dateItem);
      _normalDatas.addAll(normalList);

      int offset = _dateTimeOffsetList[_dateTimeOffsetList.length - 1] +
          normalList.length * Constant.normalItemHeight.round() +
          Constant.dateTimeItemHeight.round();
      _dateTimeList.add(_curDateTime);
      _dateTimeOffsetList.add(offset);
    } else {
      _dateTimeList.clear();
      _dateTimeOffsetList.clear();

      _normalDatas = normalList;

      //用一个空对象 banner 占位

      _topDatas = topList;

      int offset = Constant.normalItemHeight.round() * _normalDatas.length;

      if (null != _topDatas && _topDatas.isNotEmpty) {
        offset = offset + Constant.bannerHeight.round();
        HotNewsStoriesModel bannerItem = new HotNewsStoriesModel();
        bannerItem.setItemType(HotNewsStoriesModel.itemTypeBanner);
        _normalDatas.insert(0, bannerItem);
      }

      _dateTimeList.add(_curDateTime);
      _dateTimeOffsetList.add(offset);
    }

    setState(() {});
  }

  @override
  setPresenter(StoriesPresenter presenter) {
    _storiesPresenter = presenter;
  }
}
