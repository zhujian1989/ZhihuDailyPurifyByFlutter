


class BaseModel<T>{

  final int code;

  final String errorMsg;

  final  T data;

  const BaseModel({this.code, this.errorMsg, this.data});

}
