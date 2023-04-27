import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:collection/collection.dart';

List<Sample> movingAverage(List<Sample> samples, int windowSize) {
  int i = 0;
  List<Sample> result = [];
  while (i < samples.length - windowSize + 1) {
    double average =
        samples.sublist(i, i + windowSize).map((e) => e.value).sum / windowSize;
    result.add(Sample(timestamp: samples[i].timestamp, value: average));
    i += 1;
  }
  while (i < samples.length) {
    result
        .add(Sample(timestamp: samples[i].timestamp, value: samples[i].value));
    i += 1;
  }
  return result;
}
