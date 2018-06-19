import 'package:daily_purify/model/HotNewsModel.dart';
import 'package:daily_purify/mvp/Mvp.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class StoriesPresenter implements IPresenter{
  loadNews(String date);
}


abstract class StoriesView implements IView<StoriesPresenter>{

  void onLoadNewsSuc(BaseModel<HotNewsModel> model);
  void onLoadNewsFail();



}
