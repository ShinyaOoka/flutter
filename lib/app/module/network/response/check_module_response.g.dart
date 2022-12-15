// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_module_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckModuleResponse _$CheckModuleResponseFromJson(Map<String, dynamic> json) =>
    CheckModuleResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'] == null
          ? null
          : CheckModuleResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckModuleResponseToJson(
        CheckModuleResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

CheckModuleResult _$CheckModuleResultFromJson(Map<String, dynamic> json) =>
    CheckModuleResult(
      length: json['length'] as int?,
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => Module.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$CheckModuleResultToJson(CheckModuleResult instance) =>
    <String, dynamic>{
      'length': instance.length,
      'records': instance.records,
    };
