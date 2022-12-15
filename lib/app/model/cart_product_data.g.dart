// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductData _$CartProductDataFromJson(Map<String, dynamic> json) =>
    CartProductData(
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      lastIndex: json['lastIndex'] as int? ?? 0,
    );

Map<String, dynamic> _$CartProductDataToJson(CartProductData instance) =>
    <String, dynamic>{
      'products': instance.products,
      'totalPrice': instance.totalPrice,
      'totalQuantity': instance.totalQuantity,
      'lastIndex': instance.lastIndex,
    };
