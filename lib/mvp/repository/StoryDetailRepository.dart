import 'dart:async';

import 'package:daily_purify/model/StoryDetailModel.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/StoryExtraModel.dart';

abstract class StoryDetailRepository {

  Future<BaseModel<StoryDetailModel>> loadStoryDetail(String id);

  Future<BaseModel<StoryExtraModel>> loadStoryExtra(String id);

}
