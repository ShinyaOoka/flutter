import 'package:ak_azm_flutter/ui/data_viewer/cpr_analysis_screen/cpr_analysis_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_chart_screen/cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/full_ecg_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/info_screen/info_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_snapshot_screen/list_snapshot_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_twelve_lead_screen/list_twelve_lead_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:flutter/material.dart';

class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final String caseId;
  const AppNavigationRail({
    required this.selectedIndex,
    required this.caseId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: NavigationRail(
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('一般')),
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('全体\nECG')),
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('イベント')),
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('CPR\n解析')),
            NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text(
                  'CPR品質\n計算',
                  textAlign: TextAlign.center,
                )),
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('12Lead')),
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('スナップ\nショット')),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            Navigator.of(context).popUntil((route) => ModalRoute.withName(
                DataViewerRoutes.dataViewerChooseFunction)(route));
            if (index == 0) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerInfo,
                arguments: InfoScreenArguments(caseId: caseId),
              );
            } else if (index == 1) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerFullEcgEvent,
                arguments: FullEcgChartScreenArguments(caseId: caseId),
              );
            } else if (index == 2) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListEvent,
                arguments: ListEventScreenArguments(caseId: caseId),
              );
            } else if (index == 3) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerCprAnalysis,
                arguments: CprAnalysisScreenArguments(caseId: caseId),
              );
            } else if (index == 4) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerCprChart,
                arguments: CprChartScreenArguments(caseId: caseId),
              );
            } else if (index == 5) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListTwelveLead,
                arguments: ListTwelveLeadScreenArguments(caseId: caseId),
              );
            } else if (index == 6) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListSnapshot,
                arguments: ListSnapshotScreenArguments(caseId: caseId),
              );
            }
          },
        ),
      ),
    );
  }
}
