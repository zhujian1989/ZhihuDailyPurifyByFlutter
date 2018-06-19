import 'package:dio/dio.dart';

//总觉得怪怪的，但是打印出来确实是只有一个dio对象。。

class DioFactory {
  Dio _dio;

  static DioFactory _singleton;

  factory DioFactory(Dio dio) {
    if (_singleton == null) {
      _singleton = new DioFactory._internal(dio);
    }

    return _singleton;
  }

  DioFactory._internal(this._dio);

  getDio() {
    return _dio;
  }
}



