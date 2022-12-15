import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'category_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CategoryResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<Category>? result;

  CategoryResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class Category {
  Category(
      {this.id,
      this.name,
      this.parent_id,
      this.child_id,
      this.write_date,
      this.childCategories});

  int? id;
  String? name;
  dynamic parent_id;
  @JsonKey(defaultValue: [])
  List<int>? child_id;
  String? write_date;
  @JsonKey(defaultValue: [])
  List<Category>? childCategories;

  void setChildCat(List<Category>? childCategories){
    this.childCategories =  childCategories ?? [];
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
