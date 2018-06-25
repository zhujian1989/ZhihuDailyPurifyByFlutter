class ThemeListModel {
  final String description;

  final String name;

  final String background;

  final String image;

  final List stories;

  final List editors;

  const ThemeListModel(
      {this.description,
      this.name,
      this.background,
      this.image,
      this.stories,
      this.editors});
}

class ThemeListStoriesModel {

  static const int itemTypeNormal = 0;
  static const int itemTypeBanner = 1;
  static const int itemTypeEditor = 2;

  final List images;
  final int type;
  final int id;
  final String title;

  int itemType = itemTypeNormal;

  setItemType(int type) {
    itemType = type;
  }

  ThemeListStoriesModel({this.images, this.type, this.id, this.title});

  ThemeListStoriesModel.fromJson(Map<String, dynamic> json)
      : images = json['images'],
        type = json['type'],
        id = json['id'],
        title = json['title'];
}

class ThemeListEditorsModel {
  final String url;
  final String bio;
  final String avatar;
  final int id;
  final String name;

  const ThemeListEditorsModel(
      {this.url, this.bio, this.avatar, this.id, this.name});

  ThemeListEditorsModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        bio = json['bio'],
        id = json['id'],
        name = json['name'],
        avatar = json['avatar'];
}
