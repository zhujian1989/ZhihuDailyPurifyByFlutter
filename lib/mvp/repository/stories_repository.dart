import 'dart:async';

import 'package:daily_purify/model/hot_news_model.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class StoriesRepository {

  Future<BaseModel<HotNewsModel>> loadNews(String date);

}
