import 'package:daily_purify/mvp/presenter/theme_list_presenter.dart';
import 'package:daily_purify/mvp/repository/theme_list_repository.dart';
import 'package:daily_purify/mvp/repository/theme_list_repository_impl.dart';

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
