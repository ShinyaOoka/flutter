import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ak_azm_flutter/app/module/common/snack_bar_util.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../di/injection.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/dio_module.dart';
import '../../module/network/response/databases_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';


class ConfirmReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  final serverFC = FocusNode();
  final portFC = FocusNode();
  List<String> yesNothings = [LocaleKeys.yes_dropdown.tr(), LocaleKeys.nothing.tr()];
  bool isExpandQualification = false;
  bool isExpandRide = false;
  String? emt_qualification;
  String? emt_ride;
  String server = '';
  String port = '';
  var serverController = TextEditingController();
  var portController = TextEditingController();

  List<dynamic> databaseList = [];
  DatabasesResponse? _databasesResponse;

  set databasesResponse(DatabasesResponse? databasesResponse) {
    _databasesResponse = databasesResponse;
    notifyListeners();
  }

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void openSendReport() async {
    _navigationService.pushScreenWithFade(SendReportPage());
  }

  void openEditReport() async {
    _navigationService.pushScreenWithFade(EditReportPage());
  }

  DatabasesResponse? get databasesResponse => _databasesResponse;

  ConfirmReportViewModel(this._dataRepo);

  String generatedPdfFilePath = '';
  String assetInjuredPersonTransportCertificate = 'assets/report/injured_person_transport_certificate.html';

  Future<void> initData() async {
    generatedPdfFilePath = await generateExampleDocument(assetInjuredPersonTransportCertificate);
    print('Test: $generatedPdfFilePath');
    notifyListeners();
  }


  Future<String> generateExampleDocument(String assetFile) async {
    final fileHtmlContents = await rootBundle.loadString(assetFile);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    const targetFileName = "report";
    //final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(fileHtmlContents, targetPath, targetFileName);
    return '';
  }



  bool get validate =>
      (server.isNotEmpty &&
          (Utils.isURL(server) ||
              Utils.isIPv4(server) ||
              Utils.isIPv6(server))) &&
      (port.isNotEmpty && Utils.isNum(port) && port.length <= 10);

  onChangeServer(String value) {
    this.server = value.trim();
    notifyListeners();
  }

  onChangePort(String value) {
    this.port = value.trim();
    validate;
    notifyListeners();
  }

  onSelectQualification(String? itemSelected) {
    this.emt_qualification = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectRide(String? itemSelected) {
    this.emt_ride = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  String? invalidServer(String? value) {
    return value == null ||
            !(Utils.isURL(server.trim()) ||
                Utils.isIPv4(server.trim()) ||
                Utils.isIPv6(server.trim()))
        ? LocaleKeys.invalid_server.tr()
        : null;
  }

  String? invalidPort(String? value) {
    return value == null || !Utils.isNum(port) || !(port.length <= 10)
        ? LocaleKeys.invalid_port.tr()
        : null;
  }



  void submit() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);

  }

  //check is server = call api get database
  void getDatabasesApi() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
    final subscript = _dataRepo.getDatabases().doOnListen(() {
      EasyLoading.show();
    }).doOnDone(() {
      EasyLoading.dismiss();
    }).listen((r) {
      try {
        databasesResponse = DatabasesResponse.fromJson(r);
        if (databasesResponse?.result != null &&
            databasesResponse!.result is List) {
          databaseList = databasesResponse!.result ?? [];
          notifyListeners();
          /*_navigationService.pushScreenNoAnim(SignInPage(
            databaseList: databaseList,
          ));*/
        }
      } catch (e) {
        SnackBarUtil.showSnack(title: LocaleKeys.something_is_not_right.tr(), message: LocaleKeys.please_check_your_url.tr(), snackType: SnackType.ERROR);
      } finally {
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }




  void openSignIn() {
    getDatabasesApi();
  }

  bool doubleBackToExit = false;

  Future<bool> onDoubleBackToExit() async {
    if (doubleBackToExit) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    }
    doubleBackToExit = true;
    ToastUtil.showToast(LocaleKeys.press_the_back_button_to_exit.tr());
    Future.delayed(Duration(seconds: 2), () {
      doubleBackToExit = false;
    });
    return false;
  }
}
