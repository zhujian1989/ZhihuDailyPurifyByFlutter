import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/constant.dart';
import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/story_detail_model.dart';
import 'package:daily_purify/model/story_extra_model.dart';
import 'package:daily_purify/mvp/repository/story_detail_repository.dart';
import 'package:daily_purify/net/apis.dart';
import 'package:daily_purify/net/dio_factory.dart';
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
  Dio dio =DioFactory.getInstance().getDio();

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
  Dio dio =DioFactory.getInstance().getDio();

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
