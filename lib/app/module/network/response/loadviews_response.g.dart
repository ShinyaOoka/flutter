// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loadviews_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadViewsResponse _$LoadViewsResponseFromJson(Map<String, dynamic> json) =>
    LoadViewsResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'] == null
          ? null
          : LoadViewsResult.fromJson(json['result']),
    );

Map<String, dynamic> _$LoadViewsResponseToJson(LoadViewsResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
