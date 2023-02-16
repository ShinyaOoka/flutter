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
    return events
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
          return e.item2.type == "Aed" ||
              e.item2.type == "AlarmLimits" ||
              e.item2.type == "DataChannels" ||
              e.item2.type == "DefibTrace" ||
              e.item2.type == "DeviceConfiguration" ||
              e.item2.type == "DisplayInfo" ||
              e.item2.type == "NewCase" ||
              e.item2.type == "PatientInfo" ||
              e.item2.type == "PrtTrace" ||
              e.item2.type == "SnapshotRpt" ||
              e.item2.type == "SysLogEntry" ||
              e.item2.type == "TreatmentSnapshotEvt" ||
              e.item2.type.startsWith("AnnotationEvt");
        })
        .toList()
        .asObservable();
  }
}
