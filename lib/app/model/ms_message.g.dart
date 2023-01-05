// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSMessage _$MSMessageFromJson(Map<String, dynamic> json) => MSMessage(
      CD: json['CD'],
      MessageType: json['MessageType'],
      MessageContent: json['MessageContent'],
      Button: json['Button'],
      Purpose: json['Purpose'],
    );

Map<String, dynamic> _$MSMessageToJson(MSMessage instance) => <String, dynamic>{
      'CD': instance.CD,
      'MessageType': instance.MessageType,
      'MessageContent': instance.MessageContent,
      'Button': instance.Button,
      'Purpose': instance.Purpose,
    };
