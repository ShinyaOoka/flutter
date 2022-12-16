
import 'package:ak_azm_flutter/app/module/network/response/products_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_product_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CartProductData {
  @JsonKey(defaultValue: [])
  List<Product> products;
  @JsonKey(defaultValue: 0.0)
  double totalPrice;
  @JsonKey(defaultValue: 0)
  int totalQuantity;
  @JsonKey(defaultValue: 0)
  int lastIndex;

  CartProductData({
    required this.products,
    required this.totalPrice,
    required this.totalQuantity,
    required this.lastIndex,
  });

  factory CartProductData.fromJson(Map<String, dynamic> json) =>
      _$CartProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductDataToJson(this);
}

