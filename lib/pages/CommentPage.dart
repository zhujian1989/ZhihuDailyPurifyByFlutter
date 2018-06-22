import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/DateUtil.dart';
import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/CommentModel.dart';
import 'package:daily_purify/mvp/presenter/CommentPresenter.dart';
import 'package:daily_purify/mvp/presenter/CommentPresenterImpl.dart';
import 'package:daily_purify/widget/CommonLoadingDialog.dart';
import 'package:daily_purify/widget/CommonSnakeBar.dart';
import 'package:flutter/material.dart';

class Choice {
  const Choice({this.choiceName, this.choiceValue});

  final String choiceName;
  final int choiceValue;
}

const List<Choice> choices = const <Choice>[
  const Choice(choiceName: Constant.popAgree, choiceValue: 0),
  const Choice(choiceName: Constant.popReport, choiceValue: 1),
  const Choice(choiceName: Constant.popCopy, choiceValue: 2),
  const Choice(choiceName: Constant.popReply, choiceValue: 3),
];

class CommentPage extends StatefulWidget {
  final String themeId;

  CommentPage(this.themeId, {Key key}) : super(key: key);

  @override
  _CommentPageState createState() {
    _CommentPageState view = new _CommentPageState();
    CommentPresenter presenter = new CommentPresenterImpl(view);
    presenter.init();
    return view;
  }
}

class _CommentPageState extends State<CommentPage> implements CommentView {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldStateKey =
      new GlobalKey<ScaffoldState>();

  CommentPresenter _commentPresenter;

  List<CommentModel> _datas = [];

  int _longCommentsLength = 0;

  int _shortCommentsLength = 0;

  _initData() {
    CommentModel longCommentType = new CommentModel();
    longCommentType.setItemType(CommentModel.longCommentType);
    CommentModel shortCommentType = new CommentModel();
    shortCommentType.setItemType(CommentModel.shortCommentType);
    _datas.add(longCommentType);
    _datas.add(shortCommentType);
  }

  Future<Null> _refreshData() {
    _datas.clear();

    _initData();

    final Completer<Null> completer = new Completer<Null>();

    _commentPresenter.loadLongComments(widget.themeId);

    _commentPresenter.loadShortComments(widget.themeId);

    completer.complete(null);

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildPopItem(CommentModel item) {
    return new PopupMenuButton<Choice>(
        padding: EdgeInsets.zero,
        onSelected: (choice) {
          print(choice.choiceName);
        },
        child: _buildContentItem(item),
        itemBuilder: (BuildContext context) {
          return choices.map((Choice choice) {
            return new PopupMenuItem<Choice>(
              value: choice,
              child: new Text(choice.choiceName),
            );
          }).toList();
        });
  }

  Widget _buildItem(BuildContext context, int index) {
    final CommentModel item = _datas[index];
    Widget widget;

    switch (item.itemType) {
      case CommentModel.longCommentType:
        widget = _buildTotal('$_longCommentsLength 条长评论');
        break;
      case CommentModel.shortCommentType:
        widget = _buildTotal('$_shortCommentsLength 条短评论');
        break;
      case CommentModel.normalCommentType:
        widget = _buildPopItem(item);
        break;
    }

    return widget;
  }

  Widget _buildTotal(String content) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
              left: 8.0, top: 12.0, bottom: 12.0, right: 12.0),
          child: new Align(
            alignment: Alignment.centerLeft,
            child: new Text(
              content,
              style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ),
        new Divider(height: 1.0),
      ],
    );
  }

  Widget _buildContentItem(CommentModel item) {
    String time = DateUtil.formatDate(item.time * 1000);
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new CircleAvatar(
                  radius: 12.0,
                  backgroundImage: new NetworkImage(
                      item.avatar.isEmpty ? Constant.defHeadimg : item.avatar),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: new Text('${item.author}',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.black)),
                ),
                new Expanded(
                    child: new Container(
                  child: new Align(
                    alignment: Alignment.topRight,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Icon(
                          Icons.thumb_up,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                        new Text(
                          '(${item.likes})',
                          style: new TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
            new Padding(
              padding:
                  const EdgeInsets.only(left: 35.0, top: 12.0, bottom: 12.0),
              child: new Container(
                alignment: Alignment.topLeft,
                child: new Text('${item.content}',
                    style:
                        new TextStyle(fontSize: 14.0, color: Colors.grey[800])),
              ),
            ),
            _buildReply(item),
            new Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: new Container(
                alignment: Alignment.topRight,
                child: new Text('$time'),
              ),
            ),
            new Divider(height: 1.0),
          ],
        ),
      ),
    );
  }

  Widget _buildReply(CommentModel item) {
    ReplyToModel replyToModel = item.replyTo;

    if (null != replyToModel) {
      return new Padding(
        padding: const EdgeInsets.only(left: 35.0, top: 12.0, bottom: 12.0),
        child: new Container(
          alignment: Alignment.topLeft,
          child: new Text(
            '${replyToModel.author} 回复：${replyToModel.content}',
            style: new TextStyle(fontSize: 14.0),
          ),
        ),
      );
    } else {
      //不需要显示怎么办？
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _buildList(BuildContext context) {
    var content;

    if (null == _datas || _datas.isEmpty) {
      content = ProgressDialog.buildProgressDialog();
    } else {
      content = new ListView.builder(
        //设置physics属性总是可滚动
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _datas.length,
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

  Widget _buildBottomBar() {
    return new BottomAppBar(
      child: new InkWell(
        onTap: () {
          CommonSnakeBar.buildSnakeBarByKey(_scaffoldStateKey, context, '该功能暂时无法完成');
        },
        child: new Container(
          height: 40.0,
          child: new Center(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 20.0,
                ),
                new Text(
                  '写点评',
                  style: new TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldStateKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("评论列表"),
        centerTitle: true,
      ),
      //头部的标题AppBar
      body: _buildList(context),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  @override
  setPresenter(CommentPresenter presenter) {
    _commentPresenter = presenter;
  }

  @override
  void onLoadLongCommentsFail() {}

  @override
  void onLoadLongCommentsSuc(BaseModel<List<CommentModel>> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBarByKey(
          _scaffoldStateKey, context, model.errorMsg);
      return;
    }

    _longCommentsLength = model.data.length;

    _datas.insertAll(1, model.data);

    setState(() {});
  }

  @override
  void onLoadShortCommentsFail() {
    // TODO: implement onLoadShortCommentsFail
  }

  @override
  void onLoadShortCommentsSuc(BaseModel<List<CommentModel>> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBarByKey(
          _scaffoldStateKey, context, model.errorMsg);
      return;
    }

    _shortCommentsLength = model.data.length;

    _datas.addAll(model.data);

    setState(() {});
  }
}
