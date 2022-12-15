import 'dart:ffi';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../res/style.dart';
import 'base_response.dart';

part 'taxes_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class TaxesResponse extends BaseResponse {
  @JsonKey(defaultValue: null)
  List<Tax>? result;

  TaxesResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory TaxesResponse.fromJson(Map<String, dynamic> json) =>
      _$TaxesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaxesResponseToJson(this);
}

class Tax {
  Tax({
    this.id,
    this.name,
    this.amount,
    this.priceInclude,
    this.includeBaseAmount,
    this.isBaseAffected,
    this.amountType});

  Tax.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    priceInclude = json['price_include'];
    includeBaseAmount = json['include_base_amount'];
    isBaseAffected = json['is_base_affected'];
    amountType = json['amount_type'];
  }
  num? id;
  String? name;
  num? amount;
  bool? priceInclude;
  bool? includeBaseAmount;
  bool? isBaseAffected;
  String? amountType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['amount'] = amount;
    map['price_include'] = priceInclude;
    map['include_base_amount'] = includeBaseAmount;
    map['is_base_affected'] = isBaseAffected;
    map['amount_type'] = amountType;
    return map;
  }

}