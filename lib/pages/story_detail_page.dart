import 'dart:async';
import 'dart:io';

import 'package:daily_purify/Utils/route_util.dart';
import 'package:daily_purify/common/constant.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/story_detail_model.dart';
import 'package:daily_purify/model/story_extra_model.dart';
import 'package:daily_purify/mvp/presenter/story_detail_presenter.dart';
import 'package:daily_purify/mvp/presenter/story_detail_presenter_impl.dart';
import 'package:daily_purify/widget/common_loading_dialog.dart';
import 'package:daily_purify/widget/common_snakeBar.dart';
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

  int _like = 0;

  int _commentsTotal = 0;

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

  Widget _buildList(BuildContext context) {
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
        ],
      );
    }
    return content;
  }

  Widget _buildBottomBar() {

    return new BottomAppBar(
      child: new Container(
        height: 40.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Icon(
                  Icons.thumb_up,
                  size: 20.0,
                  color: Colors.grey,
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 24.0),
                  child: new Text(
                    0 == _like ? '' : ('$_like'),
                    style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                )
              ],
            ),
            new Icon(
              Icons.share,
              size: 20.0,
              color: Colors.grey,
            ),
            new InkWell(
              onTap: () {
                RouteUtil.route2Comment(context, widget.id);
              },
              child: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.message,
                    size: 20.0,
                    color: Colors.grey,
                  ),
                  new Container(
                    margin: const EdgeInsets.only(left: 24.0),
                    child: new Text(
                      0 == _commentsTotal ? '' : ('$_commentsTotal'),
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('$_title'),
      ),
      body: _buildList(context),
      bottomNavigationBar: _buildBottomBar(),
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

    _commentsTotal = _storyExtraModel.comments;

    _like = _storyExtraModel.popularity;


    setState(() {});
  }
}
