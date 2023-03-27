import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'team.g.dart';

@JsonSerializable()
class Team extends _Team with _$Team {
  Team();
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

abstract class _Team with Store {
  @observable
  @JsonKey(name: 'TeamCD')
  String? teamCd;
  @observable
  @JsonKey(name: 'Name')
  String? name;
  @observable
  @JsonKey(name: 'Abbreviation')
  String? abbreviation;
  @observable
  @JsonKey(name: 'TEL')
  String? tel;
  @observable
  @JsonKey(name: 'FireStationCD')
  String? fireStationCd;
  @observable
  @JsonKey(name: 'Alias')
  String? alias;
}
