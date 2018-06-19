import 'dart:async';

import 'package:daily_purify/model/ThemeModel.dart';
import 'package:daily_purify/model/BaseModel.dart';

abstract class ThemeRepository {

  Future<BaseModel<List<ThemeModel>>> loadThemes();

}
