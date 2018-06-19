class StoryExtraModel {
  final int longComments;
  final int popularity;
  final int shortComments;
  final int comments;

  const StoryExtraModel(
      {this.longComments, this.popularity, this.shortComments, this.comments});

  StoryExtraModel.fromJson(Map<String, dynamic> json)
      : longComments = json['body'],
        popularity = json['popularity'],
        shortComments = json['shortComments'],
        comments = json['comments'];
}
