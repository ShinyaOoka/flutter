import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ak_azm_flutter/data/local/data_sources/hospital/hospital_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/report/report_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/team/team_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/fire_station/fire_station_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/classification/classification_data_source.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/di/modules/local_module.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/zoll_sdk_flutter_api_impl.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerFactory(() => ErrorStore());

  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());

  getIt.registerSingleton(ReportDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(HospitalDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TeamDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(
      FireStationDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(
      ClassificationDataSource(await getIt.getAsync<Database>()));

  getIt.registerSingleton(Repository(
    getIt<HospitalDataSource>(),
    getIt<ReportDataSource>(),
    getIt<TeamDataSource>(),
    getIt<FireStationDataSource>(),
    getIt<ClassificationDataSource>(),
  ));

  getIt.registerFactory(() => ReportStore(getIt<Repository>()));
  getIt.registerFactory(() => TeamStore(getIt<Repository>()));
  getIt.registerFactory(() => HospitalStore(getIt<Repository>()));
  getIt.registerFactory(() => FireStationStore(getIt<Repository>()));
  getIt.registerFactory(() => ClassificationStore(getIt<Repository>()));
  getIt.registerSingleton(ZollSdkStore());

  getIt.registerFactory(() => ZollSdkHostApi());
  getIt.registerFactory(
      () => ZollSdkFlutterApiImpl(store: getIt<ZollSdkStore>()));

  getIt.registerSingleton(RouteObserver<ModalRoute<void>>());
}
