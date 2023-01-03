import 'dart:io';
import 'dart:typed_data';

import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';
import 'package:flutter/widgets.dart';
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

  static calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
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

  static String dateTimeToString(DateTime? date, {String format = MMddyyyy}) {
    return date == null ? '' : DateFormat(format).format(date).toString();
  }

  static String formatToOtherFormat(
      String stringInputDate, String fromFormat, String toFormat) {
    var inputFormat = DateFormat(fromFormat);
    var dateInput = inputFormat.parse(stringInputDate);
    var outputFormat = DateFormat(toFormat);
    return outputFormat.format(dateInput); // "2019-08-18"
  }

  static DateTime stringToDateTime(String? stringDate,
      {String format = MMddyyyy}) {
    return stringDate == null
        ? DateTime.now()
        : DateFormat(format).parse(stringDate);
  }

  static String customReplace(
      String text, String searchText, int replaceOn, String replaceText) {
    Match result = searchText.allMatches(text).elementAt(replaceOn - 1);
    return text.replaceRange(result.start, result.end, replaceText);
  }

  static List<String> split4CharPhone(String text) {
    var tempTEL = text.replaceAllMapped(
        RegExp(r'(\d+)(\d{4})(\d{4})'), (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    List<String> temTELs = tempTEL.split(' ');
    if (temTELs.length < 2) {
      temTELs.add('');
      temTELs.add('');
    }
    if (temTELs.length < 3) {
      temTELs.add('');
    }
    return temTELs;
  }

  void removeFocus(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<ByteData> getByteFromFile(File file) async {
    return await file
        .readAsBytes()
        .then((data) => ByteData.view(data as ByteBuffer));
  }

  Future<Uint8List?> readFileByte(String? filePath) async {
    if (filePath == null) return null;
    final myUri = Uri.parse(filePath);
    final audioFile = File.fromUri(myUri);
    try {
      return Uint8List.fromList((await audioFile.readAsBytes()));
    } catch (_) {
      return null;
    }
  }
}
