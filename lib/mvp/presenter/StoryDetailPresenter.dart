import 'package:daily_purify/model/StoryDetailModel.dart';
import 'package:daily_purify/mvp/Mvp.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/StoryExtraModel.dart';

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
