import 'package:ak_azm_flutter/app/app.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/local_storage/shared_pref_manager.dart';
import 'package:ak_azm_flutter/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/di/injection.dart';
import 'flavors.dart';

Future<void> main() async {
  F.appFlavor = Flavor.PRODUCTION;
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

