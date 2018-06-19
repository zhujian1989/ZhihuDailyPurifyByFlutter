import 'package:daily_purify/model/ThemeModel.dart';
import 'package:daily_purify/mvp/Mvp.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class ThemePresenter implements IPresenter{
  loadThemes();
}


abstract class ThemeView implements IView<ThemePresenter>{

  void onLoadThemesSuc(BaseModel<List<ThemeModel>> model);
  void onLoadThemesFail();



}
