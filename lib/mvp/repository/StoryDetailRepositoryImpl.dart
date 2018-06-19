import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/StoryDetailModel.dart';
import 'package:daily_purify/model/StoryExtraModel.dart';
import 'package:daily_purify/mvp/repository/StoryDetailRepository.dart';
import 'package:daily_purify/net/Apis.dart';
import 'package:daily_purify/net/DioFactory.dart';
import 'package:dio/dio.dart';

class StoryDetailRepositoryImpl implements StoryDetailRepository {
  @override
  Future<BaseModel<StoryDetailModel>> loadStoryDetail(String id) {
    return _getStoryDetail(id);
  }

  @override
  Future<BaseModel<StoryExtraModel>> loadStoryExtra(String id) {

    return _getStoryExtra(id);
  }
}

Future<BaseModel<StoryExtraModel>> _getStoryExtra(String id) async {
  Dio dio = new DioFactory(new Dio()).getDio();

  String url = Constant.baseUrl + Apis.story_extra + id;

  print(url);

  int code;

  String errorMsg;

  StoryExtraModel storyExtraModel;

  BaseModel<StoryExtraModel> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      storyExtraModel = StoryExtraModel.fromJson(response.data);
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model =
    new BaseModel(code: code, errorMsg: errorMsg, data: storyExtraModel);
  }

  return model;
}


Future<BaseModel<StoryDetailModel>> _getStoryDetail(String id) async {
  Dio dio = new DioFactory(new Dio()).getDio();

  String url = Constant.baseUrl + Apis.detail + id;

  print(url);

  int code;

  String errorMsg;

  StoryDetailModel storyDetailModel;

  BaseModel<StoryDetailModel> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      storyDetailModel = StoryDetailModel.fromJson(response.data);
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model =
        new BaseModel(code: code, errorMsg: errorMsg, data: storyDetailModel);
  }

  return model;
}
