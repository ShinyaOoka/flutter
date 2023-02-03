// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Classification _$ClassificationFromJson(Map<String, dynamic> json) =>
    Classification()
      ..classificationCd = json['ClassificationCD'] as String?
      ..classificationSubCd = json['ClassificationSubCD'] as String?
      ..value = json['Value'] as String?
      ..description = json['Description'] as String?;

Map<String, dynamic> _$ClassificationToJson(Classification instance) =>
    <String, dynamic>{
      'ClassificationCD': instance.classificationCd,
      'ClassificationSubCD': instance.classificationSubCd,
      'Value': instance.value,
      'Description': instance.description,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Classification on _Classification, Store {
  late final _$classificationCdAtom =
      Atom(name: '_Classification.classificationCd', context: context);

  @override
  String? get classificationCd {
    _$classificationCdAtom.reportRead();
    return super.classificationCd;
  }

  @override
  set classificationCd(String? value) {
    _$classificationCdAtom.reportWrite(value, super.classificationCd, () {
      super.classificationCd = value;
    });
  }

  late final _$classificationSubCdAtom =
      Atom(name: '_Classification.classificationSubCd', context: context);

  @override
  String? get classificationSubCd {
    _$classificationSubCdAtom.reportRead();
    return super.classificationSubCd;
  }

  @override
  set classificationSubCd(String? value) {
    _$classificationSubCdAtom.reportWrite(value, super.classificationSubCd, () {
      super.classificationSubCd = value;
    });
  }

  late final _$valueAtom =
      Atom(name: '_Classification.value', context: context);

  @override
  String? get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(String? value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: '_Classification.description', context: context);

  @override
  String? get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String? value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  @override
  String toString() {
    return '''
classificationCd: ${classificationCd},
classificationSubCd: ${classificationSubCd},
value: ${value},
description: ${description}
    ''';
  }
}
