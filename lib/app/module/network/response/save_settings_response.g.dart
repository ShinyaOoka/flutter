// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveSettingsResponse _$SaveSettingsResponseFromJson(
        Map<String, dynamic> json) =>
    SaveSettingsResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'] as bool? ?? false,
    );

Map<String, dynamic> _$SaveSettingsResponseToJson(
        SaveSettingsResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
