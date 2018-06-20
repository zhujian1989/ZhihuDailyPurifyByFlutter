import 'dart:async';

import 'package:daily_purify/model/CommentModel.dart';
import 'package:daily_purify/model/HotNewsModel.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class CommentRepository {

  Future<BaseModel<List<CommentModel>>> loadLongComments(String id);

  Future<BaseModel<List<CommentModel>>> loadShortComments(String id);


}
