import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../res/colors.dart';

class ToastUtil {
  static void showToast(String msg,
      {Color color = kColorA6000000,
      int timeInSecForIos = 1,
      Toast toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
        msg: '$msg',
        toastLength: toastLength,
        timeInSecForIosWeb: timeInSecForIos,
        backgroundColor: color);
  }

  static void successToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: kColor5EB937,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void errorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: kColorF0485D,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
