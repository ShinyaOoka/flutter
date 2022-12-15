import 'package:json_annotation/json_annotation.dart';

part 'already_read_msg_data.g.dart';

@JsonSerializable()
class AlreadyReadMessageData {
  int? user_id;
  String? thumbnail;

  AlreadyReadMessageData(this.user_id, this.thumbnail);

  factory AlreadyReadMessageData.fromJson(Map<String, dynamic> json) =>
      _$AlreadyReadMessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$AlreadyReadMessageDataToJson(this);
}