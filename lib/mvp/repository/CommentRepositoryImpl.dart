import 'dart:async';
import 'dart:io';

import 'package:daily_purify/common/Constant.dart';
import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/CommentModel.dart';
import 'package:daily_purify/mvp/repository/CommentRepository.dart';
import 'package:daily_purify/net/Apis.dart';
import 'package:daily_purify/net/DioFactory.dart';
import 'package:dio/dio.dart';

class CommentRepositoryImpl implements CommentRepository {
  @override
  Future<BaseModel<List<CommentModel>>> loadLongComments(String id) {
    return _getLongComments(id);
  }

  @override
  Future<BaseModel<List<CommentModel>>> loadShortComments(String id) {
    return _getShortComments(id);
  }
}

Future<BaseModel<List<CommentModel>>> _getLongComments(String id) async {
  Dio dio = DioFactory.getInstance().getDio();

  String url = (Constant.baseUrl + Apis.long_comment).replaceAll('id', id);

  print(url);

  int code;

  String errorMsg;

  List<CommentModel> commentList;

  BaseModel<List<CommentModel>> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      List comments = response.data['comments'];

      commentList = comments.map((model) {
        return new CommentModel.fromJson(model);
      }).toList();

      commentList.forEach((model) {
        if (null != model.replyToJson) {
          ReplyToModel replyToModel =
              new ReplyToModel.fromJson(model.replyToJson);
          model.replyTo = replyToModel;
        }
      });
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(code: code, errorMsg: errorMsg, data: commentList);
  }

  return model;
}

Future<BaseModel<List<CommentModel>>> _getShortComments(String id) async {
  Dio dio = DioFactory.getInstance().getDio();

  String url = (Constant.baseUrl + Apis.short_comment).replaceAll('id', id);

  print(url);

  int code;

  String errorMsg;

  List<CommentModel> commentList;

  BaseModel<List<CommentModel>> model;

  try {
    Response response = await dio.get(url);

    code = response.statusCode;

    if (response.statusCode == HttpStatus.OK) {
      List comments = response.data['comments'];

      commentList = comments.map((model) {
        return new CommentModel.fromJson(model);
      }).toList();

      commentList.forEach((model) {
        if (null != model.replyToJson) {
          ReplyToModel replyToModel =
              new ReplyToModel.fromJson(model.replyToJson);
          model.replyTo = replyToModel;
        }
      });
    } else {
      errorMsg = '服务器异常';
    }
  } catch (exception) {
    errorMsg = '您的网络似乎出了什么问题';
  } finally {
    model = new BaseModel(code: code, errorMsg: errorMsg, data: commentList);
  }

  return model;
}
