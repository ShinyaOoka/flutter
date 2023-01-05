import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/view/list_report/list_report_page.dart';
import 'package:ak_azm_flutter/app/view/preview_report/preview_report_page.dart';

import '../../di/injection.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class SendReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  final DTReport dtReport;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void openListReport() {
    _navigationService.pushAndRemoveUntilWithFade(ListReportPage());
  }

  void openPreviewReport(String assetFileName, {String pdfName = ''}) {
    _navigationService.pushScreenWithFade(PreviewReportPage(
      assetFile: assetFileName,
      pdfName: pdfName,
    ));
  }

  SendReportViewModel(this._dataRepo, this.dtReport);

  void initData() {}
}
