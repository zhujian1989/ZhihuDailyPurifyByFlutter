import 'package:daily_purify/Utils/RouteUtil.dart';
import 'package:daily_purify/model/HotNewsModel.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeBanner extends StatefulWidget {

  final _homeBannerHeight;

  final List<HotNewsTopStoriesModel> topList;

  HomeBanner(this.topList, this._homeBannerHeight);

  @override
  State<StatefulWidget> createState() {
    return new _HomeBannerState();
  }
}

class _HomeBannerState extends State<HomeBanner> {

  int _curPageIndex = 0;

  PageController _pageController = new PageController();

  List<Widget> _indicators = [];

  List<HotNewsTopStoriesModel> fakeList = [];

  //用于做banner循环
  _initFakeList() {
    for (int i = 0; i < 100; i++) {
      fakeList.addAll(widget.topList);
    }
  }

  _initIndicators() {
    _indicators.clear();
    for (int i = 0; i < widget.topList.length; i++) {
      _indicators.add(new SizedBox(
        width: 5.0,
        height: 5.0,
        child: new Container(
          color: i == _curPageIndex ? Colors.white : Colors.grey,
        ),
      ));
    }
  }

  _changePage(int index) {
    _curPageIndex = index % widget.topList.length;
    setState(() {});
  }

  Widget _buildIndicators() {
    _initIndicators();
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Container(
          color: Colors.black45,
          height: 20.0,
          child: new Center(
            child: new SizedBox(
              width: widget.topList.length * 16.0,
              height: 5.0,
              child: new Row(
                children: _indicators,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          )),
    );
  }

  Widget _buildPagerView() {
    _initFakeList();
    return new PageView.builder(
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, index);
      },
      itemCount: fakeList.length,
      onPageChanged: (index) {
        _changePage(index);
      },
    );
  }

  Widget _buildBanner() {
    return new Container(
      height: widget._homeBannerHeight,
      child: new Stack(
        children: <Widget>[
          _buildPagerView(),
          _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    HotNewsTopStoriesModel item = fakeList[index];
    return new GestureDetector(
      onTap: () {
        RouteUtil.route2Detail(context, '${item.id}');
      },
      child: new FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.image,
          height: widget._homeBannerHeight,
          fit: BoxFit.fitWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBanner();
  }
}
