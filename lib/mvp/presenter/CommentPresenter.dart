import 'package:daily_purify/model/BaseModel.dart';
import 'package:daily_purify/model/CommentModel.dart';
import 'package:daily_purify/mvp/Mvp.dart';

abstract class CommentPresenter implements IPresenter {
  loadLongComments(String id);
  loadShortComments(String id);
}

abstract class CommentView implements IView<CommentPresenter> {
  void onLoadLongCommentsSuc(BaseModel<List<CommentModel>> list);
  void onLoadLongCommentsFail();

  void onLoadShortCommentsSuc(BaseModel<List<CommentModel>> list);
  void onLoadShortCommentsFail();
}
