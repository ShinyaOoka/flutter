import 'package:ak_azm_flutter/app/module/common/extension.dart';
import 'package:ak_azm_flutter/app/module/repository/data_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../flavors.dart';
import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../view/error/error_page.dart';
import '../../view/preferences/preferences_page.dart';
import '../../view/splash/splash_page.dart';
import '../../view/widget_utils/dialog/dialog_general_two_action.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  int currentHomeIndex = -1;
  int allNotificationTabIndexFromPush = -1;
  int myPageGameTitileIdFromPush = -1;
  String myPageTypeFromPush = "player";

  BuildContext get context => navigatorKey.currentContext!;

  //replace with anim fade
  Future<dynamic>? pushReplacementScreenWithFade(Widget widget) {
    return navigatorKey.currentState?.pushReplacement(
      PageTransition(type: PageTransitionType.fade, child: widget),
    );
  }

  //replace with anim slide left in right out
  Future<dynamic>? pushReplacementScreenWithSlideLeftIn(Widget widget) {
    return navigatorKey.currentState?.pushReplacement(
      PageTransition(type: PageTransitionType.leftToRight, child: widget),
    );
  }

  //replace with anim slide left in right out
  Future<dynamic>? pushReplacementScreenWithSlideRightIn(Widget widget) {
    return navigatorKey.currentState?.pushReplacement(
      PageTransition(type: PageTransitionType.rightToLeft, child: widget),
    );
  }

  Future<dynamic>? pushEnterFadeExitDown(Widget widget) {
    return navigatorKey.currentState?.push(
      PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (animation.status == AnimationStatus.reverse) {
          //do your dismiss animation here
          return SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child);
        } else {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }
      }, pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
        return widget;
      }),
    );
  }

  //push with anim fade
  Future<dynamic>? pushScreenWithFade(Widget widget) {
    return navigatorKey.currentState?.push(
      PageTransition(type: PageTransitionType.fade, child: widget),
    );
  }

  //push with anim slide up
  Future<dynamic>? pushScreenWithSlideUp(Widget widget) {
    return navigatorKey.currentState?.push(
      PageTransition(type: PageTransitionType.bottomToTop, child: widget),
    );
  }

  //clear all page and push new page
  Future<dynamic>? pushAndRemoveUntilWithFade(Widget widget) {
    return navigatorKey.currentState?.pushAndRemoveUntil(
      PageTransition(type: PageTransitionType.fade, child: widget),
      (route) => false,
    );
  }

  //push with anim fade
  Future<dynamic>? pushScreenWithSlideLeftRight(Widget widget) {
    return navigatorKey.currentState?.push(
      PageTransition(type: PageTransitionType.rightToLeft, child: widget),
    );
  }

  //push no anim
  Future<dynamic>? pushScreenNoAnim(Widget widget) {
    return navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  refreshApp() {
    pushAndRemoveUntilWithFade(SplashPage());
  }

  openErrorPage({String? title, String? message}) {
    pushAndRemoveUntilWithFade(ErrorPage(
      title: title,
      message: message,
    ));
  }

  back() {
    navigatorKey.currentState?.pop();
  }

  void signOut() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return DialogGeneralTwoAction(
            title: F.title,
            message: LocaleKeys.do_you_want_to_log_out.tr(),
            textOk: LocaleKeys.log_out.tr(),
            onOkClick: () {
              getIt<DataRepository>().logout();
            },
          );
        });
  }

  openPreferencesPage() async {
    removeFocus(navigatorKey.currentContext!);
    pushScreenWithFade(PreferencesPage());
  }

  dimiss() {
    navigatorKey.currentState?.pop();
  }
}
