// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguagesResponse _$LanguagesResponseFromJson(Map<String, dynamic> json) =>
    LanguagesResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => Language.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$LanguagesResponseToJson(LanguagesResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };
