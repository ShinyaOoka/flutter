import 'package:ak_azm_flutter/ui/startup_screen/startup_screen.dart';
import 'package:ak_azm_flutter/ui/report/edit_report_screen/edit_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_case_screen/list_case_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/report/list_device_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/ui/report/create_report_screen/create_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_report_screen/list_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/confirm_report_screen/confirm_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/preview_report_screen/preview_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/send_report_screen/send_report_screen.dart';

class AppRoutes {
  AppRoutes._();

  //static variables
  static const String startup = '/startup';

  static final routes = Map.fromEntries(ReportRoutes.routes.entries
      .followedBy(DataViewerRoutes.routes.entries)
      .followedBy([
    MapEntry(startup, (BuildContext context) => const StartupScreen())
  ]));
}
