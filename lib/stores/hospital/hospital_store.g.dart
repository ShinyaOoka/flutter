// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HospitalStore on _HospitalStore, Store {
  late final _$hospitalsAtom =
      Atom(name: '_HospitalStore.hospitals', context: context);

  @override
  ObservableMap<String, Hospital> get hospitals {
    _$hospitalsAtom.reportRead();
    return super.hospitals;
  }

  @override
  set hospitals(ObservableMap<String, Hospital> value) {
    _$hospitalsAtom.reportWrite(value, super.hospitals, () {
      super.hospitals = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_HospitalStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$getHospitalsAsyncAction =
      AsyncAction('_HospitalStore.getHospitals', context: context);

  @override
  Future<dynamic> getHospitals() {
    return _$getHospitalsAsyncAction.run(() => super.getHospitals());
  }

  @override
  String toString() {
    return '''
hospitals: ${hospitals},
success: ${success}
    ''';
  }
}
