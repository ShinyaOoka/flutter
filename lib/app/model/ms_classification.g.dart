// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ms_classification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSClassification _$MSClassificationFromJson(Map<String, dynamic> json) =>
    MSClassification(
      ClassificationCD: json['ClassificationCD'],
      ClassificationSubCD: json['ClassificationSubCD'],
      Value: json['Value'],
      Description: json['Description'],
    );

Map<String, dynamic> _$MSClassificationToJson(MSClassification instance) =>
    <String, dynamic>{
      'ClassificationCD': instance.ClassificationCD,
      'ClassificationSubCD': instance.ClassificationSubCD,
      'Value': instance.Value,
      'Description': instance.Description,
    };
