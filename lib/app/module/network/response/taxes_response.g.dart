// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxesResponse _$TaxesResponseFromJson(Map<String, dynamic> json) =>
    TaxesResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => Tax.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$TaxesResponseToJson(TaxesResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
