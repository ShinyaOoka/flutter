import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'languages_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class LanguagesResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<Language>? result;

  LanguagesResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory LanguagesResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguagesResponseToJson(this);
}

@JsonSerializable()
class Language {
  Language(
      {this.id,
      this.name,
      this.code,
     });

  int? id;
  String? name;
  String? code;


  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}
