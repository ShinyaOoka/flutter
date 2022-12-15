import 'package:ak_azm_flutter/app/model/login_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class LoginData {
  @JsonKey(defaultValue: [])
  List<LoginConfig> data;

  LoginData({
    required this.data,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

