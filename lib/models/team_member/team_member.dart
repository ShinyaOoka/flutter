import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/serializers/bool_to_int_converter.dart';

part 'team_member.g.dart';

@JsonSerializable()
class TeamMember extends _TeamMember with _$TeamMember {
  TeamMember();
  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}

abstract class _TeamMember with Store {
  @observable
  @JsonKey(name: 'TeamMemberCD')
  String? teamMemberCd;
  @observable
  @JsonKey(name: 'Name')
  String? name;
  @observable
  @JsonKey(name: 'Position')
  String? position;
  @observable
  @JsonKey(name: 'TEL')
  String? tel;
  @observable
  @JsonKey(name: 'TeamCD')
  String? teamCd;
  @observable
  @JsonKey(name: 'LifesaverQualification')
  @IntToBoolConverter()
  bool? lifesaverQualification;
}
