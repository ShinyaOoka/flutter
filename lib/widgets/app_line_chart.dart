import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/zoomable_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/cache.dart';
import 'package:tuple/tuple.dart';

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
  final Cache<Tuple2<int, int>, List<FlSpot>> cache =
      MapCache.lru(maximumSize: 100);

  List<FlSpot> getDataFromCacheKey(key) {
    return widget.samples
        .where((e) {
          final t = e.timestamp / 1000000;
          return t > key.item1 * 10 && t < (key.item2 + 1) * 10;
        })
        .map((e) => FlSpot(e.timestamp / 1000000, e.value.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomableChart(
        minX: widget.samples.last.timestamp.toDouble() / 1000000 - 5,
        maxX: widget.samples.last.timestamp.toDouble() / 1000000,
        builder: (minX, maxX) {
          final cacheKey = Tuple2(minX.floor() ~/ 10, maxX.ceil() ~/ 10);
          final prevCacheKey =
              Tuple2(minX.floor() ~/ 10 - 1, maxX.ceil() ~/ 10 - 1);
          final nextCacheKey =
              Tuple2(minX.floor() ~/ 10 + 1, maxX.ceil() ~/ 10 + 1);
          final spotsFuture = cache.get(
            cacheKey,
            ifAbsent: getDataFromCacheKey,
          );
          cache.get(
            prevCacheKey,
            ifAbsent: getDataFromCacheKey,
          );
          cache.get(
            nextCacheKey,
            ifAbsent: getDataFromCacheKey,
          );
          return SizedBox(
            height: 400,
            child: FutureBuilder(
              future: spotsFuture,
              builder: (context, snapshot) {
                return LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    maxY: 2500,
                    minY: -2500,
                    clipData: FlClipData.all(),
                    gridData: FlGridData(
                        verticalInterval: 0.2, horizontalInterval: 500),
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
          );
        });
  }
}
