import 'dart:ui';

import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/utils/chart_painter.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:pdf/widgets.dart' as pw;

class SnapshotDetailScreenArguments {
  final Snapshot snapshot;
  final Case myCase;

  SnapshotDetailScreenArguments({required this.snapshot, required this.myCase});
}

class SnapshotDetailScreen extends StatefulWidget {
  const SnapshotDetailScreen({super.key});

  @override
  _SnapshotDetailScreenState createState() => _SnapshotDetailScreenState();
}

class _SnapshotDetailScreenState extends State<SnapshotDetailScreen>
    with RouteAware, ReportSectionMixin {
  late Snapshot snapshot;
  late Case myCase;

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
        as SnapshotDetailScreenArguments;
    snapshot = args.snapshot;
    myCase = args.myCase;
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

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: "スナップショット",
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return [
      _buildPrintButton(),
    ];
  }

  Widget _buildPrintButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        icon: const Icon(Icons.print),
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundColor: Theme.of(context).primaryColor),
        onPressed: () async {
          await _generatePdf();
        },
        label: Text('印刷'),
      ),
    );
  }

  Future<pw.MemoryImage> _buildPdfPadsChart() async {
    const scale = 4.0;
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
    ChartPainter.drawText(
        canvas, "パッド 1.0 cm/mV 25 mm/秒", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintGrid(canvas, redPaint, 10, 120, gridSize,
        leftTickInterval: 5, topTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 13);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(DateTime.fromMicrosecondsSinceEpoch(
            snapshot.waveforms.values.first.samples.first.timestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 7);
    ChartPainter.drawGraph(
        canvas, blackPaint, snapshot.waveforms['Pads']!.samples, 50, 0.02);

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 123 * scale).ceil(), (gridSize * 14 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfCO2Chart() async {
    const scale = 4.0;
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
    ChartPainter.drawText(canvas, "CO2 (mmHg)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintGrid(canvas, redPaint, 5, 120, gridSize,
        leftTickInterval: 5, topTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 8);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(DateTime.fromMicrosecondsSinceEpoch(
            snapshot.waveforms.values.first.samples.first.timestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 7);
    ChartPainter.drawGraph(canvas, blackPaint,
        snapshot.waveforms['CO2 mmHg, Waveform']!.samples, 50, 0.05);

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 123 * scale).ceil(), (gridSize * 14 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.MemoryImage> _buildPdfSPO2Chart() async {
    const scale = 4.0;
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
    ChartPainter.drawText(canvas, "CO2 (mmHg)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    ChartPainter.paintGrid(canvas, redPaint, 5, 120, gridSize,
        leftTickInterval: 5, topTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 8);
    ChartPainter.drawText(
        canvas,
        intl.DateFormat.Hms().format(DateTime.fromMicrosecondsSinceEpoch(
            snapshot.waveforms.values.first.samples.first.timestamp)),
        Colors.black,
        gridSize);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 4.5);
    ChartPainter.drawGraph(canvas, blackPaint,
        snapshot.waveforms['SpO2 %, Waveform']!.samples, 50, 0.18);

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 123 * scale).ceil(), (gridSize * 14 * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<void> _generatePdf() async {
    final font = pw.TtfFont(
        await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
    final fontBold =
        pw.TtfFont(await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf'));
    final pdf = pw.Document();
    final padsChart = await _buildPdfPadsChart();
    final co2Chart = await _buildPdfCO2Chart();
    final spo2Chart = await _buildPdfSPO2Chart();
    final page = pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      orientation: pw.PageOrientation.landscape,
      margin: pw.EdgeInsets.all(10),
      theme: pw.ThemeData(
          defaultTextStyle:
              pw.TextStyle(font: font, fontBold: fontBold, fontSize: 7)),
      build: (context) {
        final titleTextStyle =
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
        return pw.Column(
          children: [
            pw.Text("ZOLL® X Series® 除細動器 12誘導レポート", style: titleTextStyle),
            pw.Text(
                "${myCase.patientData?.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase.startTime!)}",
                style: titleTextStyle),
            pw.Container(height: 10),
            pw.Text(
                "${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(snapshot.time)}にあるスナップショット（1 の 1）"),
            pw.Text(
                "モニタのスナップショット ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(snapshot.time)}"),
            pw.Text(
                "HR/PR = ${snapshot.trend.hr.value} BPM SpO2 = ${snapshot.trend.spo2.value} % CO2 = ${snapshot.trend.etco2.value} mmHg FiCO2 = ${snapshot.trend.fico2.value} mmHg"),
            pw.Image(padsChart),
            pw.Image(co2Chart),
            pw.Image(spo2Chart),
          ],
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
        );
      },
    );
    pdf.addPage(page);
    final bytes = await pdf.save();
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a4.landscape,
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    _buildInfoLine('HR',
                        '${snapshot.trend.hr.value} ${snapshot.trend.hr.unit}'),
                    _buildInfoLine('spo2',
                        '${snapshot.trend.spo2.value} ${snapshot.trend.spo2.unit}'),
                    _buildInfoLine('Etco2',
                        '${snapshot.trend.etco2.value} ${snapshot.trend.etco2.unit}'),
                    _buildInfoLine('FiCO2',
                        '${snapshot.trend.fico2.value} ${snapshot.trend.fico2.unit}'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Text('Pads'),
            padding: EdgeInsets.all(16),
          ),
          EcgChart(
            samples: snapshot.waveforms['Pads']!.samples,
            initTimestamp: snapshot.waveforms['Pads']!.samples.first.timestamp,
            segments: 1,
            showGrid: true,
          ),
          snapshot.waveforms['CO2 mmHg, Waveform'] != null
              ? Container(
                  child: Text('CO2 mmHg, Waveform'),
                  padding: EdgeInsets.all(16),
                )
              : Container(),
          snapshot.waveforms['CO2 mmHg, Waveform'] != null
              ? EcgChart(
                  samples: snapshot.waveforms['CO2 mmHg, Waveform']!.samples,
                  initTimestamp: snapshot
                      .waveforms['CO2 mmHg, Waveform']!.samples.first.timestamp,
                  segments: 1,
                  showGrid: true,
                  maxY: 1000,
                  minY: 0,
                  gridHorizontal: 200,
                  height: 100,
                )
              : Container(),
          snapshot.waveforms['SpO2 %, Waveform'] != null
              ? Container(
                  child: Text('SpO2 %, Waveform'),
                  padding: EdgeInsets.all(16),
                )
              : Container(),
          snapshot.waveforms['SpO2 %, Waveform'] != null
              ? EcgChart(
                  samples: snapshot.waveforms['SpO2 %, Waveform']!.samples,
                  initTimestamp: snapshot
                      .waveforms['SpO2 %, Waveform']!.samples.first.timestamp,
                  segments: 1,
                  showGrid: true,
                  maxY: 150,
                  minY: -150,
                  height: 100,
                  gridHorizontal: 60,
                )
              : Container()
        ],
      ),
    );
  }

  Expanded _buildInfoLine(String title, String content) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: '${title}: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: content),
            ])),
      ),
    );
  }
}
