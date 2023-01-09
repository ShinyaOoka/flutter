import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'object_search.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectSearch {
 dynamic CD;
 dynamic Name;

  ObjectSearch({
    this.CD,
    this.Name,
  });

  factory ObjectSearch.fromJson(Map<String, dynamic> json) =>
      _$ObjectSearchFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectSearchToJson(this);

}
