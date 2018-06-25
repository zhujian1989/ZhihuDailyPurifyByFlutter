import 'package:daily_purify/model/hot_news_model.dart';
import 'package:daily_purify/mvp/mvp.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class StoriesPresenter implements IPresenter{
  loadNews(String date);
}


abstract class StoriesView implements IView<StoriesPresenter>{

  void onLoadNewsSuc(BaseModel<HotNewsModel> model);
  void onLoadNewsFail();

}
