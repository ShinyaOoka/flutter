// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Case on _Case, Store {
  Computed<ObservableList<Tuple2<int, CaseEvent>>>? _$displayableEventsComputed;

  @override
  ObservableList<Tuple2<int, CaseEvent>> get displayableEvents =>
      (_$displayableEventsComputed ??=
              Computed<ObservableList<Tuple2<int, CaseEvent>>>(
                  () => super.displayableEvents,
                  name: '_Case.displayableEvents'))
          .value;

  late final _$eventsAtom = Atom(name: '_Case.events', context: context);

  @override
  ObservableList<CaseEvent> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<CaseEvent> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  late final _$nativeCaseAtom =
      Atom(name: '_Case.nativeCase', context: context);

  @override
  NativeCase? get nativeCase {
    _$nativeCaseAtom.reportRead();
    return super.nativeCase;
  }

  @override
  set nativeCase(NativeCase? value) {
    _$nativeCaseAtom.reportWrite(value, super.nativeCase, () {
      super.nativeCase = value;
    });
  }

  late final _$startTimeAtom = Atom(name: '_Case.startTime', context: context);

  @override
  DateTime? get startTime {
    _$startTimeAtom.reportRead();
    return super.startTime;
  }

  @override
  set startTime(DateTime? value) {
    _$startTimeAtom.reportWrite(value, super.startTime, () {
      super.startTime = value;
    });
  }

  late final _$endTimeAtom = Atom(name: '_Case.endTime', context: context);

  @override
  DateTime? get endTime {
    _$endTimeAtom.reportRead();
    return super.endTime;
  }

  @override
  set endTime(DateTime? value) {
    _$endTimeAtom.reportWrite(value, super.endTime, () {
      super.endTime = value;
    });
  }

  @override
  String toString() {
    return '''
events: ${events},
nativeCase: ${nativeCase},
startTime: ${startTime},
endTime: ${endTime},
displayableEvents: ${displayableEvents}
    ''';
  }
}
