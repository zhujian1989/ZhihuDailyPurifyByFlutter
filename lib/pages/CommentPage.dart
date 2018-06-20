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

  CommentPresenter _commentPresenter;

  List<CommentModel> _datas = [];

  Future<Null> _refreshData() {
    _datas.clear();

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

  Widget _buildItem(BuildContext context, int index) {
    final CommentModel item = _datas[index];
    String time = DateUtil.formatDate(item.time * 1000);
    return new InkWell(
      onTap: () {
        //todo
      },
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
                  alignment: Alignment.topRight,
                  child: new Text('👍（${item.likes}）'),
                )),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: new Container(
                alignment: Alignment.topLeft,
                child: new Text('${item.content}',
                    style:
                        new TextStyle(fontSize: 14.0, color: Colors.grey[800])),
              ),
            ),
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

  Widget buildList(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("评论详情"),
        centerTitle: true,
      ), //头部的标题AppBar
      body: buildList(context),
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
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }

//    _datas.addAll(model.data);
//
//    setState(() {});
  }

  @override
  void onLoadShortCommentsFail() {
    // TODO: implement onLoadShortCommentsFail
  }

  @override
  void onLoadShortCommentsSuc(BaseModel<List<CommentModel>> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }

    _datas.addAll(model.data);

    setState(() {});
  }
}
