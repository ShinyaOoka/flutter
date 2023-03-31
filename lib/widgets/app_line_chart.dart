import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/zoomable_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
  final Cache<Tuple2<int, int>, List<FlSpot>> cache = MapCache();

  @override
  Widget build(BuildContext context) {
    return ZoomableChart(
        minX: widget.samples.last.timestamp.toDouble() / 1000000 - 10,
        maxX: widget.samples.last.timestamp.toDouble() / 1000000,
        builder: (minX, maxX) {
          final cacheKey = Tuple2(minX.floor() ~/ 10, maxX.ceil() ~/ 10);
          final spotsFuture = cache.get(
            cacheKey,
            ifAbsent: (key) {
              return widget.samples
                  .where((e) {
                    final t = e.timestamp / 1000000;
                    return t > key.item1 * 10 && t < (key.item2 + 1) * 10;
                  })
                  .map((e) => FlSpot(e.timestamp / 1000000, e.value.toDouble()))
                  .toList();
            },
          );
          return Container(
            height: 200,
            child: FutureBuilder(
                future: spotsFuture,
                builder: (context, spots) {
                  return LineChart(
                    LineChartData(
                      minX: minX,
                      maxX: maxX,
                      clipData: FlClipData.all(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots.data,
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
                }),
          );
        });
  }
}
