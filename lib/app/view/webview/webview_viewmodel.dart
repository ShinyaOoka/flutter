import '../../di/injection.dart';
import '../../model/webview_param.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../viewmodel/base_viewmodel.dart';

class WebviewViewModel extends BaseViewModel {
  NavigationService navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  bool _loading = true;
  WebviewParam? webviewParam;

  WebviewViewModel({this.webviewParam});

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
