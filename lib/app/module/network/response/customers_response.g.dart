// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomersResponse _$CustomersResponseFromJson(Map<String, dynamic> json) =>
    CustomersResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'] as int?,
      error: json['error'] == null ? null : Error.fromJson(json['error']),
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CustomersResponseToJson(CustomersResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'error': instance.error,
      'result': instance.result,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      barcode: json['barcode'],
      city: json['city'],
      country_id: json['country_id'] as List<dynamic>?,
      email: json['email'],
      id: json['id'],
      lang: json['lang'],
      mobile: json['mobile'],
      name: json['name'],
      phone: json['phone'],
      property_account_position_id: json['property_account_position_id'],
      property_product_pricelist:
          json['property_product_pricelist'] as List<dynamic>?,
      state_id: json['state_id'] as List<dynamic>?,
      street: json['street'],
      vat: json['vat'],
      write_date: json['write_date'],
      zip: json['zip'],
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'barcode': instance.barcode,
      'city': instance.city,
      'country_id': instance.country_id,
      'email': instance.email,
      'id': instance.id,
      'lang': instance.lang,
      'mobile': instance.mobile,
      'name': instance.name,
      'phone': instance.phone,
      'property_account_position_id': instance.property_account_position_id,
      'property_product_pricelist': instance.property_product_pricelist,
      'state_id': instance.state_id,
      'street': instance.street,
      'vat': instance.vat,
      'write_date': instance.write_date,
      'zip': instance.zip,
    };
