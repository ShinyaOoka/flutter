import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_classification.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSClassification extends Equatable {
  dynamic ClassificationCD;
  dynamic ClassificationSubCD;
  dynamic Value;
  dynamic Description;

  MSClassification({
    this.ClassificationCD,
    this.ClassificationSubCD,
    this.Value,
    this.Description,
  });

  factory MSClassification.fromJson(Map<String, dynamic> json) =>
      _$MSClassificationFromJson(json);

  Map<String, dynamic> toJson() => _$MSClassificationToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
        ClassificationCD,
        ClassificationSubCD,
        Value,
        Description,
      ];
}
