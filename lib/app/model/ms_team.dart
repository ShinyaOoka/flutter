import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_team.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSTeam extends Equatable {
 dynamic  TeamCD;
 dynamic Name;
 dynamic TEL;
 dynamic FireStationCD;

  MSTeam({
    this.TeamCD,
    this.Name,
    this.TEL,
    this.FireStationCD,
  });

  factory MSTeam.fromJson(Map<String, dynamic> json) =>
      _$MSTeamFromJson(json);

  Map<String, dynamic> toJson() => _$MSTeamToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
    TeamCD,
    Name,
    TEL,
    FireStationCD,
  ];
}
