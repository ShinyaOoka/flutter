import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/zoomable_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';

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
    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
            minX: -0.2,
            maxX: 10.2,
            minY: -2000,
            maxY: 6000,
            clipData: FlClipData.all(),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(-0.2, 4000),
                  FlSpot(-0.1, 4000),
                  FlSpot(-0.1, 5000),
                  FlSpot(0, 5000),
                  FlSpot(0, 4000),
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
                  FlSpot(-0.2, 2000),
                  FlSpot(-0.1, 2000),
                  FlSpot(-0.1, 3000),
                  FlSpot(0, 3000),
                  FlSpot(0, 2000),
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
                  FlSpot(-0.2, 0),
                  FlSpot(-0.1, 0),
                  FlSpot(-0.1, 1000),
                  FlSpot(0, 1000),
                  FlSpot(0, 0),
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
