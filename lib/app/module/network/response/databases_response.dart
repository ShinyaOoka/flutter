import 'package:json_annotation/json_annotation.dart';

import '../../../../flavors.dart';
import 'base_response.dart';

part 'databases_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DatabasesResponse extends BaseResponse {
  dynamic result;


  DatabasesResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory DatabasesResponse.fromJson(Map<String, dynamic> json) =>
      _$DatabasesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DatabasesResponseToJson(this);

}
