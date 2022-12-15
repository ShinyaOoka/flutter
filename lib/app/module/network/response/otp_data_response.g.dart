// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpDataResponse _$OtpDataResponseFromJson(Map<String, dynamic> json) =>
    OtpDataResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => OtpData.fromJson(e))
              .toList() ??
          [],
    );

Map<String, dynamic> _$OtpDataResponseToJson(OtpDataResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };
