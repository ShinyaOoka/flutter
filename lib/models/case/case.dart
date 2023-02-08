import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:mobx/mobx.dart';

part 'case.g.dart';

class Case = _Case with _$Case;

abstract class _Case with Store {
  @observable
  ObservableList<CaseEvent> events = ObservableList();
}
