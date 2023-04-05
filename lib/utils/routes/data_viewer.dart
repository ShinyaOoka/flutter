import 'package:ak_azm_flutter/ui/data_viewer/choose_function_screen/choose_function_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_case_screen/list_case_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/mock_screen/mock_screen.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_device_screen/list_device_screen.dart';

class DataViewerRoutes {
  const DataViewerRoutes();

  //static variables
  static const String dataViewerListDevice = '/data_viewer/list_device';
  static const String dataViewerListCase = '/data_viewer/list_case';
  static const String dataViewerListEvent = '/data_viewer/list_event';
  static const String dataViewerChooseFunction = '/data_viewer/choose_function';
  static const String dataViewerMock = '/data_viewer/mock';

  static final routes = <String, WidgetBuilder>{
    dataViewerListDevice: (BuildContext context) => const ListDeviceScreen(),
    dataViewerListCase: (BuildContext context) => const ListCaseScreen(),
    dataViewerListEvent: (BuildContext context) => const ListEventScreen(),
    dataViewerChooseFunction: (BuildContext context) =>
        const ChooseFunctionScreen(),
    dataViewerMock: (BuildContext context) => const MockScreen(),
  };
}
