class ThemeModel {
  final String thumbnail;
  final String description;
  final int id;
  final String name;

  const ThemeModel({this.thumbnail, this.description, this.id, this.name});

  ThemeModel.fromJson(Map<String, dynamic> json)
      : thumbnail = json['thumbnail'],
        description = json['description'],
        id = json['id'],
        name = json['name'];
}
