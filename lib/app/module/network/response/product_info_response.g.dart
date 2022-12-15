// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInfoResponse _$ProductInfoResponseFromJson(Map<String, dynamic> json) =>
    ProductInfoResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: json['result'] == null
          ? null
          : ProductInfo.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductInfoResponseToJson(
        ProductInfoResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) => ProductInfo(
      all_prices: json['all_prices'] == null
          ? null
          : AllPrices.fromJson(json['all_prices'] as Map<String, dynamic>),
      pricelists: (json['pricelists'] as List<dynamic>?)
              ?.map((e) => Pricelists.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      warehouses: (json['warehouses'] as List<dynamic>?)
              ?.map((e) => Warehouses.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suppliers: (json['suppliers'] as List<dynamic>?)
              ?.map((e) => Suppliers.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => Variants.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{
      'all_prices': instance.all_prices,
      'pricelists': instance.pricelists,
      'warehouses': instance.warehouses,
      'suppliers': instance.suppliers,
      'variants': instance.variants,
    };

Suppliers _$SuppliersFromJson(Map<String, dynamic> json) => Suppliers(
      name: json['name'],
      delay: json['delay'],
      price: json['price'],
    );

Map<String, dynamic> _$SuppliersToJson(Suppliers instance) => <String, dynamic>{
      'name': instance.name,
      'delay': instance.delay,
      'price': instance.price,
    };

Variants _$VariantsFromJson(Map<String, dynamic> json) => Variants(
      name: json['name'],
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => Values.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$VariantsToJson(Variants instance) => <String, dynamic>{
      'name': instance.name,
      'values': instance.values,
    };

Values _$ValuesFromJson(Map<String, dynamic> json) => Values(
      name: json['name'],
      search: json['search'],
    );

Map<String, dynamic> _$ValuesToJson(Values instance) => <String, dynamic>{
      'name': instance.name,
      'search': instance.search,
    };

Warehouses _$WarehousesFromJson(Map<String, dynamic> json) => Warehouses(
      name: json['name'],
      available_quantity: json['available_quantity'],
      forecasted_quantity: json['forecasted_quantity'],
      uom: json['uom'],
    );

Map<String, dynamic> _$WarehousesToJson(Warehouses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'available_quantity': instance.available_quantity,
      'forecasted_quantity': instance.forecasted_quantity,
      'uom': instance.uom,
    };

Pricelists _$PricelistsFromJson(Map<String, dynamic> json) => Pricelists(
      name: json['name'],
      price: json['price'],
    );

Map<String, dynamic> _$PricelistsToJson(Pricelists instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };

AllPrices _$AllPricesFromJson(Map<String, dynamic> json) => AllPrices(
      price_without_tax: json['price_without_tax'],
      price_with_tax: json['price_with_tax'],
      tax_details: (json['tax_details'] as List<dynamic>?)
          ?.map((e) => Tax.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$AllPricesToJson(AllPrices instance) => <String, dynamic>{
      'price_without_tax': instance.price_without_tax,
      'price_with_tax': instance.price_with_tax,
      'tax_details': instance.tax_details,
    };
