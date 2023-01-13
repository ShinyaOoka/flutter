// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSTeamMember _$MSTeamMemberFromJson(Map<String, dynamic> json) => MSTeamMember(
      TeamMemberCD: json['TeamMemberCD'],
      Name: json['Name'],
      Position: json['Position'],
      TEL: json['TEL'],
      TeamCD: json['TeamCD'],
      LifesaverQualification: json['LifesaverQualification'],
    );

Map<String, dynamic> _$MSTeamMemberToJson(MSTeamMember instance) =>
    <String, dynamic>{
      'TeamMemberCD': instance.TeamMemberCD,
      'Name': instance.Name,
      'Position': instance.Position,
      'TEL': instance.TEL,
      'TeamCD': instance.TeamCD,
      'LifesaverQualification': instance.LifesaverQualification,
    };
