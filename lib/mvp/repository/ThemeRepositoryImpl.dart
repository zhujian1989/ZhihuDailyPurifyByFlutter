import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/ThemeModel.dart';
import 'package:daily_purify/mvp/repository/ThemeRepository.dart';
import 'package:daily_purify/net/Apis.dart';
import 'package:daily_purify/net/DioFactory.dart';
import 'package:dio/dio.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  @override
  Future<BaseModel<List<ThemeModel>>> loadThemes() {

    return _getThemes();
  }

}

Future<BaseModel<List<ThemeModel>>> _getThemes() async {
  Dio dio =DioFactory.getInstance().getDio();

  String url = Constant.baseUrl + Apis.themes;

  print(url);

  int code;

  String errorMsg;

  BaseModel<List<ThemeModel>> model;

  List<ThemeModel> themesList;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {

      List themes = response.data['others'];

      themesList = themes.map((model) {
        return new ThemeModel.fromJson(model);
      }).toList();

    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(
        code: code, errorMsg: errorMsg, data: themesList);
  }

  return model;
}
