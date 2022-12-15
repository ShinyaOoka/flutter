import 'package:json_annotation/json_annotation.dart';

import 'base_response.dart';

part 'otp_data_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class OtpDataResponse extends BaseResponse {
  @JsonKey(defaultValue: [])
  List<OtpData>? result;

  OtpDataResponse({
    String? jsonrpc,
    int? id,
    Error? error,
    this.result,
  }) : super(jsonrpc: jsonrpc, id: id, error: error);

  factory OtpDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpDataResponseToJson(this);
}

class OtpData {
  OtpData({
    this.id,
    this.url,
    this.qrcode,
    this.lastUpdate,
    this.secret,
    this.code,
    this.displayName,
  });

  OtpData.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    qrcode = json['qrcode'];
    lastUpdate = json['__last_update'];
    secret = json['secret'];
    code = json['code'];
    displayName = json['display_name'];
  }

  int? id;
  String? url;
  String? qrcode;
  String? lastUpdate;
  String? secret;
  String? code;
  String? displayName;

  Otp? getOtpData() {
    final uri = Uri.parse(url ?? '');
    return Otp.fromJson(uri.queryParameters);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['qrcode'] = qrcode;
    map['__last_update'] = lastUpdate;
    map['secret'] = secret;
    map['code'] = code;
    map['display_name'] = displayName;
    return map;
  }
}

class Otp {
  Otp({
    this.secret,
    this.issuer,
    this.algorithm,
    this.digits,
    this.period,
  });

  Otp.fromJson(dynamic json) {
    secret = json['secret'];
    issuer = json['issuer'];
    algorithm = json['algorithm'];
    digits = int.tryParse(json['digits']);
    period = int.tryParse(json['period']);
  }

  String? secret;
  String? issuer;
  String? algorithm;
  int? digits;
  int? period;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['secret'] = secret;
    map['issuer'] = issuer;
    map['algorithm'] = algorithm;
    map['digits'] = digits;
    map['period'] = period;
    return map;
  }
}
