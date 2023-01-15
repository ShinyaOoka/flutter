import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/extension.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app.dart';
import 'app/di/injection.dart';
import 'app/module/local_storage/shared_pref_manager.dart';
import 'flavors.dart';

//event bus global
EventBus eventBus = EventBus();
// db global
final dbHelper = DBHelper();

Future<void> main() async {
  F.appFlavor = Flavor.DEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //Start DI
  await SharedPrefManager.getInstance();
  await configureDependencies();
  initApp();
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

Future<void> initApp() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  Utils.configLoading();
  await dbHelper.initDb();
  Utils.pushDataToDb();
}

