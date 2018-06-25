import 'dart:async';

import 'package:daily_purify/model/theme_model.dart';
import 'package:daily_purify/model/base_model.dart';

abstract class ThemeRepository {

  Future<BaseModel<List<ThemeModel>>> loadThemes();

}
