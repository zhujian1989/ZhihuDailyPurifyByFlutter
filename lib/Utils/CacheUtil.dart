import 'package:daily_purify/model/ThemeModel.dart';

class CacheUtil {
  List<ThemeModel> themeModelList;

  static CacheUtil _singleton;

  factory CacheUtil() {
    if (_singleton == null) {
      _singleton = new CacheUtil._internal();
    }

    return _singleton;
  }

  CacheUtil._internal();

  setThemeListCache(List<ThemeModel> list) {
    themeModelList = list;
  }

  getThemeListCache() {
    return themeModelList;
  }
}
