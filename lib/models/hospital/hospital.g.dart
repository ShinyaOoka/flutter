// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hospital _$HospitalFromJson(Map<String, dynamic> json) => Hospital()
  ..hospitalCd = json['HospitalCD'] as String?
  ..name = json['Name'] as String?
  ..address = json['Address'] as String?
  ..tel = json['TEL'] as String?
  ..emergencyMedicineLevel = json['EmergencyMedicineLevel'] as String?;

Map<String, dynamic> _$HospitalToJson(Hospital instance) => <String, dynamic>{
      'HospitalCD': instance.hospitalCd,
      'Name': instance.name,
      'Address': instance.address,
      'TEL': instance.tel,
      'EmergencyMedicineLevel': instance.emergencyMedicineLevel,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Hospital on _Hospital, Store {
  late final _$hospitalCdAtom =
      Atom(name: '_Hospital.hospitalCd', context: context);

  @override
  String? get hospitalCd {
    _$hospitalCdAtom.reportRead();
    return super.hospitalCd;
  }

  @override
  set hospitalCd(String? value) {
    _$hospitalCdAtom.reportWrite(value, super.hospitalCd, () {
      super.hospitalCd = value;
    });
  }

  late final _$nameAtom = Atom(name: '_Hospital.name', context: context);

  @override
  String? get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String? value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$addressAtom = Atom(name: '_Hospital.address', context: context);

  @override
  String? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$telAtom = Atom(name: '_Hospital.tel', context: context);

  @override
  String? get tel {
    _$telAtom.reportRead();
    return super.tel;
  }

  @override
  set tel(String? value) {
    _$telAtom.reportWrite(value, super.tel, () {
      super.tel = value;
    });
  }

  late final _$emergencyMedicineLevelAtom =
      Atom(name: '_Hospital.emergencyMedicineLevel', context: context);

  @override
  String? get emergencyMedicineLevel {
    _$emergencyMedicineLevelAtom.reportRead();
    return super.emergencyMedicineLevel;
  }

  @override
  set emergencyMedicineLevel(String? value) {
    _$emergencyMedicineLevelAtom
        .reportWrite(value, super.emergencyMedicineLevel, () {
      super.emergencyMedicineLevel = value;
    });
  }

  @override
  String toString() {
    return '''
hospitalCd: ${hospitalCd},
name: ${name},
address: ${address},
tel: ${tel},
emergencyMedicineLevel: ${emergencyMedicineLevel}
    ''';
  }
}
