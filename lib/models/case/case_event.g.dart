// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_event.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CaseEvent on _CaseEvent, Store {
  late final _$dateAtom = Atom(name: '_CaseEvent.date', context: context);

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  late final _$typeAtom = Atom(name: '_CaseEvent.type', context: context);

  @override
  String get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(String value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$elapsedTimeAtom =
      Atom(name: '_CaseEvent.elapsedTime', context: context);

  @override
  int get elapsedTime {
    _$elapsedTimeAtom.reportRead();
    return super.elapsedTime;
  }

  @override
  set elapsedTime(int value) {
    _$elapsedTimeAtom.reportWrite(value, super.elapsedTime, () {
      super.elapsedTime = value;
    });
  }

  late final _$msecTimeAtom =
      Atom(name: '_CaseEvent.msecTime', context: context);

  @override
  int get msecTime {
    _$msecTimeAtom.reportRead();
    return super.msecTime;
  }

  @override
  set msecTime(int value) {
    _$msecTimeAtom.reportWrite(value, super.msecTime, () {
      super.msecTime = value;
    });
  }

  late final _$rawDataAtom = Atom(name: '_CaseEvent.rawData', context: context);

  @override
  Map<String, dynamic> get rawData {
    _$rawDataAtom.reportRead();
    return super.rawData;
  }

  @override
  set rawData(Map<String, dynamic> value) {
    _$rawDataAtom.reportWrite(value, super.rawData, () {
      super.rawData = value;
    });
  }

  @override
  String toString() {
    return '''
date: ${date},
type: ${type},
elapsedTime: ${elapsedTime},
msecTime: ${msecTime},
rawData: ${rawData}
    ''';
  }
}
