// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire_station_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FireStationStore on _FireStationStore, Store {
  late final _$fireStationsAtom =
      Atom(name: '_FireStationStore.fireStations', context: context);

  @override
  ObservableMap<String, FireStation> get fireStations {
    _$fireStationsAtom.reportRead();
    return super.fireStations;
  }

  @override
  set fireStations(ObservableMap<String, FireStation> value) {
    _$fireStationsAtom.reportWrite(value, super.fireStations, () {
      super.fireStations = value;
    });
  }

  late final _$getAllFireStationsAsyncAction =
      AsyncAction('_FireStationStore.getAllFireStations', context: context);

  @override
  Future<List<FireStation>> getAllFireStations() {
    return _$getAllFireStationsAsyncAction
        .run(() => super.getAllFireStations());
  }

  late final _$getFireStationsByIdsAsyncAction =
      AsyncAction('_FireStationStore.getFireStationsByIds', context: context);

  @override
  Future<List<FireStation>> getFireStationsByIds(List<String> ids) {
    return _$getFireStationsByIdsAsyncAction
        .run(() => super.getFireStationsByIds(ids));
  }

  late final _$getFireStationByIdAsyncAction =
      AsyncAction('_FireStationStore.getFireStationById', context: context);

  @override
  Future<FireStation> getFireStationById(String id) {
    return _$getFireStationByIdAsyncAction
        .run(() => super.getFireStationById(id));
  }

  @override
  String toString() {
    return '''
fireStations: ${fireStations}
    ''';
  }
}
