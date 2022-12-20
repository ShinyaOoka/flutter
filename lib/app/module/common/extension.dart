import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';
import 'package:ak_azm_flutter/app/module/local_storage/shared_pref_manager.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import '../../../flavors.dart';
import '../../di/injection.dart';
import '../../view/widget_utils/custom/image_holder.dart';
import 'config.dart';

ReturnType run<ReturnType>(ReturnType Function() operation) {
  return operation();
}

extension ScopeFunctionsForObject<T extends Object> on T {
  ReturnType let<ReturnType>(ReturnType Function(T self) operation_for) {
    return operation_for(this);
  }

  T also(void Function(T self) operation_for) {
    operation_for(this);
    return this;
  }
}

extension DurationFormatter on Duration {
  String dayHourMinuteSecondFormatted() {
    return [
      inDays,
      inHours.remainder(24),
      inMinutes.remainder(60),
      inSeconds.remainder(60)
    ].map((seg) {
      return seg.toString().padLeft(2, '0');
    }).join(':');
  }

  String minuteSecondFormatted() {
    return [
      inMinutes.remainder(60),
      inSeconds.remainder(60),
    ].map((seg) {
      return seg.toString().padLeft(2, '0');
    }).join(':');
  }
}

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

extension FileTypeEx on String {
  bool get isVideoExtension {
    final value = toLowerCase();

    return (value == 'mov') || (value == 'mp4') || (value == 'mpv');
  }

  bool get isImageExtension {
    final value = toLowerCase();

    return (value == 'png') ||
        (value == 'jpg') ||
        (value == 'jpeg') ||
        (value == 'heic');
  }

  bool get isAudioExtension {
    final value = toLowerCase();

    return (value == 'mp3') ||
        (value == 'm4a') ||
        (value == 'wav') ||
        (value == 'caf') ||
        (value == 'aiff');
  }
}

extension FileUtils on String {
  String get fileName => substring(lastIndexOf('/') + 1);

  bool get isImageFileFromMime => startsWith('image');
}

Future<String> getDeviceID() async {
  // var deviceInfo = DeviceInfoPlugin();
  // if (Platform.isAndroid) {
  //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   return androidDeviceInfo.androidId ?? ''; // unique ID on Android
  // } else if (Platform.isIOS) {
  //   var iosDeviceInfo = await deviceInfo.iosInfo;
  //   return iosDeviceInfo.identifierForVendor ?? ''; // unique ID on iOS
  // } else {
  //   return '';
  // }
  return '';
}

extension ContextEx on BuildContext {
  void hideKeyboardIfShowed() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
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

convertChatTimeUnix(int current_unix_time, int postUniqTime) {
  int diff_sec = current_unix_time - postUniqTime;
  String unit = '';
  double time = 0;
  if (diff_sec < 60) {
    time = (diff_sec == 0 ? 1 : diff_sec) as double;
    unit = '秒前'; //seconds ago
  } else {
    if (diff_sec < 3600) {
      time = diff_sec / 60;
      unit = '分前'; //minutes ago
    } else {
      if (diff_sec < 86400) {
        time = diff_sec / 3600;
        unit = '時間前'; //hours ago
      } else {
        if (diff_sec < 2764800) {
          time = diff_sec / 86400;
          unit = '日前'; //days ago
        } else {
          // Calendar cal = Calendar.getInstance(Locale.US);
          // cal.setTimeInMillis(postUniqTime * 1000L);
          // return DateFormat.format('MM月dd日', cal).toString();
          Locale locale = Locale('vi', 'VN');
          DateTime date = DateTime.fromMillisecondsSinceEpoch(postUniqTime);
          var format = DateFormat("yMd");
          var dateString = format.format(date);
          return dateString;
        }
      }
    }
  }
  return time.toString() + unit;
}


//validate email
extension EmailValidate on String {
  bool isValidEmail() {
    return RegExp(
        r"^[ a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}


String dateTimeFromString(dynamic? date,{ String format = MMddyyyy}) {
  return date == null || date == '' || date is! String ? '' : DateFormat(format).format(DateTime.parse(date)).toString();
}

class Utils {
  Utils._();

  static String concatListToString(List<dynamic> data, String mapKey) {
    StringBuffer buffer = StringBuffer();
    buffer.writeAll(data.map<String>((element) => element.mapKey).toList(), ', ');
    return buffer.toString();
  }

  static printJson(dynamic json){
    print(jsonEncode(json));
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Widget imageFromByte(Uint8List? data, double width, double height) {
    return CachedMemoryImage(
      uniqueKey: 'app://image/1',
      bytes: data,
      fit: BoxFit.fitHeight,
      width: width,
      height: height,
      placeholder: ImageHolder(
        asset: 'assets/images/placeholder.jpg',
        width: width,
        height: height,
      ),
      errorWidget: ImageHolder(
        asset: 'assets/images/placeholder.jpg',
        width: width,
        height: height,
      ),
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return Base64Decoder().convert(base64String);
  }

  static  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  /// Returns whether a dynamic value PROBABLY
  /// has the isEmpty getter/method by checking
  /// standard dart types that contains it.
  ///
  /// This is here to for the 'DRY'
  static bool? _isEmpty(dynamic value) {
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is Iterable || value is Map) {
      return value.isEmpty as bool?;
    }
    return false;
  }

  /// Returns whether a dynamic value PROBABLY
  /// has the length getter/method by checking
  /// standard dart types that contains it.
  ///
  /// This is here to for the 'DRY'
  static bool _hasLength(dynamic value) {
    return value is Iterable || value is String || value is Map;
  }

  /// Obtains a length of a dynamic value
  /// by previously validating it's type
  ///
  /// Note: if [value] is double/int
  /// it will be taking the .toString
  /// length of the given value.
  ///
  /// Note 2: **this may return null!**
  ///
  /// Note 3: null [value] returns null.
  static int? _obtainDynamicLength(dynamic value) {
    if (value == null) {
      // ignore: avoid_returning_null
      return null;
    }

    if (_hasLength(value)) {
      return value.length as int?;
    }

    if (value is int) {
      return value.toString().length;
    }

    if (value is double) {
      return value.toString().replaceAll('.', '').length;
    }

    // ignore: avoid_returning_null
    return null;
  }


  /// Checks if data is null.
  static bool isNull(dynamic value) => value == null;

  /// In dart2js (in flutter v1.17) a var by default is undefined.
  /// *Use this only if you are in version <- 1.17*.
  /// So we assure the null type in json convertions to avoid the
  /// "value":value==null?null:value; someVar.nil will force the null type
  /// if the var is null or undefined.
  /// `nil` taken from ObjC just to have a shorter sintax.
  static dynamic nil(dynamic s) => s == null ? null : s;

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isNullOrBlank(dynamic value) {
    if (isNull(value)) {
      return true;
    }

    // Pretty sure that isNullOrBlank should't be validating
    // iterables... but I'm going to keep this for compatibility.
    return _isEmpty(value);
  }

  /// Checks if data is null or blank (empty or only contains whitespace).
  static bool? isBlank(dynamic value) {
    return _isEmpty(value);
  }

  /// Checks if string is int or double.
  static bool isNum(String value) {
    if (isNull(value)) {
      return false;
    }

    return num.tryParse(value) is num;
  }

  /// Checks if string consist only numeric.
  /// Numeric only doesn't accepting "." which double data type have
  static bool isNumericOnly(String s) => hasMatch(s, r'^\d+$');

  /// Checks if string consist only Alphabet. (No Whitespace)
  static bool isAlphabetOnly(String s) => hasMatch(s, r'^[a-zA-Z]+$');

  /// Checks if string contains at least one Capital Letter
  static bool hasCapitalletter(String s) => hasMatch(s, r'[A-Z]');

  /// Checks if string is boolean.
  static bool isBool(String value) {
    if (isNull(value)) {
      return false;
    }

    return (value == 'true' || value == 'false');
  }

  /// Checks if string is an video file.
  static bool isVideo(String filePath) {
    var ext = filePath.toLowerCase();

    return ext.endsWith(".mp4") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".wmv") ||
        ext.endsWith(".rmvb") ||
        ext.endsWith(".mpg") ||
        ext.endsWith(".mpeg") ||
        ext.endsWith(".3gp");
  }

  /// Checks if string is an image file.
  static bool isImage(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".bmp");
  }

  /// Checks if string is an audio file.
  static bool isAudio(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".mp3") ||
        ext.endsWith(".wav") ||
        ext.endsWith(".wma") ||
        ext.endsWith(".amr") ||
        ext.endsWith(".ogg");
  }

  /// Checks if string is an powerpoint file.
  static bool isPPT(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".ppt") || ext.endsWith(".pptx");
  }

  /// Checks if string is an word file.
  static bool isWord(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".doc") || ext.endsWith(".docx");
  }

  /// Checks if string is an excel file.
  static bool isExcel(String filePath) {
    final ext = filePath.toLowerCase();

    return ext.endsWith(".xls") || ext.endsWith(".xlsx");
  }

  /// Checks if string is an apk file.
  static bool isAPK(String filePath) {
    return filePath.toLowerCase().endsWith(".apk");
  }

  /// Checks if string is an pdf file.
  static bool isPDF(String filePath) {
    return filePath.toLowerCase().endsWith(".pdf");
  }

  /// Checks if string is an txt file.
  static bool isTxt(String filePath) {
    return filePath.toLowerCase().endsWith(".txt");
  }

  /// Checks if string is an chm file.
  static bool isChm(String filePath) {
    return filePath.toLowerCase().endsWith(".chm");
  }

  /// Checks if string is a vector file.
  static bool isVector(String filePath) {
    return filePath.toLowerCase().endsWith(".svg");
  }

  /// Checks if string is an html file.
  static bool isHTML(String filePath) {
    return filePath.toLowerCase().endsWith(".html");
  }

  /// Checks if string is a valid username.
  static bool isUsername(String s) =>
      hasMatch(s, r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Checks if string is URL.
  static bool isURL(String s) => hasMatch(s,
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  /// Checks if string is DateTime (UTC or Iso8601).
  static bool isDateTime(String s) =>
      hasMatch(s, r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  /// Checks if string is MD5 hash.
  static bool isMD5(String s) => hasMatch(s, r'^[a-f0-9]{32}$');

  /// Checks if string is SHA1 hash.
  static bool isSHA1(String s) =>
      hasMatch(s, r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

  /// Checks if string is SHA256 hash.
  static bool isSHA256(String s) =>
      hasMatch(s, r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

  /// Checks if string is SSN (Social Security Number).
  static bool isSSN(String s) => hasMatch(s,
      r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

  /// Checks if string is binary.
  static bool isBinary(String s) => hasMatch(s, r'^[0-1]+$');

  /// Checks if string is IPv4.
  static bool isIPv4(String s) =>
      hasMatch(s, r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// Checks if string is IPv6.
  static bool isIPv6(String s) => hasMatch(s,
      r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// Checks if string is hexadecimal.
  /// Example: HexColor => #12F
  static bool isHexadecimal(String s) =>
      hasMatch(s, r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  /// Checks if string is Palindrom.
  static bool isPalindrom(String string) {
    final cleanString = string
        .toLowerCase()
        .replaceAll(RegExp(r"\s+"), '')
        .replaceAll(RegExp(r"[^0-9a-zA-Z]+"), "");

    for (var i = 0; i < cleanString.length; i++) {
      if (cleanString[i] != cleanString[cleanString.length - i - 1]) {
        return false;
      }
    }

    return true;
  }

  /// Checks if all data have same value.
  /// Example: 111111 -> true, wwwww -> true, 1,1,1,1 -> true
  static bool isOneAKind(dynamic value) {
    if ((value is String || value is List) && !isNullOrBlank(value)!) {
      final first = value[0];
      final len = value.length as num;

      for (var i = 0; i < len; i++) {
        if (value[i] != first) {
          return false;
        }
      }

      return true;
    }

    if (value is int) {
      final stringValue = value.toString();
      final first = stringValue[0];

      for (var i = 0; i < stringValue.length; i++) {
        if (stringValue[i] != first) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  /// Checks if string is Passport No.
  static bool isPassport(String s) =>
      hasMatch(s, r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Checks if string is Currency.
  static bool isCurrency(String s) => hasMatch(s,
      r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R\$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

  /// Checks if length of data is GREATER than maxLength.
  static bool isLengthGreaterThan(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length > maxLength;
  }

  /// Checks if length of data is GREATER OR EQUAL to maxLength.
  static bool isLengthGreaterOrEqual(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length >= maxLength;
  }

  /// Checks if length of data is LOWER than maxLength.
  ///
  /// This method is deprecated, use [isLengthLessThan] instead
  @deprecated
  static bool isLengthLowerThan(dynamic value, int maxLength) =>
      isLengthLessThan(value, maxLength);

  /// Checks if length of data is LESS than maxLength.
  static bool isLengthLessThan(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);
    if (length == null) {
      return false;
    }

    return length < maxLength;
  }

  /// Checks if length of data is LOWER OR EQUAL to maxLength.
  ///
  /// This method is deprecated, use [isLengthLessOrEqual] instead
  @deprecated
  static bool isLengthLowerOrEqual(dynamic value, int maxLength) =>
      isLengthLessOrEqual(value, maxLength);

  /// Checks if length of data is LESS OR EQUAL to maxLength.
  static bool isLengthLessOrEqual(dynamic value, int maxLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length <= maxLength;
  }

  /// Checks if length of data is EQUAL to maxLength.
  static bool isLengthEqualTo(dynamic value, int otherLength) {
    final length = _obtainDynamicLength(value);

    if (length == null) {
      return false;
    }

    return length == otherLength;
  }

  /// Checks if length of data is BETWEEN minLength to maxLength.
  static bool isLengthBetween(dynamic value, int minLength, int maxLength) {
    if (isNull(value)) {
      return false;
    }

    return isLengthGreaterOrEqual(value, minLength) &&
        isLengthLessOrEqual(value, maxLength);
  }

  /// Checks if a contains b (Treating or interpreting upper- and lowercase
  /// letters as being the same).
  static bool isCaseInsensitiveContains(String a, String b) {
    return a.toLowerCase().contains(b.toLowerCase());
  }

  /// Checks if a contains b or b contains a (Treating or
  /// interpreting upper- and lowercase letters as being the same).
  static bool isCaseInsensitiveContainsAny(String a, String b) {
    final lowA = a.toLowerCase();
    final lowB = b.toLowerCase();

    return lowA.contains(lowB) || lowB.contains(lowA);
  }

  /// Checks if num a LOWER than num b.
  static bool isLowerThan(num a, num b) => a < b;

  /// Checks if num a GREATER than num b.
  static bool isGreaterThan(num a, num b) => a > b;

  /// Checks if num a EQUAL than num b.
  static bool isEqual(num a, num b) => a == b;

  //Check if num is a cnpj
  static bool isCnpj(String cnpj) {
    // Obter somente os números do CNPJ
    final numbers = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numbers.length != 14) {
      return false;
    }

    // Testar se todos os dígitos do CNPJ são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // Dividir dígitos
    final digits = numbers.split('').map(int.parse).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    var j = 0;
    for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digits[j++] * i;
    }
    calcDv1 %= 11;
    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digits[12] != dv1) {
      return false;
    }

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    j = 0;
    for (var i in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digits[j++] * i;
    }
    calcDv2 %= 11;
    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digits[13] != dv2) {
      return false;
    }

    return true;
  }

  /// Checks if the cpf is valid.
  static bool isCpf(String cpf) {
    // if (cpf == null) {
    //   return false;
    // }

    // get only the numbers
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    // Test if the CPF has 11 digits
    if (numbers.length != 11) {
      return false;
    }
    // Test if all CPF digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // split the digits
    final digits = numbers.split('').map(int.parse).toList();

    // Calculate the first verifier digit
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;

    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Tests the first verifier digit
    if (digits[9] != dv1) {
      return false;
    }

    // Calculate the second verifier digit
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;

    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second verifier digit
    if (digits[10] != dv2) {
      return false;
    }

    return true;
  }

  /// Capitalize each word inside string
  /// Example: your name => Your Name, your name => Your name
  static String? capitalize(String value) {
    if (isNull(value)) return null;
    if (isBlank(value)!) return value;
    return value.split(' ').map(capitalizeFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  static String? capitalizeFirst(String s) {
    if (isNull(s)) return null;
    if (isBlank(s)!) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Remove all whitespace inside string
  /// Example: your name => yourname
  static String removeAllWhitespace(String value) {
    return value.replaceAll(' ', '');
  }

  /// Camelcase string
  /// Example: your name => yourName
  static String? camelCase(String value) {
    if (isNullOrBlank(value)!) {
      return null;
    }

    final separatedWords =
    value.split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    var newString = '';

    for (final word in separatedWords) {
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    return newString[0].toLowerCase() + newString.substring(1);
  }

  /// credits to "ReCase" package.
  static final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  static final _symbolSet = {' ', '.', '/', '_', '\\', '-'};
  static List<String> _groupIntoWords(String text) {
    var sb = StringBuffer();
    var words = <String>[];
    var isAllCaps = text.toUpperCase() == text;

    for (var i = 0; i < text.length; i++) {
      var char = text[i];
      var nextChar = i + 1 == text.length ? null : text[i + 1];
      if (_symbolSet.contains(char)) {
        continue;
      }
      sb.write(char);
      var isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);
      if (isEndOfWord) {
        words.add('$sb');
        sb.clear();
      }
    }
    return words;
  }

  /// snake_case
  static String? snakeCase(String? text, {String separator = '_'}) {
    if (isNullOrBlank(text)!) {
      return null;
    }
    return _groupIntoWords(text!)
        .map((word) => word.toLowerCase())
        .join(separator);
  }

  /// param-case
  static String? paramCase(String? text) => snakeCase(text, separator: '-');

  /// Extract numeric value of string
  /// Example: OTP 12312 27/04/2020 => 1231227042020ß
  /// If firstword only is true, then the example return is "12312"
  /// (first found numeric word)
  static String numericOnly(String s, {bool firstWordOnly = false}) {
    var numericOnlyStr = '';

    for (var i = 0; i < s.length; i++) {
      if (isNumericOnly(s[i])) {
        numericOnlyStr += s[i];
      }
      if (firstWordOnly && numericOnlyStr.isNotEmpty && s[i] == " ") {
        break;
      }
    }

    return numericOnlyStr;
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  static String createPath(String path, [Iterable? segments]) {
    if (segments == null || segments.isEmpty) {
      return path;
    }
    final list = segments.map((e) => '/$e');
    return path + list.join();
  }
  
  
  
  static void getCsrtTokenWeb(String htmlWeb){
    var document = parse(htmlWeb);
    var inputElement = document.querySelector('[name="csrf_token"]')?.attributes['value'];
    print("csrf_token: $inputElement");
    getIt<UserSharePref>().saveCsrtToken(inputElement);
  }

  void back() async {
    NavigationService().back();
  }
  
}

typedef PrintFunctionCallback = void Function(
    String prefix,
    dynamic value,
    String info, {
    bool? isError,
    });
