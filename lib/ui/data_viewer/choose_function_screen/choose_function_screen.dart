import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_analysis_screen/cpr_analysis_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/cpr_chart_screen/cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/full_ecg_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/info_screen/info_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_snapshot_screen/list_snapshot_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_twelve_lead_screen/list_twelve_lead_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
  late String caseId;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  late ZollSdkStore _zollSdkStore;
  late ZollSdkHostApi _hostApi;
  bool loading = false;
  ReactionDisposer? lostDeviceReactionDisposer;

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
    lostDeviceReactionDisposer?.call();
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args = ModalRoute.of(context)!.settings.arguments
        as ChooseFunctionScreenArguments;
    caseId = args.caseId;
    _zollSdkStore = context.read();
    _hostApi = context.read();

    lostDeviceReactionDisposer?.call();
    lostDeviceReactionDisposer =
        reaction((_) => _zollSdkStore.selectedDevice, (device) {
      if (device == null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('接続が解除されている'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) =>
                            ModalRoute.withName(
                                DataViewerRoutes.dataViewerListDevice)(route));
                      },
                      child: const Text('接続機器変更'))
                ],
              );
            });
      }
    });

    if (_zollSdkStore.cases[caseId] == null) {
      final tempDir = await getTemporaryDirectory();
      _zollSdkStore.downloadCaseCompleter = Completer();
      switch (_zollSdkStore.caseOrigin) {
        case CaseOrigin.test:
          await _loadTestData();
          break;
        case CaseOrigin.device:
          _hostApi.deviceDownloadCase(
              _zollSdkStore.selectedDevice!, caseId, tempDir.path, null);
          break;
        case CaseOrigin.downloaded:
          break;
      }
    }
  }

  Future<void> _loadTestData() async {
    final tempDir = await getTemporaryDirectory();
    await File('${tempDir.path}/$caseId.json').writeAsString(
        await rootBundle.loadString("assets/example/$caseId.json"));
    final caseListItem = _zollSdkStore
        .caseListItems[_zollSdkStore.selectedDevice?.serialNumber]
        ?.firstWhere((element) => element.caseId == caseId);
    final parsedCase = CaseParser.parse(
        await rootBundle.loadString("assets/example/$caseId.json"));
    _zollSdkStore.cases[caseId] = parsedCase;
    parsedCase.startTime = caseListItem?.startTime != null
        ? DateTime.parse(caseListItem!.startTime!).toLocal()
        : null;
    parsedCase.endTime = caseListItem?.endTime != null
        ? DateTime.parse(caseListItem!.endTime!).toLocal()
        : null;
    _zollSdkStore.downloadCaseCompleter?.complete();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      title: '機能選択',
      body: _buildBody(),
      icon: const Icon(Icons.home),
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
        _buildMainContent(),
        ...loading ? [CustomProgressIndicatorWidget()] : []
      ],
    );
  }

  Future<void> _checkLoading() async {
    if (_zollSdkStore.cases[caseId] != null) return;
    setState(() {
      loading = true;
    });
    await _zollSdkStore.downloadCaseCompleter!.future;
    setState(() {
      loading = false;
    });
    _zollSdkStore.downloadCaseCompleter = null;
  }

  Widget _buildMainContent() {
    return ListView(children: [
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("一般"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerInfo,
              arguments: InfoScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("ECG全体"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerFullEcgEvent,
              arguments: FullEcgChartScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("イベント"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerListEvent,
              arguments: ListEventScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("CPR解析"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerCprAnalysis,
              arguments: CprAnalysisScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("CPR品質の計算"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerCprChart,
              arguments: CprChartScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("12誘導"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerListTwelveLead,
              arguments: ListTwelveLeadScreenArguments(caseId: caseId));
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("スナップショット"),
        onTap: () async {
          await _checkLoading();
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerListSnapshot,
              arguments: ListSnapshotScreenArguments(caseId: caseId));
        },
      )
    ]);
  }
}
