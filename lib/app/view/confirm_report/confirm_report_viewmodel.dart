import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../di/injection.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class ConfirmReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  final DTReport dtReport;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void openSendReport(DTReport dtReport) async {
    _navigationService.pushScreenWithFade(SendReportPage(dtReport: dtReport));
  }

  void openEditReport() async {
    _navigationService.pushScreenWithFade(EditReportPage());
  }

  ConfirmReportViewModel(this._dataRepo, this.dtReport);

  Future<void> initData() async {}


}
