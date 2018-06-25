import 'package:daily_purify/model/base_model.dart';
import 'package:daily_purify/model/comment_model.dart';
import 'package:daily_purify/mvp/mvp.dart';

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
