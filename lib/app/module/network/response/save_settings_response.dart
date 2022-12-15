import 'dart:ffi';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../res/style.dart';
import 'base_response.dart';

part 'save_settings_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SaveSettingsResponse extends BaseResponse {
  @JsonKey(defaultValue: false)
  bool result;

  SaveSettingsResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    required this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory SaveSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$SaveSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SaveSettingsResponseToJson(this);
}
