import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DotTextPainter extends FlDotPainter {
  String text;
  late double height;
  late TextPainter textPainter;

  DotTextPainter(this.text) {
    textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
  }

  /// Implementation of the parent class to draw the square
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    textPainter.paint(
        canvas, offsetInCanvas.translate(4, -textPainter.height / 2));
  }

  /// Implementation of the parent class to get the size of the square
  @override
  Size getSize(FlSpot spot) {
    return textPainter.size;
  }

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
      ];
}

class TwelveLeadChart extends StatefulWidget {
  const TwelveLeadChart({
    required this.data,
    Key? key,
  }) : super(key: key);

  final Ecg12Lead data;

  @override
  State<TwelveLeadChart> createState() => _TwelveLeadChartState();
}

class _TwelveLeadChartState extends State<TwelveLeadChart> {
  List<FlSpot> _buildData(
      List<Sample> samples, int offsetX, int offsetY, double timeOffset) {
    return samples
        .where((e) {
          final t = e.inSeconds -
              widget.data.time.millisecondsSinceEpoch / 1000 -
              timeOffset;
          return t >= 0 && t <= 2.5;
        })
        .map(
          (e) => FlSpot(
            e.inSeconds -
                widget.data.time.millisecondsSinceEpoch / 1000 +
                offsetX * 2.5 -
                timeOffset,
            e.value + offsetY * 2000,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      'I',
      'II',
      'III',
      'aVR',
      'aVL',
      'aVF',
      'V1',
      'V2',
      'V3',
      'V4',
      'V5',
      'V6',
    ];
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
            minX: -0.2,
            maxX: 10.2,
            minY: -2000,
            maxY: 6000,
            clipData: FlClipData.all(),
            gridData:
                FlGridData(verticalInterval: 0.2, horizontalInterval: 500),
            titlesData: FlTitlesData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 5000),
                  const FlSpot(0, 3000),
                  const FlSpot(0, 1000),
                  const FlSpot(2.5, 5000),
                  const FlSpot(2.5, 3000),
                  const FlSpot(2.5, 1000),
                  const FlSpot(5, 5000),
                  const FlSpot(5, 3000),
                  const FlSpot(5, 1000),
                  const FlSpot(7.5, 5000),
                  const FlSpot(7.5, 3000),
                  const FlSpot(7.5, 1000),
                ],
                dotData: FlDotData(
                  getDotPainter: (p0, p1, p2, index) {
                    return DotTextPainter(labels[index]);
                  },
                ),
                barWidth: 0,
              ),
              LineChartBarData(
                spots: [
                  const FlSpot(-0.2, 4000),
                  const FlSpot(-0.1, 4000),
                  const FlSpot(-0.1, 5000),
                  const FlSpot(0, 5000),
                  const FlSpot(0, 4000),
                ],
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: [
                  const FlSpot(-0.2, 2000),
                  const FlSpot(-0.1, 2000),
                  const FlSpot(-0.1, 3000),
                  const FlSpot(0, 3000),
                  const FlSpot(0, 2000),
                ],
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: [
                  const FlSpot(-0.2, 0),
                  const FlSpot(-0.1, 0),
                  const FlSpot(-0.1, 1000),
                  const FlSpot(0, 1000),
                  const FlSpot(0, 0),
                ],
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadI.samples, 0, 2, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadII.samples, 0, 1, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadIII.samples, 0, 0, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadAVR.samples, 1, 2, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadAVL.samples, 1, 1, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadAVF.samples, 1, 0, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV1.samples, 2, 2, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV2.samples, 2, 1, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV3.samples, 2, 0, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV4.samples, 3, 2, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV5.samples, 3, 1, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: _buildData(widget.data.leadV6.samples, 3, 0, 0),
                isCurved: false,
                color: Colors.black,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ]),
      ),
    );
  }
}
