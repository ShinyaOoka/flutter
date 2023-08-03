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
  Computed<Map<String, Waveform>>? _$wavesComputed;

  @override
  Map<String, Waveform> get waves =>
      (_$wavesComputed ??= Computed<Map<String, Waveform>>(() => super.waves,
              name: '_Case.waves'))
          .value;
  Computed<List<CprCompression>>? _$cprCompressionsComputed;

  @override
  List<CprCompression> get cprCompressions => (_$cprCompressionsComputed ??=
          Computed<List<CprCompression>>(() => super.cprCompressions,
              name: '_Case.cprCompressions'))
      .value;
  Computed<List<CprCompressionByMinute>>? _$cprCompressionByMinuteComputed;

  @override
  List<CprCompressionByMinute> get cprCompressionByMinute =>
      (_$cprCompressionByMinuteComputed ??=
              Computed<List<CprCompressionByMinute>>(
                  () => super.cprCompressionByMinute,
                  name: '_Case.cprCompressionByMinute'))
          .value;
  Computed<List<Ecg12Lead>>? _$leadsComputed;

  @override
  List<Ecg12Lead> get leads => (_$leadsComputed ??=
          Computed<List<Ecg12Lead>>(() => super.leads, name: '_Case.leads'))
      .value;
  Computed<List<Snapshot>>? _$snapshotsComputed;

  @override
  List<Snapshot> get snapshots =>
      (_$snapshotsComputed ??= Computed<List<Snapshot>>(() => super.snapshots,
              name: '_Case.snapshots'))
          .value;
  Computed<List<Tuple2<int?, int?>>>? _$cprRangesComputed;

  @override
  List<Tuple2<int?, int?>> get cprRanges => (_$cprRangesComputed ??=
          Computed<List<Tuple2<int?, int?>>>(() => super.cprRanges,
              name: '_Case.cprRanges'))
      .value;
  Computed<List<int>>? _$shocksComputed;

  @override
  List<int> get shocks => (_$shocksComputed ??=
          Computed<List<int>>(() => super.shocks, name: '_Case.shocks'))
      .value;
  Computed<CaseEvent?>? _$caseSummaryComputed;

  @override
  CaseEvent? get caseSummary =>
      (_$caseSummaryComputed ??= Computed<CaseEvent?>(() => super.caseSummary,
              name: '_Case.caseSummary'))
          .value;
  Computed<Waveform>? _$cprAccelComputed;

  @override
  Waveform get cprAccel => (_$cprAccelComputed ??=
          Computed<Waveform>(() => super.cprAccel, name: '_Case.cprAccel'))
      .value;
  Computed<PatientData?>? _$patientDataComputed;

  @override
  PatientData? get patientData =>
      (_$patientDataComputed ??= Computed<PatientData?>(() => super.patientData,
              name: '_Case.patientData'))
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
displayableEvents: ${displayableEvents},
waves: ${waves},
cprCompressions: ${cprCompressions},
cprCompressionByMinute: ${cprCompressionByMinute},
leads: ${leads},
snapshots: ${snapshots},
cprRanges: ${cprRanges},
shocks: ${shocks},
caseSummary: ${caseSummary},
cprAccel: ${cprAccel},
patientData: ${patientData}
    ''';
  }
}
