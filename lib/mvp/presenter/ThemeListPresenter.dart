import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/ThemeListModel.dart';
import 'package:daily_purify/mvp/Mvp.dart';

abstract class ThemeListPresenter implements IPresenter {
  loadThemeList(String themeId, String lastId);
}

abstract class ThemeListView implements IView<ThemeListPresenter> {
  void onLoadThemeListSuc(BaseModel<ThemeListModel> model);
  void onLoadThemeListFail();
}
