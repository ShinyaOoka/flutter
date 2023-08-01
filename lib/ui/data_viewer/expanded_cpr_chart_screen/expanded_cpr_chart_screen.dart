import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/full_ecg_chart_screen.dart';
import 'package:ak_azm_flutter/widgets/expanded_ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
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

class ExpandedCprChartScreenArguments {
  final String caseId;
  final int timestamp;

  ExpandedCprChartScreenArguments(
      {required this.caseId, required this.timestamp});
}

class ExpandedCprChartScreen extends StatefulWidget {
  const ExpandedCprChartScreen({super.key});

  @override
  ExpandedCprChartScreenState createState() => ExpandedCprChartScreenState();
}

class ExpandedCprChartScreenState extends State<ExpandedCprChartScreen>
    with RouteAware, ReportSectionMixin, StripPdfMixin {
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
  late int timestamp;
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
    final args = ModalRoute.of(context)!.settings.arguments
        as ExpandedCprChartScreenArguments;
    caseId = args.caseId;
    timestamp = args.timestamp;

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
    try {
      await _loadTestData();
    } catch (e) {}
    _hostApi.deviceDownloadCase(
        _zollSdkStore.selectedDevice!, caseId, tempDir.path, null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      buildPrintButton(
          DateTime.fromMicrosecondsSinceEpoch(timestamp)
              .subtract(Duration(seconds: 3)),
          DateTime.fromMicrosecondsSinceEpoch(timestamp)
              .add(Duration(seconds: 3))),
    ];
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
      title: "拡大ECG",
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
        myCase != null
            ? _buildMainContent()
            : const CustomProgressIndicatorWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTrendDataSummary(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('ゲイン×1のグリッドサイズは1.00 s x 1.00mV',
                  textAlign: TextAlign.right),
            ),
            myCase!.waves['Pads']!.samples.isNotEmpty
                ? ExpandedEcgChart(
                    pads: myCase!.waves['Pads']!.samples,
                    co2: myCase!.waves['CO2 mmHg, Waveform']!.samples,
                    cprCompressions: myCase!.cprCompressions,
                    initTimestamp: timestamp,
                    events:
                        myCase!.displayableEvents.map((e) => e.item2).toList(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendDataSummary() {
    final trendData = myCase!.events.lastWhereOrNull((e) =>
        e.type == "TrendRpt" &&
        e.date.toLocal().microsecondsSinceEpoch <= timestamp);
    final cprCompression = myCase!.cprCompressions
        .lastWhereOrNull((e) => e.timestamp <= timestamp);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                  bottom: BorderSide(color: Colors.blue),
                )),
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  const Text('NIBP'),
                  Text(
                      "Map: ${trendData?.rawData["Trend"]["Nibp"]["Map"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "Dia: ${trendData?.rawData["Trend"]["Nibp"]["Dia"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "Sys: ${trendData?.rawData["Trend"]["Nibp"]["Sys"]["TrendData"]["Val"]["#text"]}")
                ]),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                  bottom: BorderSide(color: Colors.blue),
                )),
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  const Text("CO2"),
                  Text(
                      "Etco2: ${trendData?.rawData["Trend"]["Etco2"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "BR: ${trendData?.rawData["Trend"]["Resp"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "Fico2: ${trendData?.rawData["Trend"]["Fico2"]["TrendData"]["Val"]["#text"]}")
                ]),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                  bottom: BorderSide(color: Colors.blue),
                )),
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  const Text("SpO2"),
                  Text(
                      "SpO2: ${trendData?.rawData["Trend"]["Spo2"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "SpMet: ${trendData?.rawData["Trend"]["Spo2"]["SpMet"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "SpCo: ${trendData?.rawData["Trend"]["Spo2"]["SpCo"]["TrendData"]["Val"]["#text"]}"),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                  bottom: BorderSide(color: Colors.blue),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.blue),
                )),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                )),
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  Text(
                      "SpHB: ${trendData?.rawData["Trend"]["Spo2"]["SpHb"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "SpOC: ${trendData?.rawData["Trend"]["Spo2"]["SpOC"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "PVI: ${trendData?.rawData["Trend"]["Spo2"]["PVI"]["TrendData"]["Val"]["#text"]}"),
                  Text(
                      "PVI: ${trendData?.rawData["Trend"]["Spo2"]["PI"]["TrendData"]["Val"]["#text"]}"),
                ]),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Colors.blue),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 84,
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  const Text("CPR"),
                  Text("${cprCompression?.compDisp ?? 0 / 1000} inch"),
                  Text("${cprCompression?.compRate} cpm"),
                ]),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
