import 'package:daily_purify/model/theme_model.dart';

class CacheUtil {

  static List<ThemeModel> _themeModelList;

  static CacheUtil _singleton;

  static CacheUtil getInstance() {
    if (_singleton == null) {
      _singleton = new CacheUtil._internal();
      _singleton._init();
    }

    return _singleton;
  }

  CacheUtil._internal();

  _init() {
    _themeModelList = [];
  }

  setThemeListCache(List<ThemeModel> list) {
    _themeModelList = list;
  }

  getThemeListCache() {
    return _themeModelList;
  }
}
