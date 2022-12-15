import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'customers_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CustomersResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<Customer>? result;

  CustomersResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory CustomersResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersResponseToJson(this);
}

@JsonSerializable()
class Customer {
  dynamic barcode;
  dynamic city;
  List<dynamic>? country_id;
  dynamic email;
  dynamic id;
  dynamic lang;
  dynamic mobile;
  dynamic name;
  dynamic phone;
  dynamic property_account_position_id;
  List<dynamic>? property_product_pricelist;
  List<dynamic>? state_id;
  dynamic street;
  dynamic vat;
  dynamic write_date;
  dynamic zip;

  Customer(
      {this.barcode,
      this.city,
      this.country_id,
      this.email,
      this.id,
      this.lang,
      this.mobile,
      this.name,
      this.phone,
      this.property_account_position_id,
      this.property_product_pricelist,
      this.state_id,
      this.street,
      this.vat,
      this.write_date,
      this.zip});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
