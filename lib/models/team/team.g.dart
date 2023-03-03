// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team()
  ..teamCd = json['TeamCD'] as String?
  ..name = json['Name'] as String?
  ..abbreviation = json['Abbreviation'] as String?
  ..tel = json['TEL'] as String?
  ..fireStationCd = json['FireStationCD'] as String?;

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'TeamCD': instance.teamCd,
      'Name': instance.name,
      'Abbreviation': instance.abbreviation,
      'TEL': instance.tel,
      'FireStationCD': instance.fireStationCd,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Team on _Team, Store {
  late final _$teamCdAtom = Atom(name: '_Team.teamCd', context: context);

  @override
  String? get teamCd {
    _$teamCdAtom.reportRead();
    return super.teamCd;
  }

  @override
  set teamCd(String? value) {
    _$teamCdAtom.reportWrite(value, super.teamCd, () {
      super.teamCd = value;
    });
  }

  late final _$nameAtom = Atom(name: '_Team.name', context: context);

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

  late final _$abbreviationAtom =
      Atom(name: '_Team.abbreviation', context: context);

  @override
  String? get abbreviation {
    _$abbreviationAtom.reportRead();
    return super.abbreviation;
  }

  @override
  set abbreviation(String? value) {
    _$abbreviationAtom.reportWrite(value, super.abbreviation, () {
      super.abbreviation = value;
    });
  }

  late final _$telAtom = Atom(name: '_Team.tel', context: context);

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

  late final _$fireStationCdAtom =
      Atom(name: '_Team.fireStationCd', context: context);

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

  @override
  String toString() {
    return '''
teamCd: ${teamCd},
name: ${name},
abbreviation: ${abbreviation},
tel: ${tel},
fireStationCd: ${fireStationCd}
    ''';
  }
}
