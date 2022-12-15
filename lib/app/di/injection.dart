import 'package:ak_azm_flutter/app/view/home/home_viewmodel.dart';
import 'package:ak_azm_flutter/app/view/input_report/input_report_page.dart';
import 'package:ak_azm_flutter/app/view/input_report/input_report_viewmodel.dart';
import 'package:ak_azm_flutter/app/view/preferences/preferences_viewmodel.dart';
import 'package:get_it/get_it.dart';

import '../module/common/navigator_screen.dart';
import '../module/local_storage/shared_pref_manager.dart';
import '../module/repository/data_repository.dart';
import '../view/edit_report/edit_report_viewmodel.dart';
import '../view/list_report/list_report_viewmodel.dart';
import '../view/preview_report/preview_report_viewmodel.dart';
import '../view/send_report/send_report_viewmodel.dart';
import '../view/splash/splash_viewmodel.dart';
import '../view/webview/webview_viewmodel.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //local storage
  getIt.registerSingleton<UserSharePref>(UserSharePref());
  getIt.registerSingleton<SharedPrefManager>(SharedPrefManager());
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  //repository
  //getIt.registerFactory<SocketManager>(() => SocketManager());

  //data repository
  getIt.registerFactory<DataRepository>(() => DataRepository(
        getIt<UserSharePref>(),
       // getIt<SocketManager>(),
      ));

  //view model
  getIt.registerFactory<SplashViewModel>(
      () => SplashViewModel(getIt<DataRepository>()));


  getIt.registerFactory<HomeViewModel>(
      () => HomeViewModel(getIt<DataRepository>()));


  getIt.registerFactoryParam<WebviewViewModel, List<dynamic>, dynamic>(
      (param1, _) => //no need param2
          WebviewViewModel(webviewParam: param1[0]));

  getIt.registerFactory<PreferencesViewModel>(
          () => PreferencesViewModel(getIt<DataRepository>()));


  getIt.registerFactory<ListReportViewModel>(
          () => ListReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<InputReportViewModel>(
          () => InputReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<EditReportViewModel>(
          () => EditReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<PreviewReportViewModel>(
          () => PreviewReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<SendReportViewModel>(
          () => SendReportViewModel(getIt<DataRepository>()));
}
