import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/twelve_lead_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';

String defaultLabelFormat(double x) {
  return (x / 1000).toStringAsFixed(1);
}

void defaultOnTap(int timestamp) {}

class EcgChart extends StatefulWidget {
  const EcgChart({
    Key? key,
    required this.samples,
    required this.initTimestamp,
    this.initDuration = const Duration(seconds: 45),
    this.segments = 3,
    this.showGrid = false,
    this.minY = -2500,
    this.maxY = 2500,
    this.height = 150,
    this.gridHorizontal = 500,
    this.gridVertical = 0.4,
    this.cprCompressions = const [],
    this.minorInterval = 500,
    this.majorInterval = 2500,
    this.labelFormat = defaultLabelFormat,
    this.ventilationTimestamps = const [],
    this.onTap = defaultOnTap,
  }) : super(key: key);

  final List<Sample> samples;
  final int initTimestamp;
  final Duration initDuration;
  final int segments;
  final bool showGrid;
  final double minY;
  final double maxY;
  final double height;
  final double gridHorizontal;
  final double gridVertical;
  final double minorInterval;
  final double majorInterval;
  final String Function(double) labelFormat;
  final List<CprCompression> cprCompressions;
  final List<int> ventilationTimestamps;
  final void Function(int timestamp) onTap;

  @override
  State<EcgChart> createState() => _EcgChartState();
}

class _EcgChartState extends State<EcgChart> {
  Cache<Tuple2<int, int>, List<FlSpot>> cache = MapCache.lru(maximumSize: 100);

  final int factor = 100;

  List<FlSpot> getDataFromCacheKey(key) {
    return widget.samples
        .where((e) {
          final t = e.inSeconds;
          return t > key.item1 * factor && t < (key.item2 + 1) * factor;
        })
        .map((e) => FlSpot(e.inSeconds, e.value.toDouble()))
        .toList();
  }

  Future<List<FlSpot>> getData(double minX, double maxX) async {
    final cacheKey = Tuple2(minX.floor() ~/ factor, maxX.ceil() ~/ factor);
    return (await cache.get(
      cacheKey,
      ifAbsent: getDataFromCacheKey,
    ))!;
  }

  late double minX;
  late double maxX;

  late double lastMaxXValue;
  late double lastMinXValue;

  @override
  void initState() {
    super.initState();
    minX = widget.initTimestamp / 1000000;
    maxX = widget.initTimestamp / 1000000 + widget.initDuration.inSeconds;
    minX = max(minX, widget.samples.first.inSeconds);
    maxX = min(maxX, widget.samples.last.inSeconds);
  }

  @override
  void didUpdateWidget(EcgChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    cache = MapCache.lru(maximumSize: 100);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onDoubleTap: () {
        //   setState(() {
        //     minX = widget.samples.first.inSeconds;
        //     maxX = widget.samples.last.inSeconds;
        //   });
        // },
        onHorizontalDragStart: (details) {
          lastMinXValue = minX;
          lastMaxXValue = maxX;
        },
        onHorizontalDragUpdate: (details) {
          var horizontalDistance = details.primaryDelta ?? 0;
          if (horizontalDistance == 0) return;
          var lastMinMaxDistance = max(lastMaxXValue - lastMinXValue, 0.0);

          setState(() {
            minX -= lastMinMaxDistance * 0.005 * horizontalDistance;
            maxX -= lastMinMaxDistance * 0.005 * horizontalDistance;

            if (minX < widget.samples.first.inSeconds) {
              minX = widget.samples.first.inSeconds;
              maxX = widget.samples.first.inSeconds + lastMinMaxDistance;
            }
            if (maxX > widget.samples.last.inSeconds) {
              maxX = widget.samples.last.inSeconds;
              minX = maxX - lastMinMaxDistance;
            }
          });
        },
        onScaleStart: (details) {
          lastMinXValue = minX;
          lastMaxXValue = maxX;
        },
        onScaleUpdate: (details) {
          var horizontalScale = details.horizontalScale;
          if (horizontalScale == 0) return;
          var lastMinMaxDistance = max(lastMaxXValue - lastMinXValue, 0);
          var newMinMaxDistance = max(lastMinMaxDistance / horizontalScale, 2);
          var distanceDifference = newMinMaxDistance - lastMinMaxDistance;
          setState(() {
            final newMinX = max(
              lastMinXValue - distanceDifference,
              0.0,
            );
            final newMaxX = min(
              lastMaxXValue + distanceDifference,
              widget.samples.last.inSeconds,
            );

            if (newMaxX - newMinX > 2) {
              minX = newMinX;
              maxX = newMaxX;
            }
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
            children: quiver_iterables
                .enumerate(List.filled(widget.segments, null))
                .map((e) => buildChart(
                    minX + (maxX - minX) / (widget.segments) * e.index,
                    minX + (maxX - minX) / (widget.segments) * (e.index + 1)))
                .toList()));
  }

  Widget buildChart(double minX, double maxX) {
    return SizedBox(
      height: widget.height,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchCallback: (touchEvent, response) {
                  if (touchEvent.runtimeType != FlTapDownEvent) {
                    return;
                  }
                  final timestamp = response?.lineBarSpots?[0].x.toInt();
                  if (timestamp != null) {
                    widget.onTap(timestamp * 1000000);
                  }
                },
                handleBuiltInTouches: false,
              ),
              minX: minX,
              maxX: maxX,
              maxY: widget.maxY,
              minY: widget.minY,
              clipData: FlClipData.all(),
              gridData: FlGridData(
                  show: widget.showGrid,
                  verticalInterval: widget.gridVertical,
                  getDrawingHorizontalLine: (value) => FlLine(strokeWidth: 0.5),
                  getDrawingVerticalLine: (value) => FlLine(strokeWidth: 0.5),
                  horizontalInterval: widget.gridHorizontal),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      final isMajor = value % widget.majorInterval == 0;
                      return Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Positioned(
                            child: Container(
                              width: value % widget.majorInterval == 0 ? 10 : 5,
                              height: 1,
                              color: Colors.black,
                            ),
                          ),
                          isMajor
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(widget.labelFormat(value)),
                                )
                              : Container()
                        ],
                      );
                    },
                    showTitles: true,
                    interval: widget.minorInterval,
                    reservedSize: 48,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      final isMajor = value % widget.majorInterval == 0;
                      return Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Positioned(
                            child: Container(
                              width: value % widget.majorInterval == 0 ? 10 : 5,
                              height: 1,
                              color: Colors.black,
                            ),
                          ),
                          isMajor
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(widget.labelFormat(value)),
                                )
                              : Container()
                        ],
                      );
                    },
                    showTitles: true,
                    interval: widget.minorInterval,
                    reservedSize: 48,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      if (meta.max == value || meta.min == value) {
                        return Container();
                      }
                      final time = DateTime.fromMicrosecondsSinceEpoch(
                          (value * 1000000).toInt());
                      return Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Positioned(
                            child: Container(
                              width: 1,
                              height: value % 3 == 0 ? 10 : 5,
                              color: Colors.black,
                            ),
                          ),
                          value % 3 == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(DateFormat.Hms().format(time)),
                                )
                              : Container()
                        ],
                      );
                    },
                    showTitles: true,
                    interval: 1,
                    reservedSize: 32,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.cprCompressions
                      .map((e) => FlSpot(e.inSeconds,
                          widget.minY + (widget.maxY - widget.minY) * 0.8))
                      .toList(),
                  dotData: FlDotData(
                    getDotPainter: (p0, p1, p2, index) {
                      final isGreen =
                          widget.cprCompressions[index].compDisp >= 2000 &&
                              widget.cprCompressions[index].compDisp <= 2400;
                      return FlDotSquarePainter(
                          size: 15,
                          color: isGreen ? Colors.green : Colors.orange);
                    },
                  ),
                  barWidth: 0,
                ),
                LineChartBarData(
                  spots: widget.ventilationTimestamps
                      .map((e) => FlSpot(e / 1000000,
                          widget.minY + (widget.maxY - widget.minY) * 0.6))
                      .toList(),
                  dotData: FlDotData(
                    getDotPainter: (p0, p1, p2, index) {
                      return FlDotSquarePainter(size: 15, color: Colors.yellow);
                    },
                  ),
                  barWidth: 0,
                ),
                LineChartBarData(
                  spots: snapshot.data,
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
          );
        },
      ),
    );
  }
}
