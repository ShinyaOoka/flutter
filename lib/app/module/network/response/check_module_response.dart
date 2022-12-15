import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'check_module_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CheckModuleResponse extends BaseResponse {
  @JsonKey(defaultValue: null)
  CheckModuleResult? result;

  CheckModuleResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory CheckModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckModuleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckModuleResponseToJson(this);
}

@JsonSerializable()
class CheckModuleResult {
  int? length;
  List<Module>? records;

  CheckModuleResult({this.length, this.records});

  factory CheckModuleResult.fromJson(Map<String, dynamic> json) =>
      _$CheckModuleResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckModuleResultToJson(this);
}

class Module {
  Module({
    this.id,
    this.icon,
    this.toBuy,
    this.name,
    this.state,
    this.summary,
    this.website,
    this.application,
    this.shortdesc,
  });

  Module.fromJson(dynamic json) {
    id = json['id'];
    icon = json['icon'];
    toBuy = json['to_buy'];
    name = json['name'];
    state = json['state'];
    summary = json['summary'];
    website = json['website'];
    application = json['application'];
    shortdesc = json['shortdesc'];
  }

  int? id;
  dynamic icon;
  dynamic toBuy;
  String? name;
  dynamic state;
  String? summary;
  String? website;
  dynamic application;
  dynamic shortdesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['icon'] = icon;
    map['to_buy'] = toBuy;
    map['name'] = name;
    map['state'] = state;
    map['summary'] = summary;
    map['website'] = website;
    map['application'] = application;
    map['shortdesc'] = shortdesc;
    return map;
  }

  bool isPos() {
    return state == "installed" || state == "uninstallable" && name == "point_of_sale";
  }
}
