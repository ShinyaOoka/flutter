import 'package:json_annotation/json_annotation.dart';

import '../../../../flavors.dart';
import '../../../di/injection.dart';
import '../../local_storage/shared_pref_manager.dart';
import 'base_response.dart';

part 'products_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ProductsResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<Product>? result;


  ProductsResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);

}

@JsonSerializable()
class Product {
  Product({
    this.id,
    this.display_name,
    this.lst_price,
    this.standard_price,
    this.categ_id,
    this.pos_categ_id,
    this.taxes_id,
    this.barcode,
    this.default_code,
    this.to_weight,
    this.uom_id,
    this.description_sale,
    this.description,
    this.product_tmpl_id,
    this.tracking,
    this.write_date,
    this.available_in_pos,
    this.attribute_line_ids,
    this.active,
    this.invoice_policy,
    required this.quantity,
    this.type,});


  @JsonKey(defaultValue: 0)
  int quantity = 0;
  @JsonKey(defaultValue: 0)
  double tax = 0.0;
  int? id;
  String? display_name;
  double? lst_price;
  double? standard_price;
  List<dynamic>? categ_id;
  dynamic? pos_categ_id;
  List<dynamic>? taxes_id;
  dynamic? barcode;
  dynamic? default_code;
  bool? to_weight;
  List<dynamic>? uom_id;
  dynamic? description_sale;
  dynamic? description;
  List<dynamic>? product_tmpl_id;
  String? tracking;
  String? write_date;
  bool? available_in_pos;
  List<dynamic>? attribute_line_ids;
  bool? active;
  String? invoice_policy;
  String? type;


  double getTotalPrice(){
    return quantity* lst_price!;
  }

  double getTotalCost(){
    return quantity* standard_price!;
  }


  String getImageProduct() {
    return '${getIt<UserSharePref>().getLoginConfig()?.getBaseUrl() ?? ''}/web/image?model=product.product&field=image_128&id=${id}&write_date=${write_date}&unique=1';
  }


  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
