import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../module/common/config.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/response/check_module_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../widget_utils/custom/flutter_easyloading/src/easy_loading.dart';

class HomeViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  HomeViewModel(this._dataRepo);

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
