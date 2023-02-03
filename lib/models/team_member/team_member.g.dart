// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember()
  ..teamMemberCd = json['TeamMemberCD'] as String?
  ..name = json['Name'] as String?
  ..position = json['Position'] as String?
  ..tel = json['TEL'] as String?
  ..teamCd = json['TeamCD'] as String?
  ..lifesaverQualification = _$JsonConverterFromJson<int, bool>(
      json['LifesaverQualification'], const IntToBoolConverter().fromJson);

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'TeamMemberCD': instance.teamMemberCd,
      'Name': instance.name,
      'Position': instance.position,
      'TEL': instance.tel,
      'TeamCD': instance.teamCd,
      'LifesaverQualification': _$JsonConverterToJson<int, bool>(
          instance.lifesaverQualification, const IntToBoolConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamMember on _TeamMember, Store {
  late final _$teamMemberCdAtom =
      Atom(name: '_TeamMember.teamMemberCd', context: context);

  @override
  String? get teamMemberCd {
    _$teamMemberCdAtom.reportRead();
    return super.teamMemberCd;
  }

  @override
  set teamMemberCd(String? value) {
    _$teamMemberCdAtom.reportWrite(value, super.teamMemberCd, () {
      super.teamMemberCd = value;
    });
  }

  late final _$nameAtom = Atom(name: '_TeamMember.name', context: context);

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

  late final _$positionAtom =
      Atom(name: '_TeamMember.position', context: context);

  @override
  String? get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(String? value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  late final _$telAtom = Atom(name: '_TeamMember.tel', context: context);

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

  late final _$teamCdAtom = Atom(name: '_TeamMember.teamCd', context: context);

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

  late final _$lifesaverQualificationAtom =
      Atom(name: '_TeamMember.lifesaverQualification', context: context);

  @override
  bool? get lifesaverQualification {
    _$lifesaverQualificationAtom.reportRead();
    return super.lifesaverQualification;
  }

  @override
  set lifesaverQualification(bool? value) {
    _$lifesaverQualificationAtom
        .reportWrite(value, super.lifesaverQualification, () {
      super.lifesaverQualification = value;
    });
  }

  @override
  String toString() {
    return '''
teamMemberCd: ${teamMemberCd},
name: ${name},
position: ${position},
tel: ${tel},
teamCd: ${teamCd},
lifesaverQualification: ${lifesaverQualification}
    ''';
  }
}
