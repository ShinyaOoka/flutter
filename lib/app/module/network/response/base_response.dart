class BaseResponse {
  String? jsonrpc;
  dynamic id;
  Error? error;


  BaseResponse({this.jsonrpc, this.id, this.error});

  //BaseResponse({this.jsonrpc = '', this.id = 0, this.error = null});

  BaseResponse.fromJson(dynamic json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jsonrpc'] = jsonrpc;
    map['id'] = id;
    if (error != null) {
      map['error'] = error?.toJson();
    }
    return map;
  }
}

class Error {
  Error({
    this.code,
    this.message,
  });

  Error.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
  }

  dynamic code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }
}
