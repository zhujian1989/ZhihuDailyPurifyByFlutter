import 'dart:async';

import 'package:daily_purify/model/ThemeListModel.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class ThemeListRepository {

  Future<BaseModel<ThemeListModel>> loadThemeList(String themeId,String lastId);

}
