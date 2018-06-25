import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/theme_list_model.dart';
import 'package:daily_purify/mvp/mvp.dart';

abstract class ThemeListPresenter implements IPresenter {
  loadThemeList(String themeId, String lastId);
}

abstract class ThemeListView implements IView<ThemeListPresenter> {
  void onLoadThemeListSuc(BaseModel<ThemeListModel> model);
  void onLoadThemeListFail();
}
