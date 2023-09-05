// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team()
  ..teamCd = json['TeamCD'] as String?
  ..name = json['Name'] as String?
  ..fireStationCd = json['FireStationCD'] as String?
  ..alias = json['Alias'] as String?;

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'TeamCD': instance.teamCd,
      'Name': instance.name,
      'FireStationCD': instance.fireStationCd,
      'Alias': instance.alias,
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

  late final _$aliasAtom = Atom(name: '_Team.alias', context: context);

  @override
  String? get alias {
    _$aliasAtom.reportRead();
    return super.alias;
  }

  @override
  set alias(String? value) {
    _$aliasAtom.reportWrite(value, super.alias, () {
      super.alias = value;
    });
  }

  @override
  String toString() {
    return '''
teamCd: ${teamCd},
name: ${name},
fireStationCd: ${fireStationCd},
alias: ${alias}
    ''';
  }
}
