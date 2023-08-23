import 'dart:ui';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/utils/chart_painter.dart';
import 'package:ak_azm_flutter/widgets/app_date_time_picker.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:localization/localization.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;
import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';

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
    return AlertDialog(
      title: const Text('時間範囲確認'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
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
              title: const Text('ECG'),
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
              title: const Text('CO2'),
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
              title: const Text('換気'),
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
              title: const Text('CPR波形'),
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
              title: const Text('CPRバー'),
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

class ConfirmPrintTimeRangesDialog extends StatefulWidget {
  const ConfirmPrintTimeRangesDialog({
    Key? key,
    required this.myCase,
    required this.timeRanges,
  }) : super(key: key);

  final Case myCase;
  final List<TimeRange> timeRanges;

  @override
  State<ConfirmPrintTimeRangesDialog> createState() =>
      _ConfirmPrintTimeRangesDialogState();
}

class _ConfirmPrintTimeRangesDialogState
    extends State<ConfirmPrintTimeRangesDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('時間範囲確認'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("印刷時間："),
            ...widget.timeRanges.map((x) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4, top: 4),
                  child: Row(
                    children: [
                      _buildSelectedTimeWidget(x.color,
                          AppConstants.timeFormat.format(x.startTime!)),
                      Text("〜"),
                      _buildSelectedTimeWidget(
                          x.color, AppConstants.timeFormat.format(x.endTime!)),
                    ],
                  ),
                )),
            CheckboxListTile(
              dense: true,
              value: pads,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('ECG'),
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
              title: const Text('CO2'),
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
              title: const Text('換気'),
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
              title: const Text('CPR波形'),
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
              title: const Text('CPRバー'),
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
            Navigator.pop(context,
                [widget.timeRanges, pads, co2, resp, cprAccel, cprCompression]);
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
    const yScale = 0.5;
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
        canvas, "ECG 1.0 cm/mV 25 mm/秒", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    canvas.scale(1, yScale);
    canvas.save();
    ChartPainter.paintGrid(canvas, redPaint, 10, 50, gridSize,
        leftTickInterval: 5,
        topTickInterval: 5,
        bottomTickInterval: 5,
        tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(0, gridSize * 5);
    canvas.clipRect(
        const Rect.fromLTRB(0, -gridSize * 5, gridSize * 50, gridSize * 5));
    ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.02);
    canvas.restore();
    canvas.save();
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
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 13 - yScale * gridSize * 10);
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
        (gridSize * 55 * scale).ceil(),
        (gridSize * 14 * scale - yScale * gridSize * 10 * scale).ceil());
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
    const yScale = 0.5;
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
    ChartPainter.drawText(canvas, "換気(ECGインピーダンス)(オーム)", Colors.black, gridSize,
        textAlign: TextAlign.left);
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 2);
    canvas.scale(1, yScale);
    canvas.save();
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(0, gridSize * 4);
    canvas.clipRect(
        const Rect.fromLTRB(0, -gridSize * 4, gridSize * 50, gridSize * 4));
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.05);
    }
    canvas.restore();
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12 - yScale * gridSize * 8);
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
        (gridSize * 55 * scale).ceil(),
        (gridSize * 14 * scale - yScale * gridSize * 8 * scale).ceil());
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
    const yScale = 0.5;

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
    canvas.scale(1, yScale);
    canvas.save();
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(0, gridSize * 8);
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 1);
    }
    canvas.restore();
    canvas.restore();
    canvas.translate(gridSize * 2, gridSize * 12 - yScale * gridSize * 8);
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
        (gridSize * 55 * scale).ceil(),
        (gridSize * 14 * scale - yScale * gridSize * 8 * scale).ceil());
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
    const yScale = 0.5;
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
    canvas.scale(1, yScale);
    canvas.save();
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(0, gridSize * 8);
    canvas.clipRect(const Rect.fromLTRB(0, -gridSize * 10, gridSize * 50, 0));
    if (samples.isNotEmpty) {
      ChartPainter.drawGraph(canvas, blackPaint, samples, 50, 0.1);
    }
    canvas.restore();
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12 - yScale * gridSize * 8);
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
        (gridSize * 55 * scale).ceil(),
        (gridSize * 14 * scale - yScale * gridSize * 8 * scale).ceil());
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
    const yScale = 0.5;
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
    canvas.scale(1, yScale);
    canvas.save();
    ChartPainter.paintYAxis(canvas, redPaint, 8, gridSize,
        leftTickInterval: 9, tickSize: tickSize, leftTickOffset: 8);
    canvas.translate(0, gridSize * 8);
    ChartPainter.paintXAxis(canvas, redPaint, 50, gridSize,
        bottomTickInterval: 5, tickSize: tickSize);
    canvas.restore();
    canvas.save();
    canvas.translate(0, gridSize * 8);
    if (compressions.isNotEmpty) {
      for (final compression in compressions) {
        final x = (compression.timestamp - startTimestamp) / 1000000 * 50;
        canvas.drawRect(
            Rect.fromLTRB(x - 2, -compression.compDisp / 50, x + 2, 0),
            blackPaint);
      }
    }
    canvas.restore();
    canvas.restore();
    canvas.save();
    canvas.translate(gridSize * 2, gridSize * 12 - yScale * gridSize * 8);
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
        (gridSize * 55 * scale).ceil(),
        (gridSize * 14 * scale - yScale * gridSize * 8 * scale).ceil());
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
      List<TimeRange> timeRanges,
      bool drawPads,
      bool drawCo2,
      bool drawResp,
      bool drawCprAccel,
      bool drawCprCompression) async {
    final pages = await Future.wait(timeRanges.map((x) => _generatePdfPage(
        x.startTime!,
        x.endTime!,
        drawPads,
        drawCo2,
        drawResp,
        drawCprAccel,
        drawCprCompression)));
    final pdf = pw.Document();
    for (final page in pages) {
      pdf.addPage(page);
    }
    final bytes = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      format: PdfPageFormat.a4.portrait,
    );
  }

  Future<pw.Page> _generatePdfPage(
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
    return page;
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

  Widget buildPrintFromExpandedEcgChartButton(DateTime? start, DateTime? end) {
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
              generatePdfAction = CancelableOperation.fromFuture(_generatePdf([
                TimeRange(
                    startTime: startTime, endTime: endTime, color: Colors.black)
              ], pads, co2, resp, cprAccel, cprCompression)
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

  Widget buildPrintFromTimeRangesButton(List<TimeRange> timeRanges) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        icon: const Icon(Icons.print),
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundColor: Theme.of(context).primaryColor),
        onPressed: () async {
          if (timeRanges.isEmpty) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("エラー"),
                    content: const Text("印刷時間を選択してください"),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
            return;
          }
          final result = await showDialog(
              context: context,
              builder: (context) {
                return ConfirmPrintTimeRangesDialog(
                    myCase: myCase!, timeRanges: timeRanges);
              });
          if (result != null) {
            final timeRanges = result[0];
            final pads = result[1];
            final co2 = result[2];
            final resp = result[3];
            final cprAccel = result[4];
            final cprCompression = result[5];
            setState(() {
              generatePdfAction = CancelableOperation.fromFuture(_generatePdf(
                      timeRanges, pads, co2, resp, cprAccel, cprCompression)
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
