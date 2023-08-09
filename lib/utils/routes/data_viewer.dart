import 'package:ak_azm_flutter/ui/data_viewer/choose_function_screen/choose_function_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_analysis_screen/cpr_analysis_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_chart_screen/cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/ecg_chart_screen/ecg_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/expanded_cpr_chart_screen/expanded_cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/full_ecg_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/info_screen/info_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_case_screen/list_case_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_downloaded_case_screen/list_downloaded_case_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_snapshot_screen/list_snapshot_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_twelve_lead_screen/list_twelve_lead_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/mock_screen/mock_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/snapshot_detail_screen/snapshot_detail_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/twelve_lead_chart_screen/twelve_lead_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_device_screen/list_device_screen.dart';

class DataViewerRoutes {
  const DataViewerRoutes();

  //static variables
  static const String dataViewerListDevice = '/data_viewer/list_device';
  static const String dataViewerListCase = '/data_viewer/list_case';
  static const String dataViewerInfo = '/data_viewer/info';
  static const String dataViewerListEvent = '/data_viewer/list_event';
  static const String dataViewerFullEcgEvent = '/data_viewer/full_ecg_chart';
  static const String dataViewerCprChart = '/data_viewer/cpr_chart';
  static const String dataViewerCprAnalysis = '/data_viewer/cpr_analysis';
  static const String dataViewerSnapshotDetail = '/data_viewer/snapshot_detail';
  static const String dataViewerListSnapshot = '/data_viewer/list_snapshot';
  static const String dataViewerListTwelveLead =
      '/data_viewer/list_twelve_lead';
  static const String dataViewerChooseFunction = '/data_viewer/choose_function';
  static const String dataViewerTwelveLeadChart =
      '/data_viewer/twelve_lead_chart';
  static const String dataViewerEcgChart = '/data_viewer/ecg_chart';
  static const String dataViewerExpandedEcgChart =
      '/data_viewer/expanded_ecg_chart';
  static const String dataViewerMock = '/data_viewer/mock';
  static const String dataViewerListDownloadedCase =
      '/data_viewer/list_downloaded_case';

  static final routes = <String, WidgetBuilder>{
    dataViewerListDevice: (BuildContext context) => const ListDeviceScreen(),
    dataViewerListCase: (BuildContext context) => const ListCaseScreen(),
    dataViewerListEvent: (BuildContext context) => const ListEventScreen(),
    dataViewerChooseFunction: (BuildContext context) =>
        const ChooseFunctionScreen(),
    dataViewerMock: (BuildContext context) => const MockScreen(),
    dataViewerEcgChart: (BuildContext context) => const EcgChartScreen(),
    dataViewerTwelveLeadChart: (BuildContext context) =>
        const TwelveLeadChartScreen(),
    dataViewerListTwelveLead: (BuildContext context) =>
        const ListTwelveLeadScreen(),
    dataViewerListSnapshot: (BuildContext context) =>
        const ListSnapshotScreen(),
    dataViewerSnapshotDetail: (BuildContext context) =>
        const SnapshotDetailScreen(),
    dataViewerCprChart: (BuildContext context) => const CprChartScreen(),
    dataViewerCprAnalysis: (BuildContext context) => const CprAnalysisScreen(),
    dataViewerFullEcgEvent: (BuildContext context) =>
        const FullEcgChartScreen(),
    dataViewerInfo: (BuildContext context) => const InfoScreen(),
    dataViewerExpandedEcgChart: (BuildContext context) =>
        const ExpandedCprChartScreen(),
    dataViewerListDownloadedCase: (BuildContext context) =>
        const ListDownloadedCaseScreen(),
  };
}
