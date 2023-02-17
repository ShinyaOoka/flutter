import 'package:ak_azm_flutter/ui/edit_report_screen/edit_report_screen.dart';
import 'package:ak_azm_flutter/ui/list_case_screen/list_case_screen.dart';
import 'package:ak_azm_flutter/ui/list_event_screen/list_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/list_device_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/ui/create_report_screen/create_report_screen.dart';
import 'package:ak_azm_flutter/ui/list_report_screen/list_report_screen.dart';
import 'package:ak_azm_flutter/ui/confirm_report_screen/confirm_report_screen.dart';
import 'package:ak_azm_flutter/ui/preview_report_screen/preview_report_screen.dart';
import 'package:ak_azm_flutter/ui/send_report_screen/send_report_screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String listReport = '/list_report';
  static const String createReport = '/create_report';
  static const String editReport = '/edit_report';
  static const String confirmReport = '/confirm_report';
  static const String sendReport = '/send_report';
  static const String previewReport = '/preview_report';
  static const String listDevice = '/list_device';
  static const String listCase = '/list_case';
  static const String listEvent = '/list_event';

  static final routes = <String, WidgetBuilder>{
    listReport: (BuildContext context) => const ListReportScreen(),
    createReport: (BuildContext context) => const CreateReportScreen(),
    editReport: (BuildContext context) => const EditReportScreen(),
    confirmReport: (BuildContext context) => const ConfirmReportScreen(),
    sendReport: (BuildContext context) => const SendReportScreen(),
    previewReport: (BuildContext context) => const PreviewReportScreen(),
    listDevice: (BuildContext context) => const ListDeviceScreen(),
    listCase: (BuildContext context) => const ListCaseScreen(),
    listEvent: (BuildContext context) => const ListEventScreen(),
  };
}
