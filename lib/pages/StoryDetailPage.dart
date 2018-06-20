import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/RouteUtil.dart';
import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/StoryDetailModel.dart';
import 'package:daily_purify/model/StoryExtraModel.dart';
import 'package:daily_purify/mvp/presenter/StoryDetailPresenter.dart';
import 'package:daily_purify/mvp/presenter/StoryDetailPresenterImpl.dart';
import 'package:daily_purify/widget/CommonLoadingDialog.dart';
import 'package:daily_purify/widget/CommonSnakeBar.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class StoryDetailAppPage extends StatefulWidget {
  final String id;

  StoryDetailAppPage(this.id);

  @override
  State<StatefulWidget> createState() {
    _StoryDetailAppPageState view = new _StoryDetailAppPageState();
    StoryDetailPresenter presenter = new StoryDetailPresenterImpl(view);
    presenter.init();
    return view;
  }
}

class _StoryDetailAppPageState extends State<StoryDetailAppPage>
    implements StoryDetailView {
  String _title = Constant.storyTitle;

  StoryDetailPresenter _storyDetailPresenter;

  StoryDetailModel _storyDetailModel;

  StoryExtraModel _storyExtraModel;

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();

    _storyDetailPresenter.loadStoryDetail(widget.id);

    _storyDetailPresenter.loadStoryExtra(widget.id);

    completer.complete(null);

    return completer.future;
  }

  Widget buildList(BuildContext context) {

    widgets.clear();
    if (null != _storyDetailModel && null != _storyDetailModel.image) {
      widgets.add(_buildBanner());
    }
    widgets.add(_buildTips());
    widgets.add(_buildLink());

    var content;

    if (null == _storyDetailModel) {
      content = ProgressDialog.buildProgressDialog();
    } else {
      content = new Stack(
        children: <Widget>[
          new ListView(
            children: widgets,
          ),
          new Align(
            alignment: Alignment.bottomLeft,
            child: new Container(
              color: Colors.black,
              height: 40.0,
              child: _buildExtra(),
            ),
          )
        ],
      );
    }
    return content;
  }

  Widget _buildExtra() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 30.0,
        ),
        new Icon(
          Icons.star,
          size: 30.0,
          color: Colors.white,
        ),
        new Icon(
          Icons.share,
          size: 30.0,
          color: Colors.white,
        ),
        new InkWell(
          onTap: (){
            RouteUtil.route2Comment(context, widget.id);
          },
          child: new Icon(
            Icons.message,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLink() {
    return new Container(
        height: 80.0,
        child: new Center(
          child: new InkWell(
            onTap: () {
              RouteUtil.route2Web(
                  context, _storyDetailModel.title, _storyDetailModel.shareUrl);
            },
            child: new Text('点击查看原文',
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue,
                )),
          ),
        ));
  }

  Widget _buildTips() {
    return new Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Container(
          child: new Center(
            child: new Text(
              Constant.tips,
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ));
  }

  Widget _buildBanner() {
    return new FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _storyDetailModel.image,
        height: Constant.bannerHeight,
        fit: BoxFit.fitWidth);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('$_title'),
      ),
      body: buildList(context),
    );
  }

  @override
  void onLoadStoryDetailFail() {}

  @override
  void onLoadStoryDetailSuc(BaseModel<StoryDetailModel> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }

    _storyDetailModel = model.data;

    _title = _storyDetailModel.title;

    setState(() {});
  }

  @override
  setPresenter(StoryDetailPresenter presenter) {
    _storyDetailPresenter = presenter;
  }

  @override
  void onLoadStoryExtraFail() {
    // TODO: implement onLoadStoryExtraFail
  }

  @override
  void onLoadStoryExtraSuc(BaseModel<StoryExtraModel> model) {
    if (!mounted) return; //异步处理，防止报错

    if (model.code != HttpStatus.OK) {
      CommonSnakeBar.buildSnakeBar(context, model.errorMsg);
      return;
    }

    _storyExtraModel = model.data;

    setState(() {});
  }
}
