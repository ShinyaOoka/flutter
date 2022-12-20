// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitData _$InitDataFromJson(Map<String, dynamic> json) => InitData(
      DTReports: (json['DTReports'] as List<dynamic>?)
              ?.map((e) => DTReport.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      MSTeamMembers: (json['MSTeamMembers'] as List<dynamic>?)
              ?.map((e) => MSTeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      MSTeams: (json['MSTeams'] as List<dynamic>?)
              ?.map((e) => MSTeam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      MSFireStations: (json['MSFireStations'] as List<dynamic>?)
              ?.map((e) => MSFireStation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      MSHospitals: (json['MSHospitals'] as List<dynamic>?)
              ?.map((e) => MSHospital.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      MSClassifications: (json['MSClassifications'] as List<dynamic>?)
              ?.map((e) => MSClassification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$InitDataToJson(InitData instance) => <String, dynamic>{
      'DTReports': instance.DTReports,
      'MSTeamMembers': instance.MSTeamMembers,
      'MSTeams': instance.MSTeams,
      'MSFireStations': instance.MSFireStations,
      'MSHospitals': instance.MSHospitals,
      'MSClassifications': instance.MSClassifications,
    };
