import 'package:daily_purify/mvp/presenter/theme_presenter.dart';
import 'package:daily_purify/mvp/repository/theme_repository.dart';
import 'package:daily_purify/mvp/repository/theme_repository_impl.dart';

class ThemePresenterImpl implements ThemePresenter {
  ThemeView _view;

  ThemeRepository _repository;

  ThemePresenterImpl(this._view) {
    _view.setPresenter(this);
  }

  @override
  loadThemes() {
    assert(_view != null);
    _repository.loadThemes().then((data) {
      _view.onLoadThemesSuc(data);
    }).catchError((error) {
      _view.onLoadThemesFail();
    });
  }

  @override
  init() {
    _repository = new ThemeRepositoryImpl();
  }
}
