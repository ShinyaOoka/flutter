import 'package:ak_azm_flutter/ui/top_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/ui/startup_screen/startup_screen.dart';
import 'package:ak_azm_flutter/ui/top_screen/top_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  //static variables
  static const String top = '/top';
  static const String topListDevice = '/top/list_device';
  static const String startup = '/startup';

  static final routes = Map.fromEntries(ReportRoutes.routes.entries
      .followedBy(DataViewerRoutes.routes.entries)
      .followedBy([
    MapEntry(startup, (BuildContext context) => const StartupScreen()),
    MapEntry(top, (BuildContext context) => const TopScreen()),
    MapEntry(topListDevice, (BuildContext context) => const ListDeviceScreen()),
  ]));
}
