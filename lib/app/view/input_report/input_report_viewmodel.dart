import 'dart:io';

import 'package:ak_azm_flutter/app/model/login_config.dart';
import 'package:ak_azm_flutter/app/module/common/snack_bar_util.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/injection.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/dio_module.dart';
import '../../module/network/response/databases_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class InputReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  final serverFC = FocusNode();
  final portFC = FocusNode();
  List<String> yesNothings = [LocaleKeys.yes_dropdown.tr(), LocaleKeys.nothing.tr()];
  List<String> no7 = ['保科　久穂',
    '大岡　慎弥',
    '中村　健',
    '鷹巣　良右',
    '柳下　清隆',
    '青木　栄介',
    '松岡　和人',
    '福島　隼人'];
  bool isExpandQualification = false;
  bool isExpandRide = false;
  String? emtQualification;
  String? no7Select;
  String? emtRide;
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

  DatabasesResponse? get databasesResponse => _databasesResponse;

  InputReportViewModel(this._dataRepo);

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
    this.emtQualification = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectRide(String? itemSelected) {
    this.emtRide = itemSelected ?? yesNothings[1];
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
    //save server config
    LoginConfig? loginConfig = userSharePref.getLoginConfig();
   /* if(loginConfig == null) loginConfig = LoginConfig(protocol: protocol, server: server, port: port);
    else {
      loginConfig.protocol = protocol;
      loginConfig.server = server;
      loginConfig.port = port;
    }*/
    await userSharePref.saveLoginConfig(loginConfig);
    dio = AppDio.getInstance();
    openSignIn();
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
          //_navigationService.pushScreenNoAnim(SignInPage(databaseList: databaseList,));
        }
      } catch (e) {
        SnackBarUtil.showSnack(title: LocaleKeys.something_is_not_right.tr(), message: LocaleKeys.please_check_your_url.tr(), snackType: SnackType.ERROR);
      } finally {
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }


  void initData() {
    LoginConfig? serverConfig = userSharePref.getLoginConfig();
    //protocol = serverConfig?.protocol ?? protocols[1];
    server = serverConfig?.server ?? '34.159.110.201';
    port = serverConfig?.port ?? '8069';
    serverController.text = server;
    portController.text = port;
    notifyListeners();
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
