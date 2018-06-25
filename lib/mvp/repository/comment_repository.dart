import 'dart:async';

import 'package:daily_purify/model/comment_model.dart';
import 'package:daily_purify/model/hot_news_model.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class CommentRepository {

  Future<BaseModel<List<CommentModel>>> loadLongComments(String id);

  Future<BaseModel<List<CommentModel>>> loadShortComments(String id);


}
