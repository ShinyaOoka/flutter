import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/flutter_easyloading/custom_animation_loading.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/flutter_easyloading/src/easy_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app.dart';
import 'app/di/injection.dart';
import 'app/model/init_data.dart';
import 'app/module/database/column_name.dart';
import 'app/module/database/data.dart';
import 'app/module/local_storage/shared_pref_manager.dart';
import 'flavors.dart';

//event bus global
EventBus eventBus = EventBus();
// get_it in a production app.
final dbHelper = DBHelper();

void main() async {
  F.appFlavor = Flavor.DEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dbHelper.initDb();
  pushDataToDb();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //Start DI
  await SharedPrefManager.getInstance();
  await configureDependencies();
  configLoading();
  runApp(
    ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder: (BuildContext context, Widget? child) => EasyLocalization(
        supportedLocales: const [localeJP],
              path: 'assets/translations',
        fallbackLocale: localeJP,
              child: const App(),
      ),
    ),
  );
}

void pushDataToDb() async {
  InitData initData = InitData.fromJson(data);
  await dbHelper.putDataToDB(tableMSTeamMember, initData.MSTeamMembers);
  await dbHelper.putDataToDB(tableMSTeam, initData.MSTeams);
  await dbHelper.putDataToDB(tableMSFireStation, initData.MSFireStations);
  await dbHelper.putDataToDB(tableMSHospital, initData.MSHospitals);
  await dbHelper.putDataToDB(tableMSClassification, initData.MSClassifications);
  await dbHelper.putDataToDB(tableMSMessage, initData.MSMessages);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..contentPadding = EdgeInsets.zero
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black26
    ..indicatorColor = Colors.white
    ..textColor = Colors.yellow
    ..maskColor = Colors.black.withOpacity(0.3)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
