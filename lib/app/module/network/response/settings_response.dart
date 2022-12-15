import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../generated/locale_keys.g.dart';
import 'base_response.dart';

part 'settings_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SettingsResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<SettingsResult?>?  result;

  SettingsResponse({
    String? jsonrpc,
    dynamic id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory SettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsResponseToJson(this);
}

class SettingsResult {
  SettingsResult({
    this.id,
    this.avatar128,
    this.image1024,
    this.lastUpdate,
    this.name,
    this.notificationType,
    this.odoobotState,
    this.email,
    this.lang,
    this.tz,
    this.tzOffset,
    this.signature,
    this.totpEnabled,
    this.displayName,
  });

  SettingsResult.fromJson(dynamic json) {
    id = json['id'];
    avatar128 = json['avatar_128'];
    image1024 = json['image_1024'];
    lastUpdate = json['__last_update'];
    name = json['name'];
    notificationType = json['notification_type'];
    odoobotState = json['odoobot_state'];
    email = json['email'];
    lang = json['lang'];
    tz = json['tz'];
    tzOffset = json['tz_offset'];
    signature = json['signature'];
    totpEnabled = json['totp_enabled'];
    displayName = json['display_name'];
  }

  dynamic? id;
  String? avatar128;
  String? image1024;
  String? lastUpdate;
  String? name;
  String? notificationType;
  String? odoobotState;
  String? email;
  String? lang;
  String? tz;
  String? tzOffset;
  String? signature;
  dynamic? totpEnabled;
  String? displayName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['avatar_128'] = avatar128;
    map['image_1024'] = image1024;
    map['__last_update'] = lastUpdate;
    map['name'] = name;
    map['notification_type'] = notificationType;
    map['odoobot_state'] = odoobotState;
    map['email'] = email;
    map['lang'] = lang;
    map['tz'] = tz;
    map['tz_offset'] = tzOffset;
    map['signature'] = signature;
    map['totp_enabled'] = totpEnabled;
    map['display_name'] = displayName;
    return map;
  }

  String? getNotifyType() {
    switch (this.notificationType) {
      case 'email':
        return LocaleKeys.handle_by_emails.tr();
      case 'inbox':
        return LocaleKeys.handle_in_odoo.tr();
      default:
        return LocaleKeys.handle_by_emails.tr();
    }
  }
}
