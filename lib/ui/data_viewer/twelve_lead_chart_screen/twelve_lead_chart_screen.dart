import 'dart:ui';

import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:ak_azm_flutter/widgets/twelve_lead_chart.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:localization/localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TwelveLeadChartScreenArguments {
  final Ecg12Lead twelveLead;
  final Case myCase;

  TwelveLeadChartScreenArguments(
      {required this.twelveLead, required this.myCase});
}

class TwelveLeadChartScreen extends StatefulWidget {
  const TwelveLeadChartScreen({super.key});

  @override
  _TwelveLeadChartScreenState createState() => _TwelveLeadChartScreenState();
}

class _TwelveLeadChartScreenState extends State<TwelveLeadChartScreen>
    with RouteAware, ReportSectionMixin {
  Ecg12Lead? twelveLead;
  Case? myCase;

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
        as TwelveLeadChartScreenArguments;
    setState(() {
      twelveLead = args.twelveLead;
      myCase = args.myCase;
    });
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
      title: "12誘導表示",
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

  pw.Widget _buildPdfInfoRow(String title, String value) {
    return pw.Row(children: [
      pw.Container(width: 200, child: pw.Text(title)),
      pw.Container(width: 200, child: pw.Text(value)),
    ]);
  }

  Future<pw.MemoryImage> _buildPdfChart() async {
    const scale = 4.0;
    const gridSize = 10;
    const tickSize = 2;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final redPaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final blackPaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    // Draw vertical line
    for (var i = 0; i < 53; i++) {
      canvas.drawLine(
        Offset(
            i.toDouble() * gridSize * scale, i % 5 != 0 ? tickSize * scale : 0),
        Offset(i.toDouble() * gridSize * scale,
            (16 * gridSize + (i % 5 == 0 ? tickSize * 2 : tickSize)) * scale),
        redPaint,
      );
    }
    // Draw horizontal line
    for (var i = 0; i < 17; i++) {
      canvas.drawLine(
        Offset(0, (tickSize + i.toDouble() * gridSize) * scale),
        Offset(52 * gridSize * scale,
            (tickSize + i.toDouble() * gridSize) * scale),
        redPaint,
      );
    }

    drawGraph(Path path, List<Sample> data, Offset offset) {
      final firstSecond = data.first.inSeconds;
      data
          .where((e) =>
              e.inSeconds - firstSecond >= 0 &&
              e.inSeconds - firstSecond <= 2.5)
          .forEach((e) {
        path.lineTo(offset.dx + (e.inSeconds - firstSecond) * 50 * scale,
            offset.dy + -e.value / 1000 * scale * 20);
      });
    }

    final leadIPath = Path()
      ..moveTo(0, tickSize * scale + 4 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 4 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 2 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 2 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 4 * gridSize * scale);
    final leadIIPath = Path()
      ..moveTo(0, tickSize * scale + 8 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 8 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 6 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 6 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 8 * gridSize * scale);
    final leadIIIPath = Path()
      ..moveTo(0, tickSize * scale + 12 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 12 * gridSize * scale)
      ..lineTo(gridSize * scale / 2, tickSize * scale + 10 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 10 * gridSize * scale)
      ..lineTo(gridSize * scale, tickSize * scale + 12 * gridSize * scale);
    final leadAVRPath = Path()
      ..moveTo(
          13.5 * gridSize * scale, tickSize * scale + 4 * gridSize * scale);
    final leadAVLPath = Path()
      ..moveTo(
          13.5 * gridSize * scale, tickSize * scale + 8 * gridSize * scale);
    final leadAVFPath = Path()
      ..moveTo(
          13.5 * gridSize * scale, tickSize * scale + 12 * gridSize * scale);
    final leadV1Path = Path()
      ..moveTo(26 * gridSize * scale, tickSize * scale + 4 * gridSize * scale);
    final leadV2Path = Path()
      ..moveTo(26 * gridSize * scale, tickSize * scale + 8 * gridSize * scale);
    final leadV3Path = Path()
      ..moveTo(26 * gridSize * scale, tickSize * scale + 12 * gridSize * scale);
    final leadV4Path = Path()
      ..moveTo(
          38.5 * gridSize * scale, tickSize * scale + 4 * gridSize * scale);
    final leadV5Path = Path()
      ..moveTo(
          38.5 * gridSize * scale, tickSize * scale + 8 * gridSize * scale);
    final leadV6Path = Path()
      ..moveTo(
          38.5 * gridSize * scale, tickSize * scale + 12 * gridSize * scale);

    drawGraph(leadIPath, twelveLead!.leadI.samples,
        Offset(gridSize * scale, tickSize * scale + 4 * gridSize * scale));
    drawGraph(leadIIPath, twelveLead!.leadII.samples,
        Offset(gridSize * scale, tickSize * scale + 8 * gridSize * scale));
    drawGraph(leadIIIPath, twelveLead!.leadIII.samples,
        Offset(gridSize * scale, tickSize * scale + 12 * gridSize * scale));

    drawGraph(
        leadAVRPath,
        twelveLead!.leadAVR.samples,
        Offset(
            13.5 * gridSize * scale, tickSize * scale + 4 * gridSize * scale));
    drawGraph(
        leadAVLPath,
        twelveLead!.leadAVL.samples,
        Offset(
            13.5 * gridSize * scale, tickSize * scale + 8 * gridSize * scale));
    drawGraph(
        leadAVFPath,
        twelveLead!.leadAVF.samples,
        Offset(
            13.5 * gridSize * scale, tickSize * scale + 12 * gridSize * scale));
    drawGraph(leadV1Path, twelveLead!.leadV1.samples,
        Offset(26 * gridSize * scale, tickSize * scale + 4 * gridSize * scale));
    drawGraph(leadV2Path, twelveLead!.leadV2.samples,
        Offset(26 * gridSize * scale, tickSize * scale + 8 * gridSize * scale));
    drawGraph(
        leadV3Path,
        twelveLead!.leadV3.samples,
        Offset(
            26 * gridSize * scale, tickSize * scale + 12 * gridSize * scale));
    drawGraph(
        leadV4Path,
        twelveLead!.leadV4.samples,
        Offset(
            38.5 * gridSize * scale, tickSize * scale + 4 * gridSize * scale));
    drawGraph(
        leadV5Path,
        twelveLead!.leadV5.samples,
        Offset(
            38.5 * gridSize * scale, tickSize * scale + 8 * gridSize * scale));
    drawGraph(
        leadV6Path,
        twelveLead!.leadV6.samples,
        Offset(
            38.5 * gridSize * scale, tickSize * scale + 12 * gridSize * scale));

    canvas.drawPath(leadIPath, blackPaint);
    canvas.drawPath(leadIIPath, blackPaint);
    canvas.drawPath(leadIIIPath, blackPaint);
    canvas.drawPath(leadAVRPath, blackPaint);
    canvas.drawPath(leadAVLPath, blackPaint);
    canvas.drawPath(leadAVFPath, blackPaint);
    canvas.drawPath(leadV1Path, blackPaint);
    canvas.drawPath(leadV2Path, blackPaint);
    canvas.drawPath(leadV3Path, blackPaint);
    canvas.drawPath(leadV4Path, blackPaint);
    canvas.drawPath(leadV5Path, blackPaint);
    canvas.drawPath(leadV6Path, blackPaint);

    final rendered = await recorder.endRecording().toImage(
        (gridSize * 52 * scale).ceil(),
        ((gridSize * 16 + tickSize * 2) * scale).ceil());
    final byteData = await rendered.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<void> _generatePdf() async {
    final font = pw.TtfFont(
        await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
    final fontBold =
        pw.TtfFont(await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf'));
    final chart = await _buildPdfChart();
    final pdf = pw.Document();
    final firstPage = pw.Page(
      pageFormat: PdfPageFormat.a3.landscape,
      orientation: pw.PageOrientation.landscape,
      margin: pw.EdgeInsets.all(20),
      theme: pw.ThemeData(
          defaultTextStyle:
              pw.TextStyle(font: font, fontBold: fontBold, fontSize: 15)),
      build: (context) {
        final titleTextStyle =
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20);
        return pw.Column(
          children: [
            pw.Text("ZOLL® X Series® 除細動器 12誘導レポート", style: titleTextStyle),
            pw.Text(
                "${twelveLead?.patientData.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase!.startTime!)}",
                style: titleTextStyle),
            pw.Container(height: 20),
            pw.Row(children: [
              pw.Column(children: [
                _buildPdfInfoRow('患者名:',
                    '${twelveLead!.patientData.firstName} ${twelveLead!.patientData.middleName} ${twelveLead!.patientData.lastName}'),
                _buildPdfInfoRow('患者ID:', twelveLead!.patientData.patientId),
                _buildPdfInfoRow('年齢:', twelveLead!.patientData.age.toString()),
                _buildPdfInfoRow('性別:', twelveLead!.patientData.sex),
                pw.Container(width: 100, height: 15),
                _buildPdfInfoRow('心拍数:', twelveLead!.heartRate.toString()),
                pw.Container(width: 100, height: 15),
                _buildPdfInfoRow('PR間隔:', "${twelveLead!.prInt} ms"),
                _buildPdfInfoRow('QRS幅:', "${twelveLead!.qrsDur} ms"),
                _buildPdfInfoRow(
                    'QT/QTc:', "${twelveLead!.qtInt}/${twelveLead!.corrQtInt}"),
                _buildPdfInfoRow('P-R-T軸:',
                    "${twelveLead!.pAxis} ${twelveLead!.qrsAxis} ${twelveLead!.tAxis}"),
                pw.Container(width: 100, height: 15),
                _buildPdfInfoRow('デバイスID:', ""),
                _buildPdfInfoRow(
                    '記録済み:',
                    intl.DateFormat("yyyy-MM-dd HH:mm:ss")
                        .format(twelveLead!.time)),
              ]),
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children:
                      twelveLead!.statements.map((e) => pw.Text(e)).toList(),
                ),
              ),
            ]),
            pw.Container(height: 15),
            pw.Text(intl.DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(twelveLead!.time)),
            pw.Image(chart),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("25 mm/s 10 mm/mV 0.52~40 Hz"),
                pw.Text("グリッドサイズは0.20 s x 0.50 mV"),
              ],
            )
          ],
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
        );
      },
    );
    final secondPage = pw.Page(
      pageFormat: PdfPageFormat.a3.landscape,
      orientation: pw.PageOrientation.landscape,
      margin: pw.EdgeInsets.all(20),
      theme: pw.ThemeData(
          defaultTextStyle:
              pw.TextStyle(font: font, fontBold: fontBold, fontSize: 15)),
      build: (context) {
        final titleTextStyle =
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20);
        return pw.Column(
          children: [
            pw.Text("ZOLL® X Series® 除細動器 12誘導レポート", style: titleTextStyle),
            pw.Text(
                "${twelveLead?.patientData.patientId} ${intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(myCase!.startTime!)}",
                style: titleTextStyle),
            pw.Container(height: 20),
            pw.Table(children: [
              pw.TableRow(children: [
                pw.Container(),
                pw.Text("V1",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("V2",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("V3",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("V4",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("V5",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("V6",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("I",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("aVL",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("II",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("aVF",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("III",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("aVR",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]),
              pw.TableRow(children: [
                pw.Text("STJ",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("${twelveLead!.stValues[6]}"),
                pw.Text("${twelveLead!.stValues[7]}"),
                pw.Text("${twelveLead!.stValues[8]}"),
                pw.Text("${twelveLead!.stValues[9]}"),
                pw.Text("${twelveLead!.stValues[10]}"),
                pw.Text("${twelveLead!.stValues[11]}"),
                pw.Text("${twelveLead!.stValues[0]}"),
                pw.Text("${twelveLead!.stValues[4]}"),
                pw.Text("${twelveLead!.stValues[1]}"),
                pw.Text("${twelveLead!.stValues[5]}"),
                pw.Text("${twelveLead!.stValues[2]}"),
                pw.Text("${twelveLead!.stValues[3]}"),
              ]),
            ])
          ],
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
        );
      },
    );
    pdf.addPage(firstPage);
    pdf.addPage(secondPage);
    final bytes = await pdf.save();
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a3.landscape,
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
        twelveLead != null
            ? _buildMainContent()
            : const CustomProgressIndicatorWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Name: ${twelveLead!.patientData.firstName}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Age: ${twelveLead!.patientData.age}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Sex: ${twelveLead!.patientData.sex}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Id: ${twelveLead!.patientData.patientId}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("HR: ${twelveLead!.heartRate}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("PR Interval: ${twelveLead!.prInt} ms"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("QRS Duration: ${twelveLead!.qrsDur} ms"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child:
                Text("QT/QTc: ${twelveLead!.qtInt}/${twelveLead!.corrQtInt}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
                "P-R-T Axis: ${twelveLead!.pAxis} ${twelveLead!.qrsAxis} ${twelveLead!.tAxis}"),
          ),
          ...twelveLead!.statements.map((x) => Container(
                padding: EdgeInsets.all(8),
                child: Text(x),
              )),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
                "STJ: I: ${twelveLead!.stValues[0] / 100} II: ${twelveLead!.stValues[1] / 100} III: ${twelveLead!.stValues[2] / 100} aVR: ${twelveLead!.stValues[3] / 100} aVL: ${twelveLead!.stValues[4] / 100} aVF: ${twelveLead!.stValues[5] / 100} V1: ${twelveLead!.stValues[6] / 100} V2: ${twelveLead!.stValues[7] / 100} V3: ${twelveLead!.stValues[8] / 100} V4: ${twelveLead!.stValues[9] / 100} V5: ${twelveLead!.stValues[10] / 100} V6: ${twelveLead!.stValues[11] / 100}"),
          ),
          TwelveLeadChart(
            data: twelveLead!,
          ),
        ],
      ),
    );
  }
}
