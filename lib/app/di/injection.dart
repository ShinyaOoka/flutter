import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/view/confirm_report/confirm_report_viewmodel.dart';
import 'package:ak_azm_flutter/app/view/input_report/input_report_viewmodel.dart';
import 'package:get_it/get_it.dart';

import '../module/common/navigator_screen.dart';
import '../module/local_storage/shared_pref_manager.dart';
import '../module/repository/data_repository.dart';
import '../view/edit_report/edit_report_viewmodel.dart';
import '../view/list_report/list_report_viewmodel.dart';
import '../view/preview_report/preview_report_viewmodel.dart';
import '../view/send_report/send_report_viewmodel.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //lazy
  getIt.registerSingleton<UserSharePref>(UserSharePref());
  getIt.registerSingleton<SharedPrefManager>(SharedPrefManager());
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerSingleton<DBHelper>(DBHelper());

  //data repository
  getIt.registerFactory<DataRepository>(() => DataRepository(
        getIt<UserSharePref>(),
      ));

  //view model
  getIt.registerFactory<ListReportViewModel>(
      () => ListReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<InputReportViewModel>(
      () => InputReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<EditReportViewModel>(
      () => EditReportViewModel(getIt<DataRepository>()));
  getIt.registerFactoryParam<PreviewReportViewModel, List<dynamic>, dynamic>(
      (param1, _) => PreviewReportViewModel(
          getIt<DataRepository>(), param1[0], param1[1]));
  getIt.registerFactory<SendReportViewModel>(
      () => SendReportViewModel(getIt<DataRepository>()));
  getIt.registerFactory<ConfirmReportViewModel>(
      () => ConfirmReportViewModel(getIt<DataRepository>()));
}
