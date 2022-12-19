import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_team_member.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSTeamMember extends Equatable {
  dynamic TeamMemberCD;
  dynamic Name;
  dynamic Position;
  dynamic TEL;
  dynamic TeamCD;

  MSTeamMember({
    this.TeamMemberCD,
    this.Name,
    this.Position,
    this.TEL,
    this.TeamCD,
  });

  factory MSTeamMember.fromJson(Map<String, dynamic> json) =>
      _$MSTeamMemberFromJson(json);

  Map<String, dynamic> toJson() => _$MSTeamMemberToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
    TeamMemberCD,
    Name,
    Position,
    TEL,
    TeamCD,
  ];
}
