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


  Future<Response> getAvatarData(String api) async {
    return await Dio().get(getAvatarProfile());
  }

  void logout() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
    late BaseResponse baseResponse;
    final stream = call(API_DESTROY_SESSION, null);
    stream.doOnData((r) {
      baseResponse = BaseResponse.fromJson(r);
    }).doOnError((e, stacktrace) {
      if (e is DioError) baseResponse = BaseResponse.fromJson(e.response?.data.trim());
    }).doOnListen(() {
      EasyLoading.show();
    }).doOnDone(() {
      EasyLoading.dismiss();
    }).listen((_) {
      userSharePref.clearUser();
      getIt<NavigationService>().pushAndRemoveUntilWithFade(ListReportPage());
    }, onError: (e) {
      _navigationService.openErrorPage();
    });
  }


  Stream authenticate(String username, String password, String database) {
    var params = {
      "db": database,
      "login": username,
      "password": password,
      "context": {}
    };
    return call(API_AUTHENTICATE, params);
  }

  Stream getDatabases() {
    var params = {
    };
    return call(API_DATABASE_LIST, params);
  }


  Stream callKW(String model, String method,
      {String? urlPath, List? args, dynamic kwargs, Map? context}) {
    var url = urlPath ?? "/web/dataset/call_kw/$model/$method";
    var params = {
      "model": model,
      "method": method,
      "args": args ?? [],
      "kwargs": kwargs ?? {},
    };
    return call(url, params);
  }


  Stream searchRead(String model,
      {String? urlPath, List? domain,  List? fields, String? sort,  int? limit, Map? context}) {
    var url = urlPath ?? "/web/dataset/search_read";
    var params = {
      "model": model,
      "domain": domain ?? [],
      "context": context ?? {},
      "limit": limit ?? 80,
      "fields": fields ?? [],
      "sort": sort ?? '',
    };
    return call(url, params);
  }




}
