import 'package:json_annotation/json_annotation.dart';

import '../../../model/session_info.dart';
import 'base_response.dart';

part 'login_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class LoginResponse extends BaseResponse {
  @JsonKey(defaultValue: null)
  SessionInfo? result;

  LoginResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
