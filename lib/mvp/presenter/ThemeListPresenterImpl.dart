import 'package:daily_purify/mvp/presenter/ThemeListPresenter.dart';
import 'package:daily_purify/mvp/repository/ThemeListRepository.dart';
import 'package:daily_purify/mvp/repository/ThemeListRepositoryImpl.dart';

class ThemeListPresenterImpl implements ThemeListPresenter {

  ThemeListView _view;

  ThemeListRepository _repository;

  ThemeListPresenterImpl(this._view) {
    _view.setPresenter(this);
  }


  @override
  loadThemeList(String themeId, String lastId) {
    assert(_view != null);
    _repository.loadThemeList(themeId,lastId).then((data) {
      _view.onLoadThemeListSuc(data);
    }).catchError((error) {
      _view.onLoadThemeListFail();
    });
  }

  @override
  init() {
    _repository = new ThemeListRepositoryImpl();
  }

}
