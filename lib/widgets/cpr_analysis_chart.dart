import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

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
  const CprAnalysisChart(
      {Key? key,
      required this.samples,
      required this.initTimestamp,
      this.initDuration = const Duration(seconds: 30),
      this.showGrid = false,
      this.height = 150,
      this.gridHorizontal = 500,
      this.gridVertical = 0.4,
      this.cprCompressions = const [],
      this.minorInterval = 500,
      this.majorInterval = 2500,
      this.labelFormat = defaultLabelFormat,
      this.ventilationTimestamps = const [],
      this.cprRanges = const [],
      this.shocks = const [],
      this.depthUnit = 'inch',
      this.depthFrom = 2.0,
      this.depthTo = 2.4})
      : super(key: key);

  final List<Sample> samples;
  final int initTimestamp;
  final Duration initDuration;
  final bool showGrid;
  final double height;
  final double gridHorizontal;
  final double gridVertical;
  final double minorInterval;
  final double majorInterval;
  final String Function(double) labelFormat;
  final List<CprCompression> cprCompressions;
  final List<int> ventilationTimestamps;
  final List<Tuple2<int?, int?>> cprRanges;
  final List<int> shocks;
  final String depthUnit;
  final double depthFrom;
  final double depthTo;

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
    minX = max(minX, widget.samples.firstOrNull?.inSeconds ?? 0);
    maxX = min(maxX, widget.samples.lastOrNull?.inSeconds ?? 0);
  }

  @override
  void didUpdateWidget(CprAnalysisChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    cache = MapCache.lru(maximumSize: 100);
  }

  @override
  Widget build(BuildContext context) {
    final cprQualityDuration = cprQualities.map((e) {
      if (e.length != 2) return 0;
      final start = e[0].timestamp.clamp(minX * 1000000, maxX * 1000000);
      final end = e[1].timestamp.clamp(minX * 1000000, maxX * 1000000);
      return (end - start) / 1000000;
    }).sum;
    final cprQualityPercent = cprQualityDuration / (maxX - minX) * 100;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 48.0),
              child: Text('ショックの要約',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            buildShockChart(minX, maxX),
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Text('深さ（${widget.depthUnit == 'inch' ? 'インチ' : 'cm'}）',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            buildDepthChart(minX, maxX),
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Text('圧迫の質：${cprQualityPercent.toStringAsFixed(2)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            buildQualityChart(minX, maxX),
            const Padding(
              padding: EdgeInsets.only(left: 48.0),
              child: Text('速度（cpm）',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            buildSpeedChart(minX, maxX)
          ],
        ));
  }

  double getDepthMinScaled() {
    if (widget.depthUnit == 'inch') {
      return widget.depthFrom * 1000;
    } else {
      return widget.depthFrom * 1000 / 2.54;
    }
  }

  double getDepthMaxScaled() {
    if (widget.depthUnit == 'inch') {
      return widget.depthTo * 1000;
    } else {
      return widget.depthTo * 1000 / 2.54;
    }
  }

  Widget buildDepthChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: widget.height,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              rangeAnnotations: RangeAnnotations(
                horizontalRangeAnnotations: [
                  HorizontalRangeAnnotation(
                      y1: getDepthMinScaled(),
                      y2: getDepthMaxScaled(),
                      color: Colors.green.shade100)
                ],
                verticalRangeAnnotations: cprRangeAnnotations(),
              ),
              minX: minX,
              maxX: maxX,
              maxY: widget.depthUnit == 'inch' ? 4000 : (10 / 2.54 * 1000),
              minY: 0,
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      String label;
                      if (widget.depthUnit == 'inch') {
                        label = (value / 1000).toStringAsFixed(1);
                      } else {
                        label = (value / 1000 * 2.54).round().toString();
                      }
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(label),
                          )
                        ],
                      );
                    },
                    showTitles: true,
                    interval:
                        widget.depthUnit == 'inch' ? 2000 : 5 / 2.54 * 1000,
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

  bool cprValid(CprCompression value) {
    return value.detectionFlag != 0;
  }

  bool cprGreenQuality(CprCompression value) {
    return value.compDisp >= getDepthMinScaled() &&
        value.compDisp <= getDepthMaxScaled();
  }

  Widget buildShockChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 70,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              rangeAnnotations: RangeAnnotations(
                  verticalRangeAnnotations: cprRangeAnnotations()),
              extraLinesData: ExtraLinesData(verticalLines: [
                VerticalLine(x: (minX + maxX) / 2, color: Colors.blue),
                ...widget.shocks.map((x) => VerticalLine(
                    x: x / 1000000, color: Colors.blue, dashArray: [2])),
              ]),
              minX: minX,
              maxX: maxX,
              maxY: 1,
              minY: 0,
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      return Container();
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
                      return Container();
                    },
                    showTitles: true,
                    interval: 2,
                    reservedSize: 32,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(spots: []),
              ],
            ),
            swapAnimationDuration: Duration.zero,
          );
        },
      ),
    ));
  }

  List<List<CprCompression>> get cprQualities {
    List<List<CprCompression>> result = [];
    List<CprCompression> current = [];
    for (int i = 0; i < widget.cprCompressions.length; i++) {
      if (!cprValid(widget.cprCompressions[i])) {
        current = [];
      } else {
        if (current.isEmpty) {
          current.add(widget.cprCompressions[i]);
        } else {
          if (cprGreenQuality(current.first) !=
              cprGreenQuality(widget.cprCompressions[i])) {
            result.add([current.first, widget.cprCompressions[i]]);
            current = [widget.cprCompressions[i]];
          } else if (i != widget.cprCompressions.length - 1 &&
              widget.cprCompressions[i + 1].inSeconds -
                      widget.cprCompressions[i].inSeconds >
                  2) {
            result.add([current.first, widget.cprCompressions[i]]);
            current = [];
          }
        }
      }
    }
    return result;
  }

  Widget buildQualityChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 70,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              rangeAnnotations: RangeAnnotations(
                verticalRangeAnnotations: cprQualities
                    .map((e) => VerticalRangeAnnotation(
                          x1: e.first.inSeconds,
                          x2: e.last.inSeconds,
                          color: cprGreenQuality(e.first)
                              ? Colors.green
                              : Colors.orange,
                        ))
                    .toList(),
              ),
              minX: minX,
              maxX: maxX,
              maxY: 4000,
              minY: 0,
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      return Container();
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
                      return Container();
                    },
                    showTitles: true,
                    interval: 2,
                    reservedSize: 32,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(spots: []),
              ],
            ),
            swapAnimationDuration: Duration.zero,
          );
        },
      ),
    ));
  }

  Widget buildSpeedChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: widget.height,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations: [
                HorizontalRangeAnnotation(
                    y1: 50, y2: 140, color: Colors.green.shade100)
              ], verticalRangeAnnotations: cprRangeAnnotations()),
              minX: minX,
              maxX: maxX,
              maxY: 140,
              minY: 0,
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
                    interval: 2,
                    reservedSize: 32,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.cprCompressions
                      .map((e) => FlSpot(e.inSeconds, e.compRate.toDouble()))
                      .toList(),
                  dotData: FlDotData(
                    getDotPainter: (p0, p1, p2, p3) {
                      return FlDotCirclePainter(
                          color: Colors.red.shade900,
                          radius: 2,
                          strokeColor: Colors.red.shade900);
                    },
                  ),
                  color: Colors.red.shade900,
                ),
              ],
            ),
            swapAnimationDuration: Duration.zero,
          );
        },
      ),
    ));
  }

  List<VerticalRangeAnnotation> cprRangeAnnotations() {
    return widget.cprRanges
        .where((e) => e.item1 != null && e.item2 != null)
        .map((e) => VerticalRangeAnnotation(
            x1: e.item1! / 1000000,
            x2: e.item2! / 1000000,
            color: Colors.yellow.shade100))
        .toList();
  }
}
