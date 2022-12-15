import 'package:ak_azm_flutter/app/module/network/response/taxes_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'product_info_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ProductInfoResponse extends BaseResponse {
  @JsonKey(defaultValue: null)
  ProductInfo? result;

  ProductInfoResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory ProductInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoResponseToJson(this);
}

@JsonSerializable()
class ProductInfo {
  ProductInfo({
    this.all_prices,
    this.pricelists,
    this.warehouses,
    this.suppliers,
    this.variants,});

  @JsonKey(defaultValue: null)
  AllPrices? all_prices;
  @JsonKey(defaultValue: [])
  List<Pricelists>? pricelists;
  @JsonKey(defaultValue: [])
  List<Warehouses>? warehouses;
  @JsonKey(defaultValue: [])
  List<Suppliers>? suppliers;
  @JsonKey(defaultValue: [])
  List<Variants>? variants;

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);


}

@JsonSerializable()
class Suppliers {
  Suppliers({
    this.name,
    this.delay,
    this.price,});

  dynamic name;
  dynamic delay;
  dynamic price;

  factory Suppliers.fromJson(Map<String, dynamic> json) =>
      _$SuppliersFromJson(json);

  Map<String, dynamic> toJson() => _$SuppliersToJson(this);
}

@JsonSerializable()
class Variants {
  Variants({
    this.name,
    this.values,});

  dynamic name;
  @JsonKey(defaultValue: [])
  List<Values>? values;

  factory Variants.fromJson(Map<String, dynamic> json) =>
      _$VariantsFromJson(json);

  Map<String, dynamic> toJson() => _$VariantsToJson(this);

}

@JsonSerializable()
class Values {
  Values({
    this.name,
    this.search,});


  dynamic name;
  dynamic search;

  factory Values.fromJson(Map<String, dynamic> json) =>
      _$ValuesFromJson(json);

  Map<String, dynamic> toJson() => _$ValuesToJson(this);

}

@JsonSerializable()
class Warehouses {
  Warehouses({
    this.name,
    this.available_quantity,
    this.forecasted_quantity,
    this.uom,});


  dynamic name;
  dynamic available_quantity;
  dynamic forecasted_quantity;
  dynamic uom;

  factory Warehouses.fromJson(Map<String, dynamic> json) =>
      _$WarehousesFromJson(json);

  Map<String, dynamic> toJson() => _$WarehousesToJson(this);

}

@JsonSerializable()
class Pricelists {
  Pricelists({
    this.name,
    this.price,});


  dynamic name;
  dynamic price;

  factory Pricelists.fromJson(Map<String, dynamic> json) =>
      _$PricelistsFromJson(json);

  Map<String, dynamic> toJson() => _$PricelistsToJson(this);

}

@JsonSerializable()
class AllPrices {
  AllPrices({
    this.price_without_tax,
    this.price_with_tax,
    this.tax_details,});


  dynamic price_without_tax;
  dynamic price_with_tax;
  List<Tax>? tax_details;

  double getMarginPercent(double margin){
    return price_without_tax == 0 ? 0 : (margin/price_without_tax * 10000).round() * 0.01;
  }

  factory AllPrices.fromJson(Map<String, dynamic> json) =>
      _$AllPricesFromJson(json);

  Map<String, dynamic> toJson() => _$AllPricesToJson(this);

}
