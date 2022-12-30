import 'package:ak_azm_flutter/app/view/confirm_report/confirm_report_page.dart';

import '../../di/injection.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class EditReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void openConfirmReport() async {
    _navigationService.pushScreenWithFade(ConfirmReportPage());
  }

  EditReportViewModel(this._dataRepo);

  void initData() {}
}
