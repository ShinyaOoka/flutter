import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/widgets/twelve_lead_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';
import 'package:localization/localization.dart';
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

class ExpandedEcgChart extends StatefulWidget {
  const ExpandedEcgChart({
    Key? key,
    required this.pads,
    required this.co2,
    required this.initTimestamp,
    required this.events,
    this.showGrid = false,
    this.gridHorizontal = 500,
    this.gridVertical = 0.4,
    this.cprCompressions = const [],
    this.minorInterval = 500,
    this.majorInterval = 2500,
    this.labelFormat = defaultLabelFormat,
    this.ventilationTimestamps = const [],
    this.cprRanges = const [],
    this.shocks = const [],
  }) : super(key: key);

  final List<Sample> pads;
  final int initTimestamp;
  final List<Sample> co2;
  final List<CaseEvent> events;
  final bool showGrid;
  final double gridHorizontal;
  final double gridVertical;
  final double minorInterval;
  final double majorInterval;
  final String Function(double) labelFormat;
  final List<CprCompression> cprCompressions;
  final List<int> ventilationTimestamps;
  final List<Tuple2<int?, int?>> cprRanges;
  final List<int> shocks;

  @override
  State<ExpandedEcgChart> createState() => _ExpandedEcgChartState();
}

class _ExpandedEcgChartState extends State<ExpandedEcgChart> {
  Cache<Tuple2<int, int>, List<FlSpot>> padsCache =
      MapCache.lru(maximumSize: 100);
  Cache<Tuple2<int, int>, List<FlSpot>> co2Cache =
      MapCache.lru(maximumSize: 100);

  final int factor = 100;

  List<FlSpot> getPadsDataFromCacheKey(key) {
    return widget.pads
        .where((e) {
          final t = e.inSeconds;
          return t > key.item1 * factor && t < (key.item2 + 1) * factor;
        })
        .map((e) => FlSpot(e.inSeconds, e.value.toDouble()))
        .toList();
  }

  Future<List<FlSpot>> getPadsData(double minX, double maxX) async {
    final cacheKey = Tuple2(minX.floor() ~/ factor, maxX.ceil() ~/ factor);
    return (await padsCache.get(
      cacheKey,
      ifAbsent: getPadsDataFromCacheKey,
    ))!;
  }

  List<FlSpot> getCo2DataFromCacheKey(key) {
    return widget.co2
        .where((e) {
          final t = e.inSeconds;
          return t > key.item1 * factor && t < (key.item2 + 1) * factor;
        })
        .map((e) => FlSpot(e.inSeconds, e.value.toDouble()))
        .toList();
  }

  Future<List<FlSpot>> getCo2Data(double minX, double maxX) async {
    final cacheKey = Tuple2(minX.floor() ~/ factor, maxX.ceil() ~/ factor);
    return (await co2Cache.get(
      cacheKey,
      ifAbsent: getCo2DataFromCacheKey,
    ))!;
  }

  late double minX;
  late double maxX;

  late double lastMaxXValue;
  late double lastMinXValue;

  @override
  void initState() {
    super.initState();
    minX = widget.initTimestamp / 1000000 - 3;
    maxX = widget.initTimestamp / 1000000 + 3;
  }

  @override
  void didUpdateWidget(ExpandedEcgChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    padsCache = MapCache.lru(maximumSize: 100);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

          if (minX < widget.pads.first.inSeconds) {
            minX = widget.pads.first.inSeconds;
            maxX = widget.pads.first.inSeconds + lastMinMaxDistance;
          }
          if (maxX > widget.pads.last.inSeconds) {
            maxX = widget.pads.last.inSeconds;
            minX = maxX - lastMinMaxDistance;
          }
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('換気（パッドインピーダンス）（オーム）',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        buildPadsChart(minX, maxX),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text('CO2（mmHg）', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        buildCo2Chart(minX, maxX),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text('CPR波形（cm）', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        buildDepthChart(minX, maxX),
      ]),
    );
  }

  Widget buildPadsChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 300,
      child: FutureBuilder(
        future: getPadsData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              extraLinesData: ExtraLinesData(verticalLines: [
                VerticalLine(
                  x: widget.initTimestamp / 1000000,
                  color: Colors.blue,
                ),
                ...widget.events
                    .where((e) {
                      final second = e.date.microsecondsSinceEpoch / 1000000;
                      return minX <= second && second <= maxX;
                    })
                    .mapIndexed((i, e) => VerticalLine(
                          x: e.date.microsecondsSinceEpoch / 1000000,
                          color: Colors.blue,
                          label: VerticalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(
                                left: 10, top: (i % 13) * 20 + 5),
                            style: const TextStyle(),
                            labelResolver: (line) => getJapaneseEventName(e),
                          ),
                          dashArray: [10, 10],
                        ))
                    .toList()
              ]),
              minX: minX,
              maxX: maxX,
              maxY: 2500,
              minY: -2500,
              clipData: FlClipData.all(),
              gridData: FlGridData(
                  show: true,
                  verticalInterval: 0.2,
                  getDrawingHorizontalLine: (value) => FlLine(strokeWidth: 0.5),
                  getDrawingVerticalLine: (value) => FlLine(strokeWidth: 0.5),
                  horizontalInterval: 500),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(DateFormat.Hms().format(time)),
                          )
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
    ));
  }

  Widget buildCo2Chart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 150,
      child: FutureBuilder(
        future: getCo2Data(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              maxY: 100,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(DateFormat.Hms().format(time)),
                          )
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
    ));
  }

  bool cprValid(CprCompression value) {
    return value.detectionFlag != 0;
  }

  bool cprGreenQuality(CprCompression value) {
    return value.compDisp >= 2000 && value.compDisp <= 2400;
  }

  Widget buildDepthChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
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
                          height:
                              meta.max == value || meta.min == value ? 10 : 5,
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
      ),
    ));
  }

  Widget buildShockChart(double minX, double maxX) {
    return IgnorePointer(
        child: SizedBox(
      height: 70,
      child: FutureBuilder(
        future: getPadsData(minX, maxX),
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

  List<VerticalRangeAnnotation> cprRangeAnnotations() {
    return widget.cprRanges
        .where((e) => e.item1 != null && e.item2 != null)
        .map((e) => VerticalRangeAnnotation(
            x1: e.item1! / 1000000,
            x2: e.item2! / 1000000,
            color: Colors.yellow.shade100))
        .toList();
  }

  getJapaneseEventName(CaseEvent event) {
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
}
