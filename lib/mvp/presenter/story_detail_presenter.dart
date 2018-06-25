import 'package:daily_purify/model/story_detail_model.dart';
import 'package:daily_purify/mvp/mvp.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/story_extra_model.dart';

abstract class StoryDetailPresenter implements IPresenter{
  loadStoryDetail(String id);

  loadStoryExtra(String id);

}


abstract class StoryDetailView implements IView<StoryDetailPresenter>{

  void onLoadStoryDetailSuc(BaseModel<StoryDetailModel> model);
  void onLoadStoryDetailFail();

  void onLoadStoryExtraSuc(BaseModel<StoryExtraModel> model);
  void onLoadStoryExtraFail();

}
