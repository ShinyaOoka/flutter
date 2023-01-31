import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'classification.g.dart';

@JsonSerializable()
class Classification extends _Classification with _$Classification {
  Classification();
  factory Classification.fromJson(Map<String, dynamic> json) =>
      _$ClassificationFromJson(json);
  Map<String, dynamic> toJson() => _$ClassificationToJson(this);
}

abstract class _Classification with Store {
  @observable
  @JsonKey(name: 'ClassificationCD')
  String? classificationCd;
  @observable
  @JsonKey(name: 'ClassificationSubCD')
  String? classificationSubCd;
  @observable
  @JsonKey(name: 'Value')
  String? value;
  @observable
  @JsonKey(name: 'Description')
  String? description;
}
