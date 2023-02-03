// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireStation _$FireStationFromJson(Map<String, dynamic> json) => FireStation()
  ..fireStationCd = json['FireStationCD'] as String?
  ..name = json['Name'] as String?
  ..address = json['Address'] as String?
  ..tel = json['TEL'] as String?;

Map<String, dynamic> _$FireStationToJson(FireStation instance) =>
    <String, dynamic>{
      'FireStationCD': instance.fireStationCd,
      'Name': instance.name,
      'Address': instance.address,
      'TEL': instance.tel,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FireStation on _FireStation, Store {
  late final _$fireStationCdAtom =
      Atom(name: '_FireStation.fireStationCd', context: context);

  @override
  String? get fireStationCd {
    _$fireStationCdAtom.reportRead();
    return super.fireStationCd;
  }

  @override
  set fireStationCd(String? value) {
    _$fireStationCdAtom.reportWrite(value, super.fireStationCd, () {
      super.fireStationCd = value;
    });
  }

  late final _$nameAtom = Atom(name: '_FireStation.name', context: context);

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

  late final _$addressAtom =
      Atom(name: '_FireStation.address', context: context);

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

  late final _$telAtom = Atom(name: '_FireStation.tel', context: context);

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

  @override
  String toString() {
    return '''
fireStationCd: ${fireStationCd},
name: ${name},
address: ${address},
tel: ${tel}
    ''';
  }
}
