import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/ThemeListModel.dart';
import 'package:daily_purify/mvp/repository/ThemeListRepository.dart';
import 'package:daily_purify/net/Apis.dart';
import 'package:daily_purify/net/DioFactory.dart';
import 'package:dio/dio.dart';

class ThemeListRepositoryImpl implements ThemeListRepository {
  @override
  Future<BaseModel<ThemeListModel>> loadThemeList(
      String themeId, String lastId) {
    return _getThemeList(themeId, lastId);
  }
}

Future<BaseModel<ThemeListModel>> _getThemeList(
    String themeId, String lastId) async {
  Dio dio = new DioFactory(new Dio()).getDio();

  String url;


  if (null == lastId) {
    url = Constant.baseUrl + Apis.themes_list + themeId;
  } else {
    url = Constant.baseUrl +
        Apis.themes_list +
        themeId +
        Apis.themes_list_before +
        lastId;
  }

  print(url);


  int code;

  String errorMsg;

  ThemeListModel themeListModel;

  BaseModel<ThemeListModel> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {

      String description = response.data['description'];

      String name = response.data['name'];

      String image = response.data['image'];

      String background = response.data['background'];

      List stories = response.data['stories'];

      List editors = response.data['editors'];

      List<ThemeListEditorsModel> editorList;

      List<ThemeListStoriesModel> storiesList = stories.map((model) {
        return new ThemeListStoriesModel.fromJson(model);
      }).toList();

      //topStories根据接口只有当天有，过去时间的topStories为空
      if (editors != null && editors.isNotEmpty) {
        editorList = editors.map((model) {
          return new ThemeListEditorsModel.fromJson(model);
        }).toList();
      }

      themeListModel = new ThemeListModel(
          description: description,
          background: background,
          name: name,
          image: image,
          stories: storiesList,
          editors: editorList);
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(code: code, errorMsg: errorMsg, data: themeListModel);
  }

  return model;
}
