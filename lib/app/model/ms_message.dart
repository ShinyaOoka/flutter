import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_message.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSMessage {
  dynamic CD;
  dynamic MessageType;
  dynamic MessageContent;
  dynamic Button;
  dynamic Purpose;

  MSMessage({
    this.CD,
    this.MessageType,
    this.MessageContent,
    this.Button,
    this.Purpose,
  });

  factory MSMessage.fromJson(Map<String, dynamic> json) =>
      _$MSMessageFromJson(json);

  Map<String, dynamic> toJson() => _$MSMessageToJson(this);

}
