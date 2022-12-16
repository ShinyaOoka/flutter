// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      date: json['date'] as String?,
      name: json['name'] as String?,
      accident_type: json['accident_type'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'date': instance.date,
      'name': instance.name,
      'accident_type': instance.accident_type,
      'description': instance.description,
    };
