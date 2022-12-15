// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'databases_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatabasesResponse _$DatabasesResponseFromJson(Map<String, dynamic> json) =>
    DatabasesResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'],
    );

Map<String, dynamic> _$DatabasesResponseToJson(DatabasesResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
