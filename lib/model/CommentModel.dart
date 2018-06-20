class CommentModel {
  final String author;
  final String content;
  final String avatar;
  final int time;
  var replyToJson;
  final int id;
  final int likes;

  ReplyToModel replyTo;

  CommentModel(
      {this.avatar,
      this.author,
      this.content,
      this.time,
      this.replyToJson,
      this.id,
      this.likes,this.replyTo});

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
