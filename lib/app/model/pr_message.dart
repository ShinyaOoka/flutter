import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pr_message.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PRMessage extends Equatable {
  dynamic MessageCD;
  dynamic Value;
  dynamic Description;

  PRMessage({
    this.MessageCD,
    this.Value,
    this.Description,
  });

  factory PRMessage.fromJson(Map<String, dynamic> json) =>
      _$PRMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PRMessageToJson(this);

  //compare two object
  @override
  List<Object?> get props => [MessageCD, Value, Description];
}
