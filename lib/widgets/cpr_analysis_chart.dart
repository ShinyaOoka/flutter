import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/twelve_lead_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';

class DotBarPainter extends FlDotPainter {
  DotBarPainter({
    Color? color,
    double? size,
    Color? strokeColor,
    double? strokeWidth,
  })  : color = color ?? Colors.green,
        size = size ?? 4.0;

  Color color;

  double size;

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    canvas.drawRect(
      Rect.fromPoints(offsetInCanvas.translate(-size / 2, 0),
          Offset(offsetInCanvas.dx + size / 2, 9999)),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(size, spot.y);
  }

  @override
  List<Object?> get props => [color, size];
}

String defaultLabelFormat(double x) {
  return (x / 1000).toStringAsFixed(1);
}

class CprAnalysisChart extends StatefulWidget {
  const CprAnalysisChart({
    Key? key,
    required this.samples,
    required this.initTimestamp,
    this.initDuration = const Duration(seconds: 30),
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

  @override
  State<CprAnalysisChart> createState() => _CprAnalysisChartState();
}

class _CprAnalysisChartState extends State<CprAnalysisChart> {
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
  void didUpdateWidget(CprAnalysisChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    cache = MapCache.lru(maximumSize: 100);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          setState(() {
            minX = widget.samples.first.inSeconds;
            maxX = widget.samples.last.inSeconds;
          });
        },
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
            print("$minX, $maxX");
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
    return IgnorePointer(
        child: SizedBox(
      height: widget.height,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              maxY: widget.maxY,
              minY: widget.minY,
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
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
                      return Container();
                    },
                    showTitles: true,
                    interval: widget.minorInterval,
                    reservedSize: 48,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      return Stack(
                        children: [
                          Positioned(
                            child: Container(
                              width: 1,
                              height: meta.max == value || meta.min == value
                                  ? 10
                                  : 5,
                              color: Colors.black,
                            ),
                          )
                        ],
                      );
                    },
                    showTitles: true,
                    interval: 2,
                    reservedSize: 32,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.cprCompressions
                      .map((e) => FlSpot(e.inSeconds, e.compDisp.toDouble()))
                      .toList(),
                  dotData: FlDotData(
                    getDotPainter: (p0, p1, p2, index) {
                      return DotBarPainter(size: 8, color: Colors.blue);
                    },
                  ),
                  barWidth: 0,
                ),
              ],
            ),
            swapAnimationDuration: Duration.zero,
          );
        },
      ),
    ));
  }
}
