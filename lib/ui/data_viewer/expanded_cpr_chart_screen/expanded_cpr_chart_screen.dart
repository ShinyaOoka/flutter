import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/cpr_analysis_chart.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
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
    with RouteAware, ReportSectionMixin {
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
    await _loadTestData();
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
      title: "CPR拡大",
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
}
