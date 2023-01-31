import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/choose_device_screen/choose_device_screen.dart';
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
  static const String confirmReport = '/confirm_report';
  static const String sendReport = '/send_report';
  static const String previewReport = '/preview_report';
  static const String chooseDevice = '/choose_device';

  static final routes = <String, WidgetBuilder>{
    listReport: (BuildContext context) => const ListReportScreen(),
    createReport: (BuildContext context) => const CreateReportScreen(),
    confirmReport: (BuildContext context) => const ConfirmReportScreen(),
    sendReport: (BuildContext context) => const SendReportScreen(),
    previewReport: (BuildContext context) => const PreviewReportScreen(),
    chooseDevice: (BuildContext context) => const ChooseDeviceScreen()
  };
}
