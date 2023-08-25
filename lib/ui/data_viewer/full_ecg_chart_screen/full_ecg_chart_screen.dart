import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/ui/data_viewer/expanded_cpr_chart_screen/expanded_cpr_chart_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/full_ecg_chart_screen/strip_pdf_mixin.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
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
import 'package:collection/collection.dart';

class FullEcgChartScreenArguments {
  final String caseId;

  FullEcgChartScreenArguments({required this.caseId});
}

class FullEcgChartScreen extends StatefulWidget {
  const FullEcgChartScreen({super.key});

  @override
  _FullEcgChartScreenState createState() => _FullEcgChartScreenState();
}

class _FullEcgChartScreenState extends State<FullEcgChartScreen>
    with RouteAware, ReportSectionMixin, StripPdfMixin {
  late ZollSdkStore _zollSdkStore;
  late ZollSdkHostApi _hostApi;
  ReactionDisposer? lostDeviceReactionDisposer;
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
  bool hasNewData = false;
  bool expandOnTap = false;
  List<TimeRange> timeRanges = [
    TimeRange(color: Colors.green),
    TimeRange(color: Colors.orange),
    TimeRange(color: Color(0xff0082C8)),
  ];

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
    final args = ModalRoute.of(context)!.settings.arguments
        as FullEcgChartScreenArguments;
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
          await _zollSdkStore.downloadCaseCompleter!.future;
          break;
        case CaseOrigin.downloaded:
          break;
      }
    }

    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadingWidth: 88,
      title: "ECG全体",
      actions: _buildActions(),
      icon: Image.asset('assets/icons/C_ECG.png', width: 20, height: 20),
    );
  }

  List<Widget> _buildActions() {
    return [
      buildPrintFromTimeRangesButton(timeRanges
          .where((x) => x.endTime != null && x.startTime != null)
          .toList()),
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
    _zollSdkStore.downloadCaseCompleter?.complete();
  }

  Widget _buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(selectedIndex: 2, caseId: caseId),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Stack(
            children: <Widget>[
              // _handleErrorMessage(),
              myCase != null ? _buildMainContent() : Container(),
              generatePdfAction != null || myCase == null
                  ? CustomProgressIndicatorWidget(
                      cancellable: generatePdfAction != null,
                      onCancel: () {
                        generatePdfAction?.cancel();
                        setState(() {
                          generatePdfAction = null;
                        });
                      },
                    )
                  : Container(),
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
            AppCheckbox(
                label: 'クリックしたら拡大ECGへ移動',
                value: expandOnTap,
                onChanged: (x) => setState(() => expandOnTap = x ?? false)),
            Row(
              children: const [
                Text('印刷時間指定（長押し）'),
              ],
            ),
            Row(
              children: [
                ...timeRanges
                    .mapIndexed(
                      (i, e) => [
                        _buildSelectedTimeWidget(
                            e.color,
                            e.startTime != null
                                ? AppConstants.timeFormat.format(e.startTime!)
                                : ''),
                        const Text('〜'),
                        _buildSelectedTimeWidget(
                            e.color,
                            e.endTime != null
                                ? AppConstants.timeFormat.format(e.endTime!)
                                : ''),
                        GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () {
                              setState(() {
                                final newTimeRanges = timeRanges
                                    .whereIndexed((j, _) => j != i)
                                    .toList();
                                newTimeRanges.insert(
                                    i, TimeRange(color: e.color));
                                timeRanges = newTimeRanges;
                              });
                            }),
                        const SizedBox(width: 16),
                      ],
                    )
                    .flattened,
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text('ゲイン×1のグリッドサイズは1.00 s x 1.00mV',
                  textAlign: TextAlign.right),
            ),
            EcgChart(
              showGrid: true,
              events: myCase!.displayableEvents.map((e) => e.item2).toList(),
              samples: myCase!.waves[chartType]!.samples,
              initTimestamp:
                  myCase!.waves[chartType]!.samples.firstOrNull?.timestamp ?? 0,
              segments: 5,
              initDuration: const Duration(minutes: 1),
              minY: minY[chartType]!,
              maxY: maxY[chartType]!,
              majorInterval: majorInterval[chartType]!,
              minorInterval: minorInterval[chartType]!,
              labelFormat: labelFormat[chartType]!,
              onTap: (timestamp) {
                if (expandOnTap) {
                  Navigator.of(context).pushNamed(
                      DataViewerRoutes.dataViewerExpandedEcgChart,
                      arguments: ExpandedCprChartScreenArguments(
                          caseId: caseId, timestamp: timestamp));
                }
              },
              onLongPress: (timestamp) {
                int index = -1;
                bool isStartTime = false;
                for (int i = 0; i < timeRanges.length; i++) {
                  if (timeRanges[i].startTime == null) {
                    isStartTime = true;
                    index = i;
                    break;
                  }
                  if (timeRanges[i].endTime == null) {
                    if (timeRanges[i].startTime!.microsecondsSinceEpoch >
                        timestamp) break;
                    isStartTime = false;
                    index = i;
                    break;
                  }
                }
                if (index != -1) {
                  final newTimeRanges =
                      timeRanges.whereIndexed((i, _) => i != index).toList();
                  final newTimeRange = TimeRange(
                    color: timeRanges[index].color,
                    startTime: isStartTime
                        ? DateTime.fromMicrosecondsSinceEpoch(timestamp)
                        : timeRanges[index].startTime,
                    endTime: !isStartTime
                        ? DateTime.fromMicrosecondsSinceEpoch(timestamp)
                        : timeRanges[index].endTime,
                  );
                  newTimeRanges.insert(index, newTimeRange);
                  setState(() {
                    timeRanges = newTimeRanges;
                  });
                }
              },
              timeRanges: timeRanges,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSelectedTimeWidget(Color color, String text) {
    return Container(
      height: 20,
      width: 80,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
