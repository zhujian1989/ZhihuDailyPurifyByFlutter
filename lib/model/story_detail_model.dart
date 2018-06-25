class StoryDetailModel {

  final String body;
  final String imageSource;
  final String title;
  final String image;
  final String shareUrl;
  final List images;
  final List css;
  final List js;
  final int id;
  final int type;

  const StoryDetailModel(
      {this.body,
      this.imageSource,
      this.title,
      this.image,
      this.shareUrl,
      this.images,
      this.css,
      this.js,
      this.id,
      this.type});

  StoryDetailModel.fromJson(Map<String, dynamic> json)
      : body = json['body'],
        id = json['id'],
        title = json['title'],
        image = json['image'],
        shareUrl = json['share_url'],
        images = json['images'],
        js = json['js'],
        type = json['type'],
        css = json['css'],
      imageSource = json['image_source'];

}

