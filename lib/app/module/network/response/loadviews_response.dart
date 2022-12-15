import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../generated/locale_keys.g.dart';
import 'base_response.dart';

part 'loadviews_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class LoadViewsResponse extends BaseResponse {
  @JsonKey(defaultValue: null)
  LoadViewsResult? result;

  LoadViewsResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory LoadViewsResponse.fromJson(Map<String, dynamic> json) =>
      _$LoadViewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoadViewsResponseToJson(this);
}

class LoadViewsResult {
  LoadViewsResult({
    this.fields,});

  LoadViewsResult.fromJson(dynamic json) {
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
  }
  Fields? fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fields != null) {
      map['fields'] = fields?.toJson();
    }
    return map;
  }

}

class Fields {
  Fields({
    this.lang,});

  Fields.fromJson(dynamic json) {
    lang = json['lang'] != null ? Lang.fromJson(json['lang']) : null;
  }
  Lang? lang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lang != null) {
      map['lang'] = lang?.toJson();
    }
    return map;
  }

}

class Lang {
  Lang({
    this.type,
    this.changeDefault,
    this.companyDependent,
    this.depends,
    this.help,
    this.manual,
    this.readonly,
    this.related,
    this.required,
    this.searchable,
    this.selection,
    this.sortable,
    this.store,
    this.string,
    this.name,});

  Lang.fromJson(dynamic json) {
    type = json['type'];
    changeDefault = json['change_default'];
    companyDependent = json['company_dependent'];
    depends = json['depends'] != null ? json['depends'].cast<String>() : [];
    help = json['help'];
    manual = json['manual'];
    readonly = json['readonly'];
    related = json['related'];
    required = json['required'];
    searchable = json['searchable'];
    selection = json['selection'] != null ? json['selection'].cast<List<dynamic>?>() : [];
    sortable = json['sortable'];
    store = json['store'];
    string = json['string'];
    name = json['name'];
  }
  String? type;
  bool? changeDefault;
  bool? companyDependent;
  List<String>? depends;
  String? help;
  bool? manual;
  bool? readonly;
  String? related;
  bool? required;
  bool? searchable;
  List<dynamic>? selection;
  bool? sortable;
  bool? store;
  String? string;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['change_default'] = changeDefault;
    map['company_dependent'] = companyDependent;
    map['depends'] = depends;
    map['help'] = help;
    map['manual'] = manual;
    map['readonly'] = readonly;
    map['related'] = related;
    map['required'] = required;
    map['searchable'] = searchable;
    map['selection'] = selection;
    map['sortable'] = sortable;
    map['store'] = store;
    map['string'] = string;
    map['name'] = name;
    return map;
  }
}
