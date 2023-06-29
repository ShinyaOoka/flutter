import 'package:ak_azm_flutter/ui/report/edit_report_screen/edit_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_case_screen/list_case_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_event_screen/list_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/report/change_device_screen/change_device_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_device_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/ui/report/create_report_screen/create_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_report_screen/list_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/confirm_report_screen/confirm_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/preview_report_screen/preview_report_screen.dart';
import 'package:ak_azm_flutter/ui/report/send_report_screen/send_report_screen.dart';

class ReportRoutes {
  ReportRoutes._();

  //static variables
  static const String reportListReport = '/report/list_report';
  static const String reportCreateReport = '/report/create_report';
  static const String reportEditReport = '/report/edit_report';
  static const String reportConfirmReport = '/report/confirm_report';
  static const String reportSendReport = '/report/send_report';
  static const String reportPreviewReport = '/report/preview_report';
  static const String reportChangeDevice = '/report/change_device';
  static const String reportListDevice = '/report/list_device';
  static const String reportListCase = '/report/list_case';
  static const String reportListEvent = '/report/list_event';

  static final routes = <String, WidgetBuilder>{
    reportListReport: (BuildContext context) => const ListReportScreen(),
    reportCreateReport: (BuildContext context) => const CreateReportScreen(),
    reportEditReport: (BuildContext context) => const EditReportScreen(),
    reportConfirmReport: (BuildContext context) => const ConfirmReportScreen(),
    reportSendReport: (BuildContext context) => const SendReportScreen(),
    reportPreviewReport: (BuildContext context) => const PreviewReportScreen(),
    reportChangeDevice: (BuildContext context) => const ChangeDeviceScreen(),
    reportListDevice: (BuildContext context) => const ListDeviceScreen(),
    reportListCase: (BuildContext context) => const ListCaseScreen(),
    reportListEvent: (BuildContext context) => const ListEventScreen(),
  };
}
