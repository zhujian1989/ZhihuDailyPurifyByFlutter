import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/HotNewsModel.dart';
import 'package:daily_purify/mvp/repository/StoriesRepository.dart';
import 'package:daily_purify/net/Apis.dart';
import 'package:daily_purify/net/DioFactory.dart';
import 'package:dio/dio.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  @override
  Future<BaseModel<HotNewsModel>> loadNews(String date) {
    return _getNews(date);
  }
}

Future<BaseModel<HotNewsModel>> _getNews(String date) async {
  Dio dio =DioFactory.getInstance().getDio();

  String url;

  if(null == date){
     url = Constant.baseUrl + Apis.latest;
  }else{
     url = Constant.baseUrl + Apis.before + date;
  }

  print(url);

  int code;

  String errorMsg;

  HotNewsModel hotNewsStoriesModel;

  BaseModel<HotNewsModel> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {

      String date = response.data['date'];

      List stories = response.data['stories'];

      List topStories = response.data['top_stories'];

      List<HotNewsTopStoriesModel> topStoriesList;

      List<HotNewsStoriesModel> storiesList = stories.map((model) {
        return new HotNewsStoriesModel.fromJson(model);
      }).toList();

      //topStories根据接口只有当天有，过去时间的topStories为空
      if (topStories != null && topStories.isNotEmpty) {
        topStoriesList = topStories.map((model) {
          return new HotNewsTopStoriesModel.fromJson(model);
        }).toList();
      }

      hotNewsStoriesModel = new HotNewsModel(
          date: date, stories: storiesList, topStories: topStoriesList);
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(
        code: code, errorMsg: errorMsg, data: hotNewsStoriesModel);
  }

  return model;
}
