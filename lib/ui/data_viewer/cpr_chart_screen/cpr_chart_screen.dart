import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class CprChartScreenArguments {
  final String caseId;

  CprChartScreenArguments({required this.caseId});
}

class CprChartScreen extends StatefulWidget {
  const CprChartScreen({super.key});

  @override
  CprChartScreenState createState() => CprChartScreenState();
}

class CprChartScreenState extends State<CprChartScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
  String chartType = 'Pads';
  Map<String, double> minY = {
    'Pads': -2500,
    'CO2 mmHg, Waveform': 0,
    'Pads Impedance': -125,
  };
  Map<String, double> maxY = {
    'Pads': 2500,
    'CO2 mmHg, Waveform': 100,
    'Pads Impedance': 125,
  };
  Map<String, double> majorInterval = {
    'Pads': 2500,
    'CO2 mmHg, Waveform': 100,
    'Pads Impedance': 125,
  };
  Map<String, double> minorInterval = {
    'Pads': 500,
    'CO2 mmHg, Waveform': 100,
    'Pads Impedance': 125,
  };
  Map<String, String Function(double)> labelFormat = {
    'Pads': (x) => (x / 1000).toStringAsFixed(1),
    'CO2 mmHg, Waveform': (x) => "${x.toInt()}%",
    'Pads Impedance': (x) => x.toStringAsFixed(0),
  };
  Case? myCase;
  bool hasNewData = false;
  late ZollSdkHostApi _hostApi;
  ReactionDisposer? reactionDisposer;

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
    reactionDisposer?.call();
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as CprChartScreenArguments;
    caseId = args.caseId;

    _hostApi = context.read();
    _zollSdkStore = context.read();
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
    reactionDisposer?.call();
    reactionDisposer = autorun((_) {
      final storeCase = _zollSdkStore.cases[caseId];
      if (storeCase != null && myCase == null) {
        setState(() {
          myCase = storeCase;
        });
      } else if (myCase != null && storeCase == null) {
        setState(() {
          hasNewData = false;
        });
      } else if (myCase != null && storeCase != null) {
        setState(() {
          if (myCase!.events.length != storeCase.events.length) {
            hasNewData = true;
          }
        });
      }
    });

    final tempDir = await getTemporaryDirectory();
    await _loadTestData();
    _hostApi.deviceDownloadCase(
        _zollSdkStore.selectedDevice!, caseId, tempDir.path, null);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      title: "CPR品質の計算",
    );
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
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: "CPR品質の計算",
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
    return Row(
      children: [
        AppNavigationRail(selectedIndex: 4, caseId: caseId),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Stack(
            children: <Widget>[
              // _handleErrorMessage(),
              myCase != null
                  ? _buildMainContent()
                  : const CustomProgressIndicatorWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ...myCase!.waves.keys.map(
                  (e) => IntrinsicWidth(
                    child: ListTile(
                      title: Text(e),
                      leading: Radio<String>(
                        value: e,
                        groupValue: chartType,
                        onChanged: (String? value) {
                          if (value == null) return;
                          setState(() {
                            chartType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            myCase!.waves[chartType]!.samples.isNotEmpty
                ? EcgChart(
                    samples: myCase!.waves[chartType]!.samples,
                    cprCompressions: myCase!.cprCompressions,
                    ventilationTimestamps: myCase!
                        .waves['CO2 mmHg, Waveform']!.samples
                        .where((element) => element.status == 1)
                        .map((e) => e.timestamp)
                        .toList(),
                    initTimestamp:
                        myCase!.waves[chartType]!.samples.first.timestamp,
                    segments: 4,
                    initDuration: const Duration(minutes: 1),
                    minY: minY[chartType]!,
                    maxY: maxY[chartType]!,
                    majorInterval: majorInterval[chartType]!,
                    minorInterval: minorInterval[chartType]!,
                    labelFormat: labelFormat[chartType]!,
                  )
                : Container(),
            _buildTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return DataTable(
      columns: const [
        DataColumn(
            label: Expanded(
          child: Text("分", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("秒胸骨圧迫なし", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("換気", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("CO2換気", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("換気リード", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("胸骨圧迫回数", softWrap: true),
        )),
        DataColumn(
            label: Expanded(
          child: Text("平均胸骨圧迫圧迫深", softWrap: true),
        )),
      ],
      rows: myCase!.cprCompressionByMinute
          .map((e) => DataRow(cells: [
                DataCell(Text(e.minute.toString())),
                DataCell(Text(e.secondsNotInCompressions.toString())),
                const DataCell(Text("0")),
                DataCell(Text(e.ventilations.toString())),
                const DataCell(Text("0")),
                DataCell(Text(e.compressionCount.toString())),
                DataCell(Text(e.averageCompDisp.toStringAsFixed(2))),
              ]))
          .toList(),
    );
  }
}
