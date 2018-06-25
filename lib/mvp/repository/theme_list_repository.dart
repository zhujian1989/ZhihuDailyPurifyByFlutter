import 'dart:async';

import 'package:daily_purify/model/theme_list_model.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class ThemeListRepository {

  Future<BaseModel<ThemeListModel>> loadThemeList(String themeId,String lastId);

}
