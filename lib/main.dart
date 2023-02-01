import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/ui/my_app.dart';
import 'package:ak_azm_flutter/utils/zoll_sdk_flutter_api_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  return runZonedGuarded(() async {
    runApp(MyApp());
    ZollSdkFlutterApi.setup(getIt<ZollSdkFlutterApiImpl>());
  }, (error, stack) {
    print(stack);
    print(error);
  });
}
