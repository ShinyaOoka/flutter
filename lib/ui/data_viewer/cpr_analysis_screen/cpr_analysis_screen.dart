import 'dart:io';
import 'dart:ui';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/utils/chart_painter.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/cpr_analysis_chart.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';
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
import 'package:intl/intl.dart' as intl;
import 'package:pdf/widgets.dart' as pw;
import 'package:scidart/numdart.dart';

class CprAnalysisScreenArguments {
  final String caseId;

  CprAnalysisScreenArguments({required this.caseId});
}

class CprAnalysisScreen extends StatefulWidget {
  const CprAnalysisScreen({super.key});

  @override
  CprAnalysisScreenState createState() => CprAnalysisScreenState();
}

class CprAnalysisScreenState extends State<CprAnalysisScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;

  double depthFrom = 2.0;
  double depthTo = 2.4;
  String depthUnit = 'inch';
  List<double> depthInchOptions = [
    0.0,
    0.5,
    1.0,
    1.5,
    2.0,
    2.4,
    2.5,
    3.0,
    3.5,
    4.0
  ];

  List<double> depthCmOptions = [
    0.0,
    1.0,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
    8.0,
    9.0,
    10.0
  ];

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
        as CprAnalysisScreenArguments;
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
    try {await _loadTestData();}catch(e) {}
    _hostApi.deviceDownloadCase(
        _zollSdkStore.selectedDevice!, caseId, tempDir.path, null);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      title: "CPR解析",
      actions: _buildActions(),
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

  List<Widget> _buildActions() {
    return [
      PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 0,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Icon(Icons.print),
                title: Text('要約印刷'),
              ),
            ),
            const PopupMenuItem(
              value: 1,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Icon(Icons.print),
                title: Text('サマリ印刷'),
              ),
            ),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case 0:
              await _generateDetailPdf();
              break;
            case 1:
              await _generateSummaryPdf();
              break;
          }
        },
      )
    ];
  }

  Future<pw.MemoryImage> _buildShockChart() async {
    const scale = 4.0;
    const gridSize = 10.0;
    const tickSize = 2.0;
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
    ChartPainter.drawText(canvas, "ショックの要約", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 6);
    ChartPainter.paintXAxis(canvas, redPaint, 60, gridSize,
        bottomTickInterval: 4, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.drawRect(
        const Rect.fromLTWH(gridSize * 2, gridSize * 2, gridSize * 60, gridSize * 4),
        redPaint);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    canvas.restore();

    final rendered = await recorder
        .endRecording()
        .toImage((gridSize * 64 * scale).ceil(), (gridSize * 7 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildDepthChart() async {
    const scale = 4.0;
    const gridSize = 10.0;
    const tickSize = 2.0;
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
      ..strokeWidth = 1
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.stroke;

    final greenPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.green.shade100
      ..style = PaintingStyle.fill;
    final startTimestamp = myCase!.startTime!.microsecondsSinceEpoch;
    final endTimestamp = myCase!.waves['Pads']!.samples.last.timestamp;
    final timestampLength = endTimestamp - startTimestamp;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "深さ(${depthUnit == 'inch' ? 'インチ' : 'cm'})",
        Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    ChartPainter.paintXAxis(canvas, redPaint, 60, gridSize,
        bottomTickInterval: 4, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    canvas.drawRect(
        Rect.fromLTRB(0, (4000 - getDepthMaxScaled()) / 4000 * gridSize * 8,
            gridSize * 60, (4000 - getDepthMinScaled()) / 4000 * gridSize * 8),
        greenPaint);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 4, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    for (final compression in myCase!.cprCompressions) {
      final x = (compression.timestamp - startTimestamp) /
          timestampLength *
          gridSize *
          60;
      final height = compression.compDisp / 1000 / 4 * gridSize * 8;
      canvas.drawLine(Offset(x, 0), Offset(x, -height), bluePaint);
    }
    canvas.restore();

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 64 * scale).ceil(), (gridSize * 11 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  double getDepthMinScaled() {
    if (depthUnit == 'inch') {
      return depthFrom * 1000;
    } else {
      return depthFrom * 1000 / 2.54;
    }
  }

  double getDepthMaxScaled() {
    if (depthUnit == 'inch') {
      return depthTo * 1000;
    } else {
      return depthTo * 1000 / 2.54;
    }
  }

  Future<pw.MemoryImage> _buildQualityChart() async {
    const scale = 4.0;
    const gridSize = 10.0;
    const tickSize = 2.0;
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
    final greenPaint = Paint()
      ..strokeWidth = 1
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.stroke;
    final orangePaint = Paint()
      ..strokeWidth = 1
      ..color = const Color(0xFFFF8000)
      ..style = PaintingStyle.stroke;
    final startTimestamp = myCase!.startTime!.microsecondsSinceEpoch;
    final endTimestamp = myCase!.waves['Pads']!.samples.last.timestamp;
    final timestampLength = endTimestamp - startTimestamp;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "圧迫の質", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.drawRect(
        const Rect.fromLTWH(gridSize * 2, gridSize * 2, gridSize * 60, gridSize * 2),
        blackPaint);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    for (final compression in myCase!.cprCompressions) {
      final x = (compression.timestamp - startTimestamp) /
          timestampLength *
          gridSize *
          60;
      final isGreen =
          compression.compDisp >= 2000 && compression.compDisp <= 2400;
      canvas.drawLine(Offset(x, 0), Offset(x, 2 * gridSize),
          isGreen ? greenPaint : orangePaint);
    }
    canvas.restore();
    final rendered = await recorder
        .endRecording()
        .toImage((gridSize * 64 * scale).ceil(), (gridSize * 5 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildSpeedChart() async {
    const scale = 4.0;
    const gridSize = 10.0;
    const tickSize = 2.0;
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
    final brownPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.brown
      ..style = PaintingStyle.stroke;
    final greenPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.green.shade100
      ..style = PaintingStyle.fill;
    final startTimestamp = myCase!.startTime!.microsecondsSinceEpoch;
    final endTimestamp = myCase!.waves['Pads']!.samples.last.timestamp;
    final timestampLength = endTimestamp - startTimestamp;
    canvas
      ..save()
      ..scale(scale);
    canvas.save();
    canvas.translate(0, gridSize / 2);
    ChartPainter.drawText(canvas, "速度(cpm)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 10);
    ChartPainter.paintXAxis(canvas, redPaint, 60, gridSize,
        bottomTickInterval: 4, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    canvas.drawRect(const Rect.fromLTRB(0, 0, gridSize * 60, 80 / 140 * gridSize * 8),
        greenPaint);
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 4, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 11);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(myCase!.startTime!),
        Colors.black,
        gridSize,
        textAlign: TextAlign.center);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 62, gridSize * 11);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(myCase!.startTime!),
        Colors.black,
        gridSize,
        textAlign: TextAlign.center);
    canvas.restore();
    canvas.save();
    final x = (myCase!.cprCompressions.first.timestamp - startTimestamp) /
        timestampLength *
        gridSize *
        60;
    canvas.translate(gridSize * 2 + x, gridSize * 10);
    ChartPainter.drawGraph(
        canvas,
        brownPaint,
        myCase!.cprCompressions
            .map((e) =>
                Sample(timestamp: e.timestamp, value: e.compRate.toDouble()))
            .toList(),
        60 * gridSize / timestampLength * 1000000,
        gridSize * 8 / 140);
    final rendered = await recorder.endRecording().toImage(
        (gridSize * 64 * scale).ceil(), (gridSize * 12 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  pw.Widget _buildSummaryPdfBox(String value) {
    return pw.Container(
      height: 24,
      alignment: pw.Alignment.center,
      child: pw.Container(
        height: 20,
        alignment: pw.Alignment.center,
        child: pw.Text(value),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(Colors.grey.value),
          border: pw.Border.all(),
        ),
      ),
    );
  }

  Future<void> _generateSummaryPdf() async {
    final font = pw.TtfFont(
        await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
    final fontBold =
        pw.TtfFont(await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf'));
    final pdf = pw.Document();
    final page = pw.Page(
        pageFormat: PdfPageFormat.a4.portrait,
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.all(10),
        theme: pw.ThemeData(
            defaultTextStyle:
                pw.TextStyle(font: font, fontBold: fontBold, fontSize: 14)),
        build: (context) {
          final titleTextStyle =
              pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18);
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("CPR解析のサマリ", style: titleTextStyle),
              pw.Text(
                  "症例の日付範囲：${intl.DateFormat.yMMMMd().format(myCase!.startTime!)}～${intl.DateFormat.yMMMMd().format(myCase!.endTime!)}"),
              pw.Text("報告日：${intl.DateFormat.yMd().format(DateTime.now())}"),
              pw.Text("作成者 RescueNet Code Review™, Enterprise Edition"),
              pw.Container(height: 5),
              pw.Container(
                  height: 10, color: PdfColor.fromInt(Colors.red.value)),
              pw.Container(height: 20),
              pw.Table(columnWidths: {
                2: const pw.FixedColumnWidth(100)
              }, children: [
                pw.TableRow(children: [
                  pw.Text(''),
                  pw.Text(intl.DateFormat.yM().format(myCase!.startTime!)),
                  pw.Text(''),
                ]),
                pw.TableRow(children: [
                  pw.Text(''),
                  pw.Text('合計'),
                  pw.Text(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('総症例数'),
                  pw.Text('1'),
                  _buildSummaryPdfBox('1'),
                ]),
                pw.TableRow(children: [
                  pw.Container(height: 20),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('最初の圧迫までの平均時間'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫を中止してから電気ショックを与えるまでの平均時間'),
                  pw.Text(
                      averageCprCompressionBeforeShock().toStringAsFixed(2)),
                  _buildSummaryPdfBox(
                      averageCprCompressionBeforeShock().toStringAsFixed(2)),
                ]),
                pw.TableRow(children: [
                  pw.Text('電気ショックを与えてから圧迫を開始するまでの平均時間'),
                  pw.Text(averageCprCompressionAfterShock().toStringAsFixed(2)),
                  _buildSummaryPdfBox(
                      averageCprCompressionAfterShock().toStringAsFixed(2)),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫深度の平均'),
                  pw.Text(
                      '${averageCompDisp().toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}'),
                  _buildSummaryPdfBox(
                      '${averageCompDisp().toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}'),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫速度の平均'),
                  pw.Text('${averageCompRate().toStringAsFixed(2)} cpm'),
                  _buildSummaryPdfBox(
                      '${averageCompRate().toStringAsFixed(2)} cpm'),
                ]),
                pw.TableRow(children: [
                  pw.Container(height: 20),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('CPRが推奨された合計時間'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫時間の割合'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫以外の時間の割合'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Container(height: 20),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('総圧迫回数'),
                  pw.Text(myCase!.cprCompressions.length.toString()),
                  _buildSummaryPdfBox(
                      myCase!.cprCompressions.length.toString()),
                ]),
                pw.TableRow(children: [
                  pw.Text('圧迫深度：'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン超過'),
                  pw.Text(
                      '${(overCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(overCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン内'),
                  pw.Text(
                      '${(middleCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(middleCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン未満'),
                  pw.Text(
                      '${(underCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(underCompDispCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('速度'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン超過'),
                  pw.Text(
                      '${(overCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(overCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン内'),
                  pw.Text(
                      '${(middleCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(middleCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　目標ゾーン未満'),
                  pw.Text(
                      '${(underCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                  _buildSummaryPdfBox(
                      '${(underCompRateCount() / myCase!.cprCompressions.length).toStringAsFixed(2)} %'),
                ]),
                pw.TableRow(children: [
                  pw.Text('目標ゾーンのばらつき：'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　圧迫深度'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
                pw.TableRow(children: [
                  pw.Text('　　速度'),
                  pw.Text(''),
                  _buildSummaryPdfBox(''),
                ]),
              ]),
            ],
          );
        });
    pdf.addPage(page);
    final bytes = await pdf.save();
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a4.portrait,
    );
  }

  Future<void> _generateDetailPdf() async {
    final font = pw.TtfFont(
        await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
    final fontBold =
        pw.TtfFont(await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf'));
    final pdf = pw.Document();
    final shockChart = await _buildShockChart();
    final depthChart = await _buildDepthChart();
    final qualityChart = await _buildQualityChart();
    final speedChart = await _buildSpeedChart();
    final page = pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      orientation: pw.PageOrientation.landscape,
      margin: const pw.EdgeInsets.all(10),
      theme: pw.ThemeData(
          defaultTextStyle:
              pw.TextStyle(font: font, fontBold: fontBold, fontSize: 7)),
      build: (context) {
        final titleTextStyle =
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
        return pw.Column(
          children: [
            pw.Text("ZOLL® X Series® 除細動器 CPR解析", style: titleTextStyle),
            pw.Text(
                "${myCase!.patientData?.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase!.startTime!)}",
                style: titleTextStyle),
            pw.Image(shockChart),
            pw.Image(depthChart),
            pw.Image(qualityChart),
            pw.Image(speedChart),
          ],
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
        );
      },
    );
    final page2 = pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        orientation: pw.PageOrientation.landscape,
        margin: const pw.EdgeInsets.all(10),
        theme: pw.ThemeData(
            defaultTextStyle:
                pw.TextStyle(font: font, fontBold: fontBold, fontSize: 9)),
        build: (context) {
          final titleTextStyle =
              pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
          return pw.Column(
            children: [
              pw.Text("ZOLL® X Series® 除細動器 CPR解析", style: titleTextStyle),
              pw.Text(
                  "${myCase!.patientData?.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase!.startTime!)}",
                  style: titleTextStyle),
              pw.Container(height: 50),
              pw.Text(
                "キー表示",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              _buildPdfRow('マニュアル', '', 'AutoPulse'),
              _buildPdfRow('最初の圧迫までの平均時間:', '', '---'),
              _buildPdfRow(
                  '圧迫を中止してから電気ショックを与えるまでの平均時間:',
                  _printDuration(Duration(
                      seconds: averageCprCompressionBeforeShock().toInt())),
                  '---'),
              _buildPdfRow(
                  '電気ショックを与えてから圧迫を開始するまでの平均時間:',
                  _printDuration(Duration(
                      seconds: averageCprCompressionAfterShock().toInt())),
                  '---'),
              _buildPdfRow(
                  '圧迫の深さの平均:',
                  '${averageCompDisp().toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}',
                  ''),
              _buildPdfRow('圧迫速度の平均:',
                  '${averageCompRate().toStringAsFixed(2)} cpm', ''),
              pw.Container(height: 10),
              pw.Text(
                "症例全体",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Container(height: 10),
              _buildPdfRow('症例の期間:', '', ''),
              _buildPdfRow('CPRの時間:', '', ''),
              _buildPdfRow('CPR以外の時間:', '', ''),
              pw.Container(height: 10),
              pw.Text(
                "CPR期間",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              _buildPdfRow('マニュアル', '', 'AutoPulse'),
              _buildPdfRow('圧迫の時間:', '', '---'),
              _buildPdfRow('圧迫以外の時間:', '', '---'),
              _buildPdfRow('目標範囲内の圧迫:', '', ''),
              pw.Container(height: 10),
              _buildPdfRow(
                  '深度(目標ゾーン${depthFrom.toStringAsFixed(1)} ~ ${depthTo.toStringAsFixed(1)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}):',
                  '',
                  ''),
              pw.Container(height: 10),
              _buildPdfRow(
                  '標準偏差:',
                  '${standardDeviation(Array(myCase!.cprCompressions.map((e) => (depthUnit == 'inch' ? e.compDisp : e.compDisp * 2.54) / 1000).toList())).toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}',
                  ''),
              _buildPdfRow('目標ゾーン超過:', overCompDispCount().toString(), '',
                  percent:
                      overCompDispCount() / myCase!.cprCompressions.length),
              _buildPdfRow('目標ゾーン内:', middleCompDispCount().toString(), '',
                  percent:
                      middleCompDispCount() / myCase!.cprCompressions.length),
              _buildPdfRow('目標ゾーン未満:', underCompDispCount().toString(), '',
                  percent:
                      underCompDispCount() / myCase!.cprCompressions.length),
              pw.Container(height: 10),
              _buildPdfRow('速度(目標ゾーン50 ~ 140 CPM):', '', ''),
              pw.Container(height: 10),
              _buildPdfRow(
                  '標準偏差:',
                  '${standardDeviation(Array(myCase!.cprCompressions.map((e) => e.compRate.toDouble()).toList())).toStringAsFixed(2)} cpm',
                  ''),
              _buildPdfRow('目標ゾーン超過:', overCompRateCount().toString(), '',
                  percent:
                      overCompRateCount() / myCase!.cprCompressions.length),
              _buildPdfRow('目標ゾーン内:', middleCompRateCount().toString(), '',
                  percent:
                      middleCompRateCount() / myCase!.cprCompressions.length),
              _buildPdfRow('目標ゾーン未満:', underCompRateCount().toString(), '',
                  percent:
                      underCompRateCount() / myCase!.cprCompressions.length),
              pw.Container(height: 10),
              _buildPdfRow('各電気ショックの時間:', '', ''),
            ],
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
          );
        });
    pdf.addPage(page);
    pdf.addPage(page2);
    final bytes = await pdf.save();
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a4.landscape,
    );
  }

  int underCompRateCount() {
    return myCase!.cprCompressions.where((e) => e.compRate < 80).length;
  }

  int middleCompRateCount() {
    return myCase!.cprCompressions
        .where((e) => e.compRate >= 80 && e.compRate <= 140)
        .length;
  }

  int overCompRateCount() {
    return myCase!.cprCompressions.where((e) => e.compRate > 140).length;
  }

  int underCompDispCount() {
    return myCase!.cprCompressions
        .where((e) => e.compDisp < getDepthMinScaled())
        .length;
  }

  int middleCompDispCount() {
    return myCase!.cprCompressions
        .where((e) =>
            e.compDisp >= getDepthMinScaled() &&
            e.compDisp <= getDepthMaxScaled())
        .length;
  }

  int overCompDispCount() {
    return myCase!.cprCompressions
        .where((e) => e.compDisp > getDepthMaxScaled())
        .length;
  }

  pw.Row _buildPdfRow(String title, String value, String autoPulse,
      {double? percent}) {
    return pw.Row(children: [
      pw.Container(
          child: pw.Text(title,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.right),
          width: 400),
      pw.Container(width: 16),
      pw.Container(child: pw.Text(value), width: 120),
      pw.Container(
          child: pw.Text(percent != null
              ? '(${(percent * 100).toStringAsFixed(2)} %)'
              : ''),
          width: 180),
      pw.Container(
          child: pw.Text(autoPulse,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.right),
          width: 100),
    ]);
  }

  Widget _buildBody() {
    return Row(
      children: [
        AppNavigationRail(selectedIndex: 3, caseId: caseId),
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
            _buildDepthInput(),
            myCase!.waves[chartType]!.samples.isNotEmpty
                ? CprAnalysisChart(
                    samples: myCase!.waves[chartType]!.samples,
                    cprCompressions: myCase!.cprCompressions,
                    ventilationTimestamps: myCase!
                        .waves['CO2 mmHg, Waveform']!.samples
                        .where((element) => element.status == 1)
                        .map((e) => e.timestamp)
                        .toList(),
                    initTimestamp:
                        myCase!.waves[chartType]!.samples.first.timestamp,
                    initDuration: const Duration(seconds: 30),
                    majorInterval: 2000,
                    minorInterval: 2000,
                    labelFormat: labelFormat[chartType]!,
                    cprRanges: myCase!.cprRanges,
                    shocks: myCase!.shocks,
                    depthUnit: depthUnit,
                    depthFrom: depthFrom,
                    depthTo: depthTo,
                  )
                : Container(),
            _buildLegend(),
            _buildSummary()
          ],
        ),
      ),
    );
  }

  Row _buildLegend() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.yellow.shade100,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('CPR期間'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.green.shade100,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('目標ゾーン'),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('AutoPulseアクティブ'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('AutoPulse圧迫'),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: const [
                  SizedBox(width: 40, height: 30),
                  SizedBox(width: 8),
                  Text('圧迫の質：')
                ])
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('目標範囲内'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('目標範囲外'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('圧迫なし'),
                  ],
                ),
              ],
            ),
            Container(width: 20),
          ],
        ),
      ],
    );
  }

  Column _buildDepthInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("圧迫"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: AppDropdown(
                  label: 'FROM',
                  items:
                      depthUnit == 'inch' ? depthInchOptions : depthCmOptions,
                  itemAsString: (i) => i.toStringAsFixed(1),
                  selectedItem: depthFrom,
                  clearable: false,
                  onChanged: (i) {
                    setState(() {
                      if (depthTo < i!) {
                        depthTo = i;
                        depthFrom = i;
                      } else {
                        depthFrom = i;
                      }
                    });
                  },
                ),
              ),
              Container(width: 16),
              Expanded(
                child: AppDropdown(
                  label: 'TO',
                  items:
                      depthUnit == 'inch' ? depthInchOptions : depthCmOptions,
                  itemAsString: (i) => i.toStringAsFixed(1),
                  selectedItem: depthTo,
                  clearable: false,
                  onChanged: (i) {
                    setState(() {
                      if (i! < depthFrom) {
                        depthTo = i;
                        depthFrom = i;
                      } else {
                        depthTo = i;
                      }
                    });
                  },
                ),
              ),
              Container(width: 16),
              Expanded(
                child: AppDropdown(
                  label: '単位',
                  items: const ['inch', 'cm'],
                  selectedItem: depthUnit,
                  clearable: false,
                  onChanged: (i) {
                    setState(() {
                      if (i == 'inch' && depthUnit == 'cm') {
                        depthFrom = depthInchOptions
                            .sortedBy<num>((e) => (depthFrom / 2.54 - e).abs())
                            .first;
                        depthTo = depthInchOptions
                            .sortedBy<num>((e) => (depthTo / 2.54 - e).abs())
                            .first;
                      } else if (i == 'cm' && depthUnit == 'inch') {
                        depthFrom = depthCmOptions
                            .sortedBy<num>((e) => (depthFrom * 2.54 - e).abs())
                            .first;
                        depthTo = depthCmOptions
                            .sortedBy<num>((e) => (depthTo * 2.54 - e).abs())
                            .first;
                      }
                      depthUnit = i!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    final beforeShockDuration = averageCprCompressionAfterShock();
    final afterShockDuration = averageCprCompressionBeforeShock();
    final compDisp = averageCompDisp();
    final compRate = averageCompRate();

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(children: [
          const TableCell(
              child: Text('キー表示',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('マニュアル',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('最初の圧迫までの平均時間:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫を中止してから電気ショックを与えるまでの平均時間:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(_printDuration(
                  Duration(seconds: beforeShockDuration.toInt()))),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('電気ショックを与えてから圧迫を開始するまでの平均時間:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(_printDuration(
                  Duration(seconds: afterShockDuration.toInt()))),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫の深度の平均:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  '${(depthUnit == 'inch' ? compDisp : compDisp * 2.54).toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}'),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫速度の平均:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('${compRate.toStringAsFixed(2)} cpm'),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('症例全体',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('症例の期間',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('CPRの時間',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('CPR以外の時間',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('CPR期間',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('マニュアル',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫の時間:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫以外の時間:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標範囲内の圧迫:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('圧迫深度:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('標準偏差:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  '${standardDeviation(Array(myCase!.cprCompressions.map((e) => (depthUnit == 'inch' ? e.compDisp : e.compDisp * 2.54) / 1000).toList())).toStringAsFixed(2)} ${depthUnit == 'inch' ? 'インチ' : 'cm'}'),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン超過:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(overCompDispCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(overCompDispCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン内:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(middleCompDispCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(middleCompDispCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン未満:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(underCompDispCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(underCompDispCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('速度:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(child: Container()),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('標準偏差:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  '${standardDeviation(Array(myCase!.cprCompressions.map((e) => e.compRate.toDouble()).toList())).toStringAsFixed(2)} cpm'),
            ),
          ),
          TableCell(child: Container()),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン超過:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(overCompRateCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(overCompRateCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン内:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(middleCompRateCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(middleCompRateCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
        TableRow(children: [
          const TableCell(
              child: Text('目標ゾーン未満:',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(underCompRateCount().toString()),
            ),
          ),
          TableCell(
              child: Text(
                  '(${(underCompRateCount() / myCase!.cprCompressions.length * 100).toStringAsFixed(2)} %)')),
        ]),
      ],
    );
  }

  double averageCompRate() {
    final averageCompRate = myCase!.cprCompressions.isNotEmpty
        ? myCase!.cprCompressions.map((e) => e.compRate).average
        : 0.0;
    return averageCompRate;
  }

  double averageCompDisp() {
    final averageCompDisp = myCase!.cprCompressions.isNotEmpty
        ? myCase!.cprCompressions.map((e) => e.compDisp).average / 1000
        : 0.0;
    return depthUnit == 'inch' ? averageCompDisp : averageCompDisp * 2.54;
  }

  double averageCprCompressionBeforeShock() {
    final durations = myCase!.shocks.map((e) {
      final t = myCase!.cprCompressions
          .lastWhereOrNull((c) => c.timestamp <= e)
          ?.timestamp;
      if (t == null) return null;
      return e - t;
    }).whereNotNull();
    final average = durations.isNotEmpty ? durations.average : 0.0;
    return average;
  }

  double averageCprCompressionAfterShock() {
    final durations = myCase!.shocks.map((e) {
      final t = myCase!.cprCompressions
          .firstWhereOrNull((c) => c.timestamp >= e)
          ?.timestamp;
      if (t == null) return null;
      return t - e;
    }).whereNotNull();
    final average = durations.isNotEmpty ? durations.average / 1000000 : 0.0;
    return average;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
