import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../flavors.dart';
import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../common/config.dart';
import '../common/navigator_screen.dart';
import '../local_storage/shared_pref_manager.dart';
import 'network_util.dart';

var dio = AppDio.getInstance();

// ignore: prefer_mixin
class AppDio with DioMixin implements Dio {
  AppDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: getIt<UserSharePref>().getLoginConfig()?.getBaseUrl() ?? '',
      contentType: 'application/json',
      connectTimeout: CONNECT_TIMEOUT,
      sendTimeout: WRITE_TIMEOUT,
      receiveTimeout: READ_TIMEOUT,
    );
    this.options = options;
    interceptors.clear();
    interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        //final appToken = getIt<UserSharePref>().getAppToken();
        options.headers.addAll(headers);
        handler.next(options);
      },
      onError: (error, handler) async {
        switch (error.type) {
          case DioErrorType.connectTimeout:
            handler.next(error);
            break;
          case DioErrorType.sendTimeout:
            handler.next(error);
            break;
          case DioErrorType.receiveTimeout:
            handler.next(error);
            break;
          case DioErrorType.response:
            if (error.response?.statusCode == 401) {
              _handleTokenExpired(error, handler);
            }
            break;
          case DioErrorType.cancel:
            handler.next(error);
            break;
          case DioErrorType.other:
            handler.next(error);
            return;
        }
      },
    ));

    if (kDebugMode) {
      // Local Log
      interceptors.add(
          PrettyDioLogger(
              requestHeader: false,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: false,
              request: false,
              maxWidth: 100000)
          /*LogInterceptor(responseBody: true, requestBody: true)*/);
    }

    httpClientAdapter = DefaultHttpClientAdapter();
  }

  static Dio getInstance() => AppDio._();

  void _handleTokenExpired(DioError error, ErrorInterceptorHandler handler) {
    getIt<UserSharePref>().clearUser();
    getIt<NavigationService>().openErrorPage(message: LocaleKeys.session_expired.tr());
  }
}
