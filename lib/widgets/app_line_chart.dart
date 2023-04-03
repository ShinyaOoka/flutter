import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/zoomable_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLineChart extends StatefulWidget {
  const AppLineChart({
    Key? key,
    required this.samples,
  }) : super(key: key);

  final List<Sample> samples;

  @override
  State<AppLineChart> createState() => _AppLineChartState();
}

class _AppLineChartState extends State<AppLineChart> {
  @override
  Widget build(BuildContext context) {
    return ZoomableChart(
        minX: widget.samples.last.timestamp.toDouble() / 1000000 - 5,
        maxX: widget.samples.last.timestamp.toDouble() / 1000000,
        builder: (minX, maxX) {
          final data = widget.samples
              .where((e) {
                final t = e.timestamp / 1000000;
                return t > minX && t < maxX;
              })
              .map((e) => FlSpot(e.timestamp / 1000000, e.value.toDouble()))
              .toList();
          return Container(
              height: 400,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  maxY: 1000,
                  minY: -1000,
                  clipData: FlClipData.all(),
                  gridData: FlGridData(
                      verticalInterval: 0.2, horizontalInterval: 200),
                  titlesData: FlTitlesData(
                      topTitles: AxisTitles(),
                      leftTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) {
                          if (meta.max == value || meta.min == value) {
                            return Container();
                          }
                          final time = DateTime.fromMicrosecondsSinceEpoch(
                              (value * 1000000).toInt());
                          return Text(DateFormat.Hms().format(time));
                        },
                        showTitles: true,
                        interval: 1,
                        reservedSize: 32,
                      ))),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: false,
                      color: Colors.black,
                      barWidth: 1,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                      ),
                    )
                  ],
                ),
                swapAnimationDuration: Duration.zero,
              ));
        });
  }
}
