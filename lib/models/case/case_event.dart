import 'package:mobx/mobx.dart';

part 'case_event.g.dart';

class CaseEvent = _CaseEvent with _$CaseEvent;

abstract class _CaseEvent with Store {
  @observable
  late DateTime date;

  @observable
  late String type;

  @observable
  late int elapsedTime;

  @observable
  late int msecTime;

  @observable
  late Map<String, dynamic> rawData;

  _CaseEvent(
      {required this.date,
      required this.type,
      required this.elapsedTime,
      required this.msecTime,
      required this.rawData});
}
