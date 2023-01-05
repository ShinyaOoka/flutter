import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
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

  String generatedPdfFilePath = '';

  Future<void> initData() async {
    generatedPdfFilePath =
        await generateExampleDocument(assetInjuredPersonTransportCertificate);
    notifyListeners();
  }

  Future<String> generateExampleDocument(String assetFile) async {
    var fileHtmlContents = await rootBundle.loadString(assetFile);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        fileHtmlContents, targetPath, pdfFileName);
    return generatedPdfFile.path;
  }
}
