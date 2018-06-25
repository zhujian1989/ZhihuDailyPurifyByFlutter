import 'package:daily_purify/mvp/presenter/comment_presenter.dart';
import 'package:daily_purify/mvp/repository/comment_repository.dart';
import 'package:daily_purify/mvp/repository/comment_repository_impl.dart';

class CommentPresenterImpl implements CommentPresenter {
  CommentView _view;

  CommentRepository _repository;

  CommentPresenterImpl(this._view) {
    _view.setPresenter(this);
  }

  @override
  init() {
    _repository = new CommentRepositoryImpl();
  }

  @override
  loadLongComments(String id) {
    assert(_view != null);
    _repository.loadLongComments(id).then((data) {
      _view.onLoadLongCommentsSuc(data);
    }).catchError((error) {
      _view.onLoadLongCommentsFail();
    });
  }

  @override
  loadShortComments(String id) {
    assert(_view != null);
    _repository.loadShortComments(id).then((data) {
      _view.onLoadShortCommentsSuc(data);
    }).catchError((error) {
      _view.onLoadShortCommentsFail();
    });
  }
}
