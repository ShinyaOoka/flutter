import 'dart:convert';
import 'package:flutter/services.dart';

class APIForNative {
  static MethodChannel methodChannel =
      const MethodChannel('moduleFlutter/flutterToNative');
  static bool isNative = true;
  static Future<void> openBarCode() async {
    if (isNative) {
      await methodChannel.invokeMethod('openBarCode', jsonEncode(""));
    }
  }

  static Future<String> enterBarCode(String value) async {
    if (isNative) {
      return await methodChannel.invokeMethod('enterBarCode', value);
    }
    return "";
  }

  static Future<String> getSaveReceipt() async {
    if (isNative) {
      return await methodChannel.invokeMethod('getSaveReceipt', jsonEncode(""));
    }
    return "";
  }

  /*static Future<String> getDoneReceipt(QueryReceipt queryReceipt) async {
    if (isNative) {
      return await methodChannel.invokeMethod(
          'getDoneReceipt', jsonEncode(queryReceipt));
    }
    return "";
  }*/

}
