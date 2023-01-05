import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dt_report.dart';
import 'ms_classification.dart';
import 'ms_fire_station.dart';
import 'ms_hospital.dart';
import 'ms_message.dart';
import 'ms_team.dart';

part 'init_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class InitData {
  @JsonKey(defaultValue: [])
  List<DTReport> DTReports;
  @JsonKey(defaultValue: [])
  List<MSTeamMember> MSTeamMembers;
  @JsonKey(defaultValue: [])
  List<MSTeam> MSTeams;
  @JsonKey(defaultValue: [])
  List<MSFireStation> MSFireStations;
  @JsonKey(defaultValue: [])
  List<MSHospital> MSHospitals;
  @JsonKey(defaultValue: [])
  List<MSClassification> MSClassifications;
  @JsonKey(defaultValue: [])
  List<MSMessage> MSMessages;


  InitData({
    required this.DTReports,
    required this.MSTeamMembers,
    required this.MSTeams,
    required this.MSFireStations,
    required this.MSHospitals,
    required this.MSClassifications,
    required this.MSMessages,
  });

  factory InitData.fromJson(Map<String, dynamic> json) =>
      _$InitDataFromJson(json);

  Map<String, dynamic> toJson() => _$InitDataToJson(this);
}
