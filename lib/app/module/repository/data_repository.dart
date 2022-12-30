import 'dart:async';

import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';
import 'package:ak_azm_flutter/app/module/network/response/base_response.dart';
import 'package:ak_azm_flutter/app/view/list_report/list_report_page.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/injection.dart';
import '../common/config.dart';
import '../common/extension.dart';
import '../local_storage/shared_pref_manager.dart';
import '../network/network_util.dart';

class DataRepository {
  final UserSharePref userSharePref;
  final NavigationService _navigationService = getIt<NavigationService>();

  DataRepository(
    this.userSharePref,
  );

}
