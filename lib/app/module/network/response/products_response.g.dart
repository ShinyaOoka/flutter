// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponse _$ProductsResponseFromJson(Map<String, dynamic> json) =>
    ProductsResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductsResponseToJson(ProductsResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      display_name: json['display_name'] as String?,
      lst_price: (json['lst_price'] as num?)?.toDouble(),
      standard_price: (json['standard_price'] as num?)?.toDouble(),
      categ_id: json['categ_id'] as List<dynamic>?,
      pos_categ_id: json['pos_categ_id'],
      taxes_id: json['taxes_id'] as List<dynamic>?,
      barcode: json['barcode'],
      default_code: json['default_code'],
      to_weight: json['to_weight'] as bool?,
      uom_id: json['uom_id'] as List<dynamic>?,
      description_sale: json['description_sale'],
      description: json['description'],
      product_tmpl_id: json['product_tmpl_id'] as List<dynamic>?,
      tracking: json['tracking'] as String?,
      write_date: json['write_date'] as String?,
      available_in_pos: json['available_in_pos'] as bool?,
      attribute_line_ids: json['attribute_line_ids'] as List<dynamic>?,
      active: json['active'] as bool?,
      invoice_policy: json['invoice_policy'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      type: json['type'] as String?,
    )..tax = (json['tax'] as num?)?.toDouble() ?? 0;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'tax': instance.tax,
      'id': instance.id,
      'display_name': instance.display_name,
      'lst_price': instance.lst_price,
      'standard_price': instance.standard_price,
      'categ_id': instance.categ_id,
      'pos_categ_id': instance.pos_categ_id,
      'taxes_id': instance.taxes_id,
      'barcode': instance.barcode,
      'default_code': instance.default_code,
      'to_weight': instance.to_weight,
      'uom_id': instance.uom_id,
      'description_sale': instance.description_sale,
      'description': instance.description,
      'product_tmpl_id': instance.product_tmpl_id,
      'tracking': instance.tracking,
      'write_date': instance.write_date,
      'available_in_pos': instance.available_in_pos,
      'attribute_line_ids': instance.attribute_line_ids,
      'active': instance.active,
      'invoice_policy': instance.invoice_policy,
      'type': instance.type,
    };
