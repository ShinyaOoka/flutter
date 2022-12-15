// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shops_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopsResponse _$ShopsResponseFromJson(Map<String, dynamic> json) =>
    ShopsResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'] == null
          ? null
          : ShopResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShopsResponseToJson(ShopsResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

ShopResult _$ShopResultFromJson(Map<String, dynamic> json) => ShopResult(
      length: json['length'] as int?,
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => Shop.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$ShopResultToJson(ShopResult instance) =>
    <String, dynamic>{
      'length': instance.length,
      'records': instance.records,
    };
