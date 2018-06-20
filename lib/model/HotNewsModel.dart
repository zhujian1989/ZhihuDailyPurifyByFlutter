import 'package:daily_purify/Utils/DateUtil.dart';
class HotNewsModel {
  final String date;

  final List stories;

  final List topStories;

  const HotNewsModel({this.date, this.stories, this.topStories});
}

class HotNewsStoriesModel {
  static const int itemTypeNormal = 0;
  static const int itemTypeBanner = 1;
  static const int itemTypeDate = 2;
  static const int itemTypeEditor = 3;

  final List images;
  final int type;
  final int id;
  final String title;

  int itemType = itemTypeNormal;
  String curDate;

  HotNewsStoriesModel({this.images, this.type, this.id, this.title});

  setItemType(int type) {
    itemType = type;
  }

  setCurDate(DateTime dt) {
    curDate = DateUtil.formatDateWithWeek(dt);
  }

  HotNewsStoriesModel.fromJson(Map<String, dynamic> json)
      : images = json['images'],
        type = json['type'],
        id = json['id'],
        title = json['title'];
}

class HotNewsTopStoriesModel {
  final String image;
  final int type;
  final int id;
  final String title;

  const HotNewsTopStoriesModel({this.image, this.type, this.id, this.title});

  HotNewsTopStoriesModel.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        type = json['type'],
        id = json['id'],
        title = json['title'];
}
