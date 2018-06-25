import 'package:daily_purify/model/theme_model.dart';
import 'package:daily_purify/mvp/mvp.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class ThemePresenter implements IPresenter{
  loadThemes();
}


abstract class ThemeView implements IView<ThemePresenter>{

  void onLoadThemesSuc(BaseModel<List<ThemeModel>> model);
  void onLoadThemesFail();



}
