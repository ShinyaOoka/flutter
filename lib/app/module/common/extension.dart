import 'dart:io';
import 'dart:typed_data';

import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'config.dart';

extension DateTimeFormatter on DateTime {
  String shortTimeFormatted() {
    return DateFormat(
      'h:mm a',
    ).format(this);
  }

  String shortTime24hFormatted() {
    return DateFormat(
      'HH:mm',
    ).format(this);
  }

  String shortDateFormatted() {
    return DateFormat(
      'MMM dd',
    ).format(this);
  }

  String fromNow() {
    return Jiffy(this).fromNow();
  }

  String fromNowShort() {
    return Jiffy(this)
        .fromNow()
        .replaceAll('a few seconds', '1s')
        .replaceAll('a second', '1s')
        .replaceAll('seconds', 's')
        .replaceAll('second', 's')
        .replaceAll('a minute', '1m')
        .replaceAll('minutes', 'm')
        .replaceAll('minute', 'm')
        .replaceAll('an hour', '1h')
        .replaceAll('hours', 'h')
        .replaceAll('hour', 'h')
        .replaceAll('a day', '1d')
        .replaceAll('days', 'd')
        .replaceAll('day', 'd')
        .replaceAll('a month', '1M')
        .replaceAll('an month', '1M')
        .replaceAll('months', 'M')
        .replaceAll('month', 'M')
        .replaceAll('a year', '1y')
        .replaceAll('an year', '1y')
        .replaceAll('years', 'y')
        .replaceAll('year', 'y')
        .replaceAll('ago', '')
        .replaceAll(' ', '');
  }

  String fromNowLimit({int dayDiff = 1}) =>
      DateTime.now().difference(this).inDays > dayDiff
          ? shortDateFormatted()
          : shortTimeFormatted();
}

extension Ex on String {
  String get reverse => split('').reversed.join();
}

extension ContextEx on BuildContext {
  void hideKeyboardIfShowed() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

//validate email
extension EmailValidate on String {
  bool isValidEmail() {
    return RegExp(
            r"^[ a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

class Utils {
  Utils._();

  void back() async {
    NavigationService().back();
  }

  static calculateAge(DateTime? birthDate, DateTime? currentDate) {
    if (birthDate == null || currentDate == null) return 0;
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static String dateTimeToString(DateTime? date, {String format = yyyyMMdd}) {
    return date == null ? '' : DateFormat(format).format(date).toString();
  }

  static String formatToOtherFormat(
      String stringInputDate, String fromFormat, String toFormat) {
    if (stringInputDate.isEmpty) return '';
    var inputFormat = DateFormat(fromFormat);
    var dateInput = inputFormat.parse(stringInputDate);
    var outputFormat = DateFormat(toFormat);
    return outputFormat.format(dateInput); // "2019-08-18"
  }

  static DateTime? stringToDateTime(String? stringDate,
      {String format = yyyyMMdd}) {
    return stringDate == null || stringDate.isEmpty
        ? null
        : DateFormat(format).parse(stringDate);
  }

  static String customReplace(
      String text, String searchText, int replaceOn, String replaceText) {
    Match result = searchText.allMatches(text).elementAt(replaceOn - 1);
    return text.replaceRange(result.start, result.end, replaceText);
  }

  static List<String> split4CharPhone(String text) {
    if(text.isBlank == true) return ['','',''];
    var tempText = text.reverse;
    var buffer = new StringBuffer();
    for (int i = 0; i < tempText.length; i++) {
      buffer.write(tempText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != tempText.length && nonZeroIndex < 9) {
        buffer.write(space);
      }
    }
    List<String> tempTELs =  buffer.toString().split(space);
    //if list = 1 add middle & first
    if (tempTELs.length < 2) {
      tempTELs.add('');
      tempTELs.add('');
    }
    //if list = 2 add  first
    if (tempTELs.length < 3) {
      tempTELs.add('');
    }
    //revert list
    tempTELs = tempTELs.reversed.toList();
    //revert string in element of list
    return tempTELs.map((e) => e.reverse).toList();
  }

  static void removeFocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static Future<ByteData> getByteFromFile(File file) async {
    return await file
        .readAsBytes()
        .then((data) => ByteData.view(data as ByteBuffer));
  }

  static Future<Uint8List?> readFileByte(String? filePath) async {
    if (filePath == null) return null;
    final myUri = Uri.parse(filePath);
    final audioFile = File.fromUri(myUri);
    try {
      return Uint8List.fromList((await audioFile.readAsBytes()));
    } catch (_) {
      return null;
    }
  }

  static String importStringToDb(dynamic? v1, dynamic? v2, dynamic? v3){
    return '$v1$slash$v2$slash$v3';
  }

  static List<dynamic?> exportDataFromDb(String? data){
    if(data.isBlank == true) return [null, null, null];
    List<dynamic?> list = data!.split(slash);
    if (list.length < 2) {
      list.add(null);
      list.add(null);
    }
    if (list.length < 3) {
      list.add(null);
    }
    return list;
  }



}
