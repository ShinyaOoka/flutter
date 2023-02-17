import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

part 'case.g.dart';

class Case = _Case with _$Case;

abstract class _Case with Store {
  @observable
  ObservableList<CaseEvent> events = ObservableList();

  @observable
  NativeCase? nativeCase;

  @observable
  DateTime? startTime;

  @observable
  DateTime? endTime;

  @computed
  ObservableList<Tuple2<int, CaseEvent>> get displayableEvents {
    final hiddenEvents = <String>{};
    hiddenEvents.addAll(events.map((e) => e.type));

    final shownEvents = events
        .asMap()
        .entries
        .map((e) => Tuple2(e.key, e.value))
        .where((event) {
          var keep = true;
          if (startTime != null) {
            keep &=
                event.item2.date.toLocal().compareTo(startTime!.toLocal()) >= 0;
          }
          if (endTime != null) {
            keep &=
                event.item2.date.toLocal().compareTo(endTime!.toLocal()) <= 0;
          }
          return keep;
        })
        .where((e) {
          return e.item2.type != "AedContinAnalysis" &&
              e.item2.type != "ContinWaveRec" &&
              e.item2.type != "DefibTrace" &&
              e.item2.type != "DisplayInfo" &&
              e.item2.type != "InstrumentPacket" &&
              e.item2.type != "PrtTrace" &&
              e.item2.type != "TraceConfigs" &&
              e.item2.type != "TrendRpt";
        })
        .toList()
        .asObservable();
    hiddenEvents.removeAll(shownEvents.map((e) => e.item2.type));
    print("Hidden events or out of start time, end time range");
    for (var element in hiddenEvents) {
      print(element);
    }
    return shownEvents;
  }
}
