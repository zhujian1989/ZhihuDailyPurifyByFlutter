class CommentModel {

  static const int normalCommentType = 0;
  static const int longCommentType = 1;
  static const int shortCommentType = 2;
  static const int longCommentNullType = -1;


  final String author;
  final String content;
  final String avatar;
  final int time;
  var replyToJson;
  final int id;
  final int likes;

  ReplyToModel replyTo;

  int itemType = normalCommentType;

  CommentModel({this.avatar,
    this.author,
    this.content,
    this.time,
    this.replyToJson,
    this.id,
    this.likes,this.replyTo});


  setItemType(int type) {
    itemType = type;
  }


  CommentModel.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        content = json['content'],
        id = json['id'],
        replyToJson = json['reply_to'],
        time = json['time'],
        likes = json['likes'],
        avatar = json['avatar'];

}

class ReplyToModel {
  final String author;
  final String content;
  final int id;
  final int status;

  ReplyToModel({this.author, this.content, this.status, this.id});

  ReplyToModel.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        content = json['content'],
        id = json['id'],
        status = json['status'];
}
