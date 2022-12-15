// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsResponse _$SettingsResponseFromJson(Map<String, dynamic> json) =>
    SettingsResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => e == null ? null : SettingsResult.fromJson(e))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SettingsResponseToJson(SettingsResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
