import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../model/device_param.dart';
import '../common/navigator_screen.dart';
import '../common/toast_util.dart';
import '../local_storage/shared_pref_manager.dart';
import 'dio_module.dart';

Future _get(String url, {Map<String, dynamic>? params}) async {
  params ??= <String, dynamic>{};
  /*PackageInfo packageInfo = await PackageInfo.fromPlatform();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  DeviceParam deviceParam = DeviceParam();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceParam = DeviceParam(
        deviceType: 4,
        deviceId: androidInfo.androidId,
        osVersion: androidInfo.version.release,
        modelName: androidInfo.model);
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    deviceParam = DeviceParam(
        deviceType: 3,
        deviceId: iosDeviceInfo.identifierForVendor,
        osVersion: iosDeviceInfo.systemVersion,
        modelName: iosDeviceInfo.model);
  }
  params.putIfAbsent(
      'device_type', () => deviceParam.deviceType ?? ''); // 2: android
  params.putIfAbsent('device_id', () => deviceParam.deviceId ?? '');
  params.putIfAbsent(
      'device_token', () => getIt<UserSharePref>().getFirebaseToken());
  params.putIfAbsent('os_version', () => deviceParam.osVersion ?? '');
  params.putIfAbsent('app_version', () => packageInfo.version);
  params.putIfAbsent('model_name', () => deviceParam.modelName ?? '');*/



  try {
    var response = await dio.get(
      url,
      // options: Options(
      //   headers: {
      //     "X-APP-TOKEN": "76339b6ace3aaff2658c4c5c579cff369b64723d",
      //   },
      // ),
      queryParameters: params,
    );
    return response.data;
  } on DioError catch (err) {
    print(err);
    dispatchFailure(getIt<NavigationService>().context, err);
    return null;
  }
}

Future _post(String url, Map<String, dynamic>? params) async {
  if (params == null) {
    params = new Map<String, dynamic>();
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  DeviceParam deviceParam = DeviceParam();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceParam = DeviceParam(
        deviceType: 4,
        deviceId: androidInfo.androidId,
        osVersion: androidInfo.version.release,
        modelName: androidInfo.model);
  } else if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    deviceParam = DeviceParam(
        deviceType: 3,
        deviceId: iosDeviceInfo.identifierForVendor,
        osVersion: iosDeviceInfo.systemVersion,
        modelName: iosDeviceInfo.model);
  }
  // common parameter
  params.putIfAbsent(
      'device_type', () => deviceParam.deviceType ?? ''); // 2: android
  params.putIfAbsent('device_id', () => deviceParam.deviceId ?? '');
  params.putIfAbsent(
      'device_token', () => getIt<UserSharePref>().getFirebaseToken());
  params.putIfAbsent('os_version', () => deviceParam.osVersion ?? '');
  params.putIfAbsent('app_version', () => packageInfo.version);
  params.putIfAbsent('model_name', () => deviceParam.modelName ?? '');
  var formData = FormData.fromMap(params);
  try {
    var response = await dio.post(url, data: formData);
    return response.data;
  } on DioError catch (err) {
    print(err);
    dispatchFailure(getIt<NavigationService>().context, err);
    return null;
  }
}

int request_id = 0;

// Take new session from cookies and update session instance
void updateSessionIdFromCookies(Response response, {bool auth = false}) {
  // see https://github.com/dart-lang/http/issues/362
  var cookiesStr = response.headers['set-cookie'];
  if (cookiesStr == null) {
    return;
  }

  for (final cookieStr in cookiesStr) {
    try {
      final cookie = Cookie.fromSetCookieValue(cookieStr);
      if (cookie.name == 'session_id') {
        //save app token
        getIt<UserSharePref>().saveAppToken(cookie.value);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

var headers = {"Content-Type": "application/json", "Keep-Alive": "timeout=5, max=1000", "Connection": "Keep-Alive"};

Future _call(String url, params) async {
  var payload = {
    'params': params ?? {},
    'method': "call",
    'jsonrpc': "2.0",
    'id': ++request_id,
  };
  String? sessionId = getIt<UserSharePref>().getAppToken();
  var cookie = '';
  String frontendLang = '';
  if (sessionId.isNotEmpty) {
    cookie = 'session_id=' + sessionId;
  }
  if (frontendLang.isNotEmpty) {
    if (cookie.isEmpty) {
      cookie = 'frontend_lang=$frontendLang';
    } else {
      cookie += '; frontend_lang=$frontendLang';
    }
  }
  if (cookie.isNotEmpty) {
    headers['Cookie'] = cookie;
  }
  String message = '';
  try {
    Response response = await dio.post(url,
        data: json.encode(payload), options: Options(headers: headers));
    updateSessionIdFromCookies(response);
    var result = response.data;
    if (result['error'] != null) {
     message = handleOdooError(result);
      return DioError(requestOptions: RequestOptions(path: url), error:  message);
    }
    return response.data;
  } on DioError catch (err) {
    print(err);
    message = dispatchFailure(getIt<NavigationService>().context, err);
    return DioError(requestOptions: RequestOptions(path: url), error: message);
  }
}

Stream post(String url, {Map<String, dynamic>? params}) =>
    Stream.fromFuture(_post(url, params)).asBroadcastStream();

Stream get(String url, {Map<String, dynamic>? params}) =>
    Stream.fromFuture(_get(url, params: params)).asBroadcastStream();

Stream call(String url, params) =>
    Stream.fromFuture(_call(url, params)).asBroadcastStream();

String dispatchFailure(BuildContext context, dynamic e) {
  var message = e.toString();
  if (e is DioError) {
    final response = e.response;
    if (response?.statusCode == 401) {
      message = LocaleKeys.unauthorized_access_is_denied_due_to_invalid_credentials.tr();
    } else if (403 == response?.statusCode) {
      message = LocaleKeys.forbidden_you_dont_have_permission_to_access_on_this_server.tr();
    } else if (404 == response?.statusCode) {
      message = LocaleKeys.page_not_found.tr();
    } else if (500 == response?.statusCode) {
      message = LocaleKeys.server_internal_error.tr();
    } else if (503 == response?.statusCode) {
      message = LocaleKeys.server_unavailable.tr();
    } else if (e.error is SocketException) {
      message = LocaleKeys.can_t_connect_to_server.tr();
    } else {
     // message = 'Oops!!';
      message = LocaleKeys.server_internal_error.tr();
    }
  }
  print('error ：' + message);
  if (context != null) {
    //ToastUtil.showToast(message);
  }
  return message;
}


String handleOdooError(var result) {
  var message = result['error']['message'];
  var code = result['error']['code'];
  switch(code){
    case 100: // session expired
      getIt<UserSharePref>().saveAppToken(null);
      return LocaleKeys.session_expired.tr();
    case 200:
     return result['error']['data']['message'];
    default:
      return LocaleKeys.an_unexpected_error_has_occurred.tr();
  }
}