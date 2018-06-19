import 'dart:async';

import 'package:daily_purify/model/HotNewsModel.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class StoriesRepository {

  Future<BaseModel<HotNewsModel>> loadNews(String date);

}
