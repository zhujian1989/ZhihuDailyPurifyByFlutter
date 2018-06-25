import 'dart:async';

import 'package:daily_purify/model/story_detail_model.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/story_extra_model.dart';

abstract class StoryDetailRepository {

  Future<BaseModel<StoryDetailModel>> loadStoryDetail(String id);

  Future<BaseModel<StoryExtraModel>> loadStoryExtra(String id);

}
