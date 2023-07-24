import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_analysis_screen/cpr_analysis_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_chart_screen/cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/full_ecg_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/info_screen/info_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_snapshot_screen/list_snapshot_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_twelve_lead_screen/list_twelve_lead_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/mock_screen/mock_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:localization/localization.dart';

class ChooseFunctionScreenArguments {
  final String caseId;

  ChooseFunctionScreenArguments({required this.caseId});
}

class ChooseFunctionScreen extends StatefulWidget {
  const ChooseFunctionScreen({super.key});

  @override
  _ChooseFunctionScreenState createState() => _ChooseFunctionScreenState();
}

class _ChooseFunctionScreenState extends State<ChooseFunctionScreen>
    with RouteAware {
  String? caseId;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    _routeObserver.unsubscribe(this);
  }

  @override
  void didPush() {
    final args = ModalRoute.of(context)!.settings.arguments
        as ChooseFunctionScreenArguments;
    caseId = args.caseId;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      title: '機能選択',
      body: _buildBody(),
      icon: Icon(Icons.home),
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const SizedBox(
        width: 12,
        child: Icon(Icons.arrow_back_ios),
      ),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        // _handleErrorMessage(),
        _buildMainContent()
      ],
    );
  }

  Widget _buildMainContent() {
    return ListView(children: [
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("一般"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerInfo,
              arguments: InfoScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("ECG全体"),
        onTap: () {
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerFullEcgEvent,
              arguments: FullEcgChartScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("イベント"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerListEvent,
              arguments: ListEventScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("CPR解析"),
        onTap: () {
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerCprAnalysis,
              arguments: CprAnalysisScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("CPR品質の計算"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerCprChart,
              arguments: CprChartScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("12誘導"),
        onTap: () {
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerListTwelveLead,
              arguments: ListTwelveLeadScreenArguments(caseId: caseId!));
        },
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: const Text("スナップショット"),
        onTap: () {
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerListSnapshot,
              arguments: ListSnapshotScreenArguments(caseId: caseId!));
        },
      )
    ]);
  }
}
