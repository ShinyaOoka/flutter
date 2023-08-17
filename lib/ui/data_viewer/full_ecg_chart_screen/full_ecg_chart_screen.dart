import 'dart:io';
import 'dart:ui';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/ui/data_viewer/expanded_cpr_chart_screen/expanded_cpr_chart_screen.dart';
import 'package:ak_azm_flutter/utils/chart_painter.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:ak_azm_flutter/widgets/app_date_time_picker.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;
import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';

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
  late String caseId;
  ReactionDisposer? reactionDisposer;
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
        as FullEcgChartScreenArguments;
    caseId = args.caseId;

    _zollSdkStore = context.read();
    _hostApi = context.read();

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
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      title: "ECG全体",
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return [
      buildPrintButton(null, null),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(selectedIndex: 1, caseId: caseId),
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
    return myCase!.waves[chartType]!.samples.isNotEmpty
        ? SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCheckbox(
                      label: 'クリックしたら拡大ECGへ移動',
                      value: expandOnTap,
                      onChanged: (x) =>
                          setState(() => expandOnTap = x ?? false)),
                  // DropdownButton<String>(
                  //     value: chartType,
                  //     items: myCase!.waves.keys
                  //         .map(
                  //             (e) => DropdownMenuItem(value: e, child: Text(e)))
                  //         .toList(),
                  //     onChanged: (x) {
                  //       setState(() {
                  //         chartType = x!;
                  //       });
                  //     }),
                  Row(
                    children: [
                      Text('印刷時間指定（長押し）'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSelectedTimeWidget(Colors.green, "12:34:56"),
                      Text('〜'),
                      _buildSelectedTimeWidget(Colors.green, "12:34:56"),
                      Icon(Icons.close),
                      SizedBox(width: 16),
                      _buildSelectedTimeWidget(Colors.orange, "12:34:56"),
                      Text('〜'),
                      _buildSelectedTimeWidget(Colors.orange, ""),
                      Icon(Icons.close),
                      SizedBox(width: 16),
                      _buildSelectedTimeWidget(Colors.blue, ""),
                      Text('〜'),
                      _buildSelectedTimeWidget(Colors.blue, ""),
                      Icon(Icons.close),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('ゲイン×1のグリッドサイズは1.00 s x 1.00mV',
                        textAlign: TextAlign.right),
                  ),
                  EcgChart(
                      showGrid: true,
                      samples: myCase!.waves[chartType]!.samples,
                      initTimestamp:
                          myCase!.waves[chartType]!.samples.first.timestamp,
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
                        print('onLongPress');
                      }),
                ],
              ),
            ),
          )
        : Container();
  }

  Container _buildSelectedTimeWidget(Color color, String text) {
    return Container(
      child: Align(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        alignment: Alignment.center,
      ),
      height: 20,
      width: 80,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}

class ChoosePrintTimeRangeDialog extends StatefulWidget {
  const ChoosePrintTimeRangeDialog({
    Key? key,
    required this.myCase,
    this.start,
    this.end,
  }) : super(key: key);

  final Case? myCase;
  final DateTime? start;
  final DateTime? end;

  @override
  State<ChoosePrintTimeRangeDialog> createState() =>
      _ChoosePrintTimeRangeDialogState();
}

class _ChoosePrintTimeRangeDialogState
    extends State<ChoosePrintTimeRangeDialog> {
  late DateTime selectedStartTime;
  late DateTime selectedEndTime;
  bool pads = true;
  bool resp = true;
  bool co2 = true;
  bool cprAccel = true;
  bool cprCompression = true;

  @override
  void initState() {
    super.initState();
    selectedStartTime = widget.start ?? widget.myCase!.startTime!;
    selectedEndTime = widget.end ?? widget.myCase!.endTime!;
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.start} ${widget.end}');
    return AlertDialog(
      title: const Text('時間範囲確認'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8,
            ),
            AppDateTimePicker(
                label: '開始時間',
                minTime: widget.myCase?.startTime,
                maxTime: selectedEndTime,
                defaultDate: widget.start ?? widget.myCase?.startTime,
                selectedDate: selectedStartTime,
                clearable: false,
                onChanged: (value) {
                  setState(() {
                    selectedStartTime = value ?? selectedStartTime;
                  });
                }),
            AppDateTimePicker(
                label: '終了時間',
                minTime: selectedStartTime,
                maxTime: widget.myCase?.endTime,
                defaultDate: widget.end ?? widget.myCase?.endTime,
                selectedDate: selectedEndTime,
                clearable: false,
                onChanged: (value) {
                  setState(() {
                    selectedEndTime = value ?? selectedEndTime;
                  });
                }),
            CheckboxListTile(
              dense: true,
              value: pads,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('パッド'),
              onChanged: (value) {
                setState(() {
                  pads = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              value: co2,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('CO2'),
              onChanged: (value) {
                setState(() {
                  co2 = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              value: resp,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('換気'),
              onChanged: (value) {
                setState(() {
                  resp = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              value: cprAccel,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('CPR波形'),
              onChanged: (value) {
                setState(() {
                  cprAccel = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              value: cprCompression,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('CPRバー'),
              onChanged: (value) {
                setState(() {
                  cprCompression = value ?? false;
                });
              },
            ),
            const Text("10秒間のグラフ生成に1秒程度時間がかかります。\n長時間のグラフ生成時はご注意ください。"),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context, [
              selectedStartTime,
              selectedEndTime,
              pads,
              co2,
              resp,
              cprAccel,
              cprCompression
            ]);
          },
        ),
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}

mixin StripPdfMixin<T extends StatefulWidget> on State<T> {
  Case? myCase;
  CancelableOperation? generatePdfAction;

  Future<pw.MemoryImage> _buildPdfPadsChart(
      List<Sample> samples, List<CaseEvent> events) async {
    const scale = 1.0;
    const gridSize = 10.0;
    const tickSize = 5.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    final bluePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(
        canvas, "パッド 1.0 cm/mV 25 mm/秒", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintGrid(canvas, redPaint, 10, 50, gridSize,
        leftTickInterval: 5,
        topTickInterval: 5,
        bottomTickInterval: 5,
        tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 7);
    canvas.clipRect(
        const Rect.fromLTRB(0, -gridSize * 5, gridSize * 50, gridSize * 5));
    ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.02);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    events.forEachIndexed((index, event) {
      final x = (event.date.microsecondsSinceEpoch - samples.first.timestamp)
              .toDouble() /
          1000000 *
          50;
      canvas.drawLine(Offset(x, 0), Offset(x, gridSize * 10), bluePaint);
      canvas.save();
      canvas.translate(x + gridSize, gridSize * (2 + 2 * index % 4));
      ChartPainter.drawText(
          canvas, getJapaneseEventName(event), Colors.blue.shade700, 10,
          textAlign: TextAlign.left, fontWeight: FontWeight.bold);
      canvas.restore();
    });
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 13);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(
            DateTime.fromMicrosecondsSinceEpoch(samples.first.timestamp)),
        Colors.black,
        gridSize);
    canvas.translate(gridSize * 50, 0);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(
            DateTime.fromMicrosecondsSinceEpoch(samples.last.timestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 55 * scale).ceil(), (gridSize * 14 * scale).ceil());
    checkCancelled();

    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    checkCancelled();

    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfRespChart(
      List<Sample> samples, int startTimestamp, int endTimestamp) async {
    const scale = 1.0;
    const gridSize = 10.0;
    const tickSize = 5.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "換気(パッドインピーダンス)(オーム)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 6);
    canvas.clipRect(
        const Rect.fromLTRB(0, -gridSize * 4, gridSize * 50, gridSize * 4));
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.05);
    }
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(startTimestamp)),
        Colors.black,
        gridSize);
    canvas.translate(gridSize * 50, 0);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(endTimestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 55 * scale).ceil(), (gridSize * 14 * scale).ceil());
    checkCancelled();

    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    checkCancelled();

    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfCo2Chart(
      List<Sample> samples, int startTimestamp, int endTimestamp) async {
    const scale = 1.0;
    const gridSize = 10.0;
    const tickSize = 5.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "CO2(mmHg)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 1);
    }
    canvas.restore();
    canvas.translate(gridSize * 2, gridSize * 12);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(startTimestamp)),
        Colors.black,
        gridSize);
    canvas.translate(gridSize * 50, 0);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(endTimestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 55 * scale).ceil(), (gridSize * 14 * scale).ceil());
    checkCancelled();

    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    checkCancelled();

    final bytes = byteData!.buffer.asUint8List();

    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfCprAccelChart(
      List<Sample> samples, int startTimestamp, int endTimestamp) async {
    const scale = 1.0;
    const gridSize = 10.0;
    const tickSize = 5.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "CPR波形", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    canvas.clipRect(const Rect.fromLTRB(0, -gridSize * 10, gridSize * 50, 0));
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.1);
    }
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(startTimestamp)),
        Colors.black,
        gridSize);
    canvas.translate(gridSize * 50, 0);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(endTimestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 55 * scale).ceil(), (gridSize * 14 * scale).ceil());
    checkCancelled();

    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    checkCancelled();

    final bytes = byteData!.buffer.asUint8List();

    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfCprCompressionChart(
      List<CprCompression> compressions,
      int startTimestamp,
      int endTimestamp) async {
    const scale = 1.0;
    const gridSize = 10.0;
    const tickSize = 5.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "CPRバー(インチ)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    if (compressions.isNotEmpty) {
      for (final compression in compressions) {
        final x = (compression.timestamp - startTimestamp) / 1000000 * 50;
        canvas.drawRect(
            Rect.fromLTRB(x - 2, -compression.compDisp / 50, x + 2, 0),
            blackPaint);
      }
    }
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(startTimestamp)),
        Colors.black,
        gridSize);
    canvas.translate(gridSize * 50, 0);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms()
            .format(DateTime.fromMicrosecondsSinceEpoch(endTimestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 55 * scale).ceil(), (gridSize * 14 * scale).ceil());
    checkCancelled();

    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    checkCancelled();

    final bytes = byteData!.buffer.asUint8List();

    return pw.MemoryImage(bytes);
  }

  static List<int> _chunkedIndices(List<Sample> samples) {
    if (samples.isEmpty) return [];
    var indices = [0];
    var lastSampleSecond = samples[indices.last].inSeconds;
    var index = 0;
    for (var sample in samples) {
      if (sample.inSeconds >= lastSampleSecond + 10) {
        indices.add(index);
        lastSampleSecond = samples[indices.last].inSeconds;
      }
      index += 1;
    }
    if (indices.last != samples.length - 1) {
      indices.add(samples.length - 1);
    }
    return indices;
  }

  List<List<Sample>> _buildPadChunk(List<int> indices, List<Sample> samples) {
    return indices
        .mapIndexed((index, element) =>
            [element, index < indices.length - 1 ? indices[index + 1] : null])
        .where((element) => element[1] != null)
        .mapIndexed((index, e) => samples.slice(e[0]!, e[1]!).toList())
        .toList();
  }

  List<List<Sample>> mapSamplesToPadChunk(
      List<Sample> pads, List<int> padIndices, List<Sample> samples) {
    int currentChunk = 0;

    final List<List<Sample>> chunkedEvents = [];
    for (var i = 0; i < padIndices.length - 1; i++) {
      chunkedEvents.add([]);
    }

    for (final x in samples
        .skipWhile((e) => e.timestamp < pads[padIndices.first].timestamp)
        .takeWhile((e) => e.timestamp < pads[padIndices.last].timestamp)) {
      if (currentChunk < padIndices.length - 2 &&
          pads[padIndices[currentChunk + 1]].timestamp <= x.timestamp) {
        currentChunk =
            padIndices.lastIndexWhere((e) => pads[e].timestamp <= x.timestamp);
      }

      chunkedEvents[currentChunk].add(x);
    }
    return chunkedEvents;
  }

  List<List<CprCompression>> mapCprCompressionToPadChunk(List<Sample> pads,
      List<int> padIndices, List<CprCompression> compressions) {
    int currentChunk = 0;

    final List<List<CprCompression>> chunkedEvents = [];
    for (var i = 0; i < padIndices.length - 1; i++) {
      chunkedEvents.add([]);
    }

    for (final x in compressions
        .skipWhile((e) => e.timestamp < pads[padIndices.first].timestamp)
        .takeWhile((e) => e.timestamp < pads[padIndices.last].timestamp)) {
      if (currentChunk < padIndices.length - 2 &&
          pads[padIndices[currentChunk + 1]].timestamp <= x.timestamp) {
        currentChunk =
            padIndices.lastIndexWhere((e) => pads[e].timestamp <= x.timestamp);
      }

      chunkedEvents[currentChunk].add(x);
    }
    return chunkedEvents;
  }

  Future<void> _yield() async {
    await Future.value();
    checkCancelled();
  }

  void checkCancelled() {
    if (generatePdfAction == null || generatePdfAction?.isCanceled == true) {
      throw Error.safeToString('Cancelled');
    }
  }

  Future<void> _generatePdf(
      DateTime startTime,
      DateTime endTime,
      bool drawPads,
      bool drawCo2,
      bool drawResp,
      bool drawCprAccel,
      bool drawCprCompression) async {
    final font = pw.TtfFont(
        await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
    checkCancelled();
    final fontBold =
        pw.TtfFont(await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf'));
    checkCancelled();
    final pdf = pw.Document();
    final pads = myCase!.waves['Pads']!.samples
        .where((e) =>
            startTime.microsecondsSinceEpoch <= e.timestamp &&
            e.timestamp <= endTime.microsecondsSinceEpoch)
        .toList();
    await _yield();
    final co2 = myCase!.waves['CO2 mmHg, Waveform']!.samples
        .where((e) =>
            startTime.microsecondsSinceEpoch <= e.timestamp &&
            e.timestamp <= endTime.microsecondsSinceEpoch)
        .toList();
    await _yield();
    final impedance = myCase!.waves['Pads Impedance']!.samples
        .where((e) =>
            startTime.microsecondsSinceEpoch <= e.timestamp &&
            e.timestamp <= endTime.microsecondsSinceEpoch)
        .toList();
    await _yield();
    final padIndices = _chunkedIndices(pads);
    await _yield();

    int currentChunk = 0;

    final List<List<CaseEvent>> chunkedEvents = [];
    if (padIndices.isNotEmpty) {
      for (var i = 0; i < padIndices.length; i++) {
        chunkedEvents.add([]);
      }

      for (final x in myCase!.displayableEvents
          .map((e) => e.item2)
          .skipWhile((e) =>
              e.date.microsecondsSinceEpoch < pads[padIndices.first].timestamp)
          .takeWhile((e) =>
              e.date.microsecondsSinceEpoch <
              pads[padIndices.last].timestamp)) {
        if (currentChunk < padIndices.length - 2 &&
            pads[padIndices[currentChunk + 1]].timestamp <=
                x.date.microsecondsSinceEpoch) {
          currentChunk = padIndices.lastIndexWhere(
              (e) => pads[e].timestamp <= x.date.microsecondsSinceEpoch);
        }

        chunkedEvents[currentChunk].add(x);
      }
    }
    await _yield();

    final padChunk =
        padIndices.isNotEmpty ? _buildPadChunk(padIndices, pads) : [];
    await _yield();
    final cprAccelChunk = padIndices.isNotEmpty
        ? mapSamplesToPadChunk(pads, padIndices, myCase!.cprAccel.samples)
        : [];
    await _yield();
    final co2Chunk = padIndices.isNotEmpty
        ? mapSamplesToPadChunk(pads, padIndices, co2)
        : [];
    await _yield();
    final impedanceChunk = padIndices.isNotEmpty
        ? mapSamplesToPadChunk(pads, padIndices, impedance)
        : [];
    await _yield();
    final cprCompressionChunk = padIndices.isNotEmpty
        ? mapCprCompressionToPadChunk(pads, padIndices, myCase!.cprCompressions)
        : [];
    await _yield();

    final List<Future<List<pw.MemoryImage>>> charts = [];
    if (drawPads) {
      charts.add(Future.wait(padChunk
          .mapIndexed((i, x) => _buildPdfPadsChart(x, chunkedEvents[i]))
          .toList()));
    }
    if (drawCo2) {
      charts.add(Future.wait(co2Chunk
          .mapIndexed((i, x) => _buildPdfCo2Chart(
              x, padChunk[i].first.timestamp, padChunk[i].last.timestamp))
          .toList()));
    }
    if (drawResp) {
      charts.add(Future.wait(impedanceChunk
          .mapIndexed((i, x) => _buildPdfRespChart(
              x, padChunk[i].first.timestamp, padChunk[i].last.timestamp))
          .toList()));
    }
    if (drawCprAccel) {
      charts.add(Future.wait(cprAccelChunk
          .mapIndexed((i, x) => _buildPdfCprAccelChart(
              x, padChunk[i].first.timestamp, padChunk[i].last.timestamp))
          .toList()));
    }
    if (drawCprCompression) {
      charts.add(Future.wait(cprCompressionChunk
          .mapIndexed((i, x) => _buildPdfCprCompressionChart(
              x, padChunk[i].first.timestamp, padChunk[i].last.timestamp))
          .toList()));
    }

    final chartFutures = await Future.wait(charts);
    checkCancelled();

    final chartWidgets =
        zip(chartFutures).map((e) => e.map((e) => pw.Image(e))).flattened;
    await _yield();

    final page = pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      margin: const pw.EdgeInsets.all(10),
      theme: pw.ThemeData(
          defaultTextStyle:
              pw.TextStyle(font: font, fontBold: fontBold, fontSize: 7)),
      header: (context) {
        final titleTextStyle =
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
        return pw.Column(children: [
          pw.Text("ZOLL® X Series® 除細動器要約レポート", style: titleTextStyle),
          pw.Text(
              "${myCase!.patientData?.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase!.startTime!)}",
              style: titleTextStyle),
        ]);
      },
      build: (context) {
        return [
          pw.Container(),
          ...chartWidgets,
        ];
      },
    );
    pdf.addPage(page);
    final bytes = await pdf.save();
    checkCancelled();

    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a4.portrait,
    );
  }

  static getJapaneseEventName(CaseEvent event) {
    if (event.type.i18n().compareTo(event.type) == 0) {
      return '';
    }
    String eventExtra = "";
    eventExtra = eventExtra += event.type == "TreatmentSnapshotEvt"
        ? event.rawData["TreatmentLbl"]
        : "";
    eventExtra = eventExtra +=
        event.type == "AlarmEvt" && event.rawData["Value"] == 1
            ? ": VF/VT"
            : "";
    return '${event.type.i18n()}$eventExtra';
  }

  Widget buildPrintButton(DateTime? start, DateTime? end) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        icon: const Icon(Icons.print),
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundColor: Theme.of(context).primaryColor),
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (context) {
                return ChoosePrintTimeRangeDialog(
                    myCase: myCase, start: start, end: end);
              });
          if (result != null) {
            final startTime = result[0];
            final endTime = result[1];
            final pads = result[2];
            final co2 = result[3];
            final resp = result[4];
            final cprAccel = result[5];
            final cprCompression = result[6];
            setState(() {
              generatePdfAction = CancelableOperation.fromFuture(_generatePdf(
                      startTime,
                      endTime,
                      pads,
                      co2,
                      resp,
                      cprAccel,
                      cprCompression)
                  .whenComplete(() {
                setState(() {
                  generatePdfAction = null;
                });
              }));
            });
          }
        },
        label: const Text('ストリップ印刷'),
      ),
    );
  }
}
