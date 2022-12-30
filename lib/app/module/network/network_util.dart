import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../common/navigator_screen.dart';
import 'dio_module.dart';

Future _get(String url, {Map<String, dynamic>? params}) async {
  params ??= <String, dynamic>{};

  try {
    var response = await dio.get(
      url,
      options: Options(
        headers: {
          "X-APP-TOKEN": "",
        },
      ),
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

var headers = {
  "Content-Type": "application/json",
  "Keep-Alive": "timeout=5, max=1000",
  "Connection": "Keep-Alive"
};

Stream post(String url, {Map<String, dynamic>? params}) =>
    Stream.fromFuture(_post(url, params)).asBroadcastStream();

Stream get(String url, {Map<String, dynamic>? params}) =>
    Stream.fromFuture(_get(url, params: params)).asBroadcastStream();

String dispatchFailure(BuildContext context, dynamic e) {
  var message = e.toString();
  if (e is DioError) {
    final response = e.response;
    if (response?.statusCode == 401) {
      message = LocaleKeys
          .unauthorized_access_is_denied_due_to_invalid_credentials
          .tr();
    } else if (403 == response?.statusCode) {
      message = LocaleKeys
          .forbidden_you_dont_have_permission_to_access_on_this_server
          .tr();
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
