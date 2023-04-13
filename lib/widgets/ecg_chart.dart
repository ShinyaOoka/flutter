import 'dart:math';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/iterables.dart' as quiver_iterables;
import 'package:tuple/tuple.dart';

class EcgChart extends StatefulWidget {
  const EcgChart({
    Key? key,
    required this.samples,
    this.initDuration = const Duration(seconds: 45),
    this.segments = 3,
  }) : super(key: key);

  final List<Sample> samples;
  final Duration initDuration;
  final int segments;

  @override
  State<EcgChart> createState() => _EcgChartState();
}

class _EcgChartState extends State<EcgChart> {
  final Cache<Tuple2<int, int>, List<FlSpot>> cache =
      MapCache.lru(maximumSize: 100);

  final int factor = 100;

  List<FlSpot> getDataFromCacheKey(key) {
    print('cache miss');
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
    minX = widget.samples.first.inSeconds;
    maxX = widget.samples.last.inSeconds;
    minX = max(minX, maxX - widget.initDuration.inSeconds);
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
      height: 150,
      child: FutureBuilder(
        future: getData(minX, maxX),
        builder: (context, snapshot) {
          return LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              maxY: 2500,
              minY: -2500,
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      if (meta.max != value &&
                          meta.min != value &&
                          value != 0) {
                        return Container();
                      }
                      final time = DateTime.fromMicrosecondsSinceEpoch(
                          (value * 1000000).toInt());
                      return Text((value / 1000).toString());
                    },
                    showTitles: true,
                    interval: 3,
                    reservedSize: 32,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      if (meta.max != value &&
                          meta.min != value &&
                          value != 0) {
                        return Container();
                      }
                      return Text((value / 1000).toString());
                    },
                    showTitles: true,
                    interval: 3,
                    reservedSize: 32,
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
                      return Text(DateFormat.Hms().format(time));
                    },
                    showTitles: true,
                    interval: 3,
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
}
