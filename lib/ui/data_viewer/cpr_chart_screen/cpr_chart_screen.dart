import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';
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
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as CprChartScreenArguments;
    caseId = args.caseId;

    _hostApi = context.read();
    _zollSdkStore = context.read();
    await _zollSdkStore.downloadCaseCompleter?.future;
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadingWidth: 88,
      title: "CPR品質の計算",
      icon: Image.asset('assets/icons/C_Calc.png', width: 20, height: 20),
    );
  }

  Widget _buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(selectedIndex: 5, caseId: caseId),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Stack(
            children: <Widget>[
              // _handleErrorMessage(),
              myCase != null
                  ? _buildMainContent()
                  : CustomProgressIndicatorWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {
    final items = myCase!.waves.keys.where((e) => [
          'Pads',
          'CO2 mmHg, Waveform',
          'Pads Impedance',
        ].contains(e));
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  Text("表示グラフ"),
                  SizedBox.square(dimension: 16),
                  DropdownButton<String>(
                    value: items.contains(chartType) ? chartType : null,
                    items: items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (x) {
                      setState(() {
                        chartType = x!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox.square(dimension: 16),
            EcgChart(
              showGrid: true,
              samples: myCase!.waves[chartType]?.samples ?? [],
              cprCompressions: myCase!.cprCompressions,
              ventilationTimestamps:
                  (myCase!.waves[chartType]?.samples ?? []).isNotEmpty
                      ? myCase!.waves['CO2 mmHg, Waveform']!.samples
                          .where((element) => element.status == 1)
                          .map((e) => e.timestamp)
                          .toList()
                      : [],
              initTimestamp:
                  myCase!.waves[chartType]?.samples.firstOrNull?.timestamp ?? 0,
              segments: 4,
              initDuration: const Duration(minutes: 1),
              minY: minY[chartType]!,
              maxY: maxY[chartType]!,
              majorInterval: majorInterval[chartType]!,
              minorInterval: minorInterval[chartType]!,
              labelFormat: labelFormat[chartType]!,
            ),
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
          child: Text(
            "分",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "秒胸骨圧迫なし",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "換気",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "CO2換気",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "換気リード",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "胸骨圧迫回数",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
        DataColumn(
            label: Expanded(
          child: Text(
            "平均胸骨圧迫圧迫深",
            softWrap: true,
            style: TextStyle(color: Color(0xff0082C8)),
          ),
        )),
      ],
      rows: myCase!.cprCompressionByMinute
          .map((e) => DataRow(cells: [
                DataCell(Center(
                  child: Text(e.minute.toString()),
                )),
                DataCell(Center(
                  child: Text(e.secondsNotInCompressions.toString()),
                )),
                const DataCell(Center(
                  child: Text("0"),
                )),
                DataCell(Center(
                  child: Text(e.ventilations.toString()),
                )),
                const DataCell(Center(child: Text("0"))),
                DataCell(Center(
                  child: Text(e.compressionCount.toString()),
                )),
                DataCell(Center(
                  child: Text(e.averageCompDisp.toStringAsFixed(2)),
                )),
              ]))
          .toList(),
      dataRowColor:
          MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
      border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white, width: 5)),
    );
  }
}
