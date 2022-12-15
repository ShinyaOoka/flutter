import 'package:another_flushbar/flushbar.dart';
import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../view/widget_utils/anims/touchable_opacity.dart';
import '../res/colors.dart';
import '../res/style.dart';

enum SnackType {
  INFO,
  ERROR,
  SUCCESS,
  WARNING,
}

const _infoBackgroundColor = kColor007bff;
const _errorBackgrounColor = kColordc3545;
const _successBackgroundColor = kColor28a745;
const _warningBackgroundColor = kColorffac00;

class SnackBarUtil {
  late SnackType? snackType;
  String? title;
  String? message;

  Color get foregroundColor => Colors.white;

  Color get backgroundColor {
    switch (snackType) {
      case SnackType.INFO:
        return _infoBackgroundColor;

      case SnackType.ERROR:
        return _errorBackgrounColor;

      case SnackType.SUCCESS:
        return _successBackgroundColor;

      case SnackType.WARNING:
        return _warningBackgroundColor;

      default:
        throw UnimplementedError();
    }
  }

  IconData get iconData {
    switch (snackType) {
      case SnackType.INFO:
        return Icons.info_outline;

      case SnackType.ERROR:
        return Icons.cancel_outlined;

      case SnackType.SUCCESS:
        return Icons.done;

      case SnackType.WARNING:
        return Icons.warning_amber_rounded;

      default:
        throw UnimplementedError();
    }
  }
  static Flushbar? flush;
  static void showSnack({
    SnackType? snackType = SnackType.INFO,
    String? title,
    String? message,
  }) {
    dimiss();
   //late Flushbar flush;
    flush?.dismiss(true);
    flush = Flushbar<bool?>(
      borderRadius: BorderRadius.circular(size_4_r),
      titleText: Text(
        title ?? LocaleKeys.an_unexpected_error_has_occurred.tr(),
        style: TextStyle(
            color: Colors.black,
            fontSize: text_14,
            fontWeight: FontWeight.bold),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
      messageText: Text(
        message ?? LocaleKeys.an_unexpected_error_has_occurred.tr(),
        style: TextStyle(
            color: Colors.black45,
            fontSize: text_12,
            fontWeight: FontWeight.normal),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      shouldIconPulse: false,
      icon: _buildIcon(snackType!),
      mainButton: TouchableOpacity(
        onPressed: () {
          flush?.dismiss(true);
        },
        child: SvgPicture.asset(
          'assets/icons/ic_close_thin.svg',
          width: size_16_w,
          height: size_16_w,
          color: Colors.black54,
        ),
      ),
    )..show(getIt<NavigationService>().context).then((result) {});
  }

  static Icon _buildIcon(SnackType snackType) {
    double size = size_28_w;
    switch (snackType) {
      case SnackType.INFO:
        return Icon(Icons.info_outline,
            color: _infoBackgroundColor, size: size);

      case SnackType.ERROR:
        return Icon(Icons.cancel_outlined,
            color: _errorBackgrounColor, size: size);

      case SnackType.SUCCESS:
        return Icon(Icons.done, color: _successBackgroundColor, size: size);

      case SnackType.WARNING:
        return Icon(Icons.warning_amber_rounded,
            color: _warningBackgroundColor, size: size);

      default:
        throw UnimplementedError();
    }
  }

  static void dimiss() {
    ScaffoldMessenger.of(getIt<NavigationService>().context)
        .hideCurrentSnackBar();
  }
}
