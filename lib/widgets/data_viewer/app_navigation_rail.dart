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

  static const icons = [
    'assets/icons/C_Case.png',
    'assets/icons/General.png',
    'assets/icons/ECG.png',
    'assets/icons/Event.png',
    'assets/icons/Graph.png',
    'assets/icons/Calc.png',
    'assets/icons/12LeadSnapshot.png',
    'assets/icons/Snapshot.png',
  ];

  static const selectedIcons = [
    'assets/icons/C_Case.png',
    'assets/icons/C_General.png',
    'assets/icons/C_ECG.png',
    'assets/icons/C_Event.png',
    'assets/icons/C_Graph.png',
    'assets/icons/C_Calc.png',
    'assets/icons/C_12LeadSnapshot.png',
    'assets/icons/C_snapshot.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: NavigationRail(
          groupAlignment: -1,
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
                icon: _buildIcon(0), label: Text('Case\n選択')),
            NavigationRailDestination(icon: _buildIcon(1), label: Text('一般')),
            NavigationRailDestination(
                icon: _buildIcon(2), label: Text('全体\nECG')),
            NavigationRailDestination(icon: _buildIcon(3), label: Text('イベント')),
            NavigationRailDestination(
                icon: _buildIcon(4), label: Text('CPR\n解析')),
            NavigationRailDestination(
                icon: _buildIcon(5),
                label: Text('CPR品質\n計算', textAlign: TextAlign.center)),
            NavigationRailDestination(
                icon: _buildIcon(6), label: Text('12Lead')),
            NavigationRailDestination(
                icon: _buildIcon(7), label: Text('スナップ\nショット')),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            Navigator.of(context).popUntil((route) => ModalRoute.withName(
                DataViewerRoutes.dataViewerChooseFunction)(route));
            if (index == 0) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListCase,
              );
            } else if (index == 1) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerInfo,
                arguments: InfoScreenArguments(caseId: caseId),
              );
            } else if (index == 2) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerFullEcgEvent,
                arguments: FullEcgChartScreenArguments(caseId: caseId),
              );
            } else if (index == 3) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListEvent,
                arguments: ListEventScreenArguments(caseId: caseId),
              );
            } else if (index == 4) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerCprAnalysis,
                arguments: CprAnalysisScreenArguments(caseId: caseId),
              );
            } else if (index == 5) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerCprChart,
                arguments: CprChartScreenArguments(caseId: caseId),
              );
            } else if (index == 6) {
              Navigator.of(context).pushNamed(
                DataViewerRoutes.dataViewerListTwelveLead,
                arguments: ListTwelveLeadScreenArguments(caseId: caseId),
              );
            } else if (index == 7) {
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

  Image _buildIcon(int i) =>
      Image.asset(selectedIndex == i ? selectedIcons[i] : icons[i],
          width: 20, height: 20);
}
