// ignore_for_file: prefer_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../di/injection.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/system_utils.dart';
import '../../module/res/colors.dart';
import '../../module/res/text.dart';

class BaseScaffold extends StatelessWidget {
  final Function()? onBackPress;
  final String? title;
  final bool isAppBar;
  final String? subtitle;
  final Widget? body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool hideBackButton;
  final bool? isTitleCenter;
  final Widget? widgetCustomTitle;
  final double transparentStatusBar;
  final Color? statusBarColor;

  const BaseScaffold({
    Key? key,
    this.isAppBar = true,
    this.onBackPress,
    this.title,
    this.body,
    this.subtitle,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.actions,
    this.backgroundColor,
    this.hideBackButton = false,
    this.isTitleCenter = true,
    this.widgetCustomTitle = null,
    this.transparentStatusBar = 1.0,
    this.statusBarColor = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    void _onBackPress() {
      getIt<NavigationService>().back();
    }
    SystemUtils.setupStatusBar(transparentStatusBar, statusBarColor: statusBarColor);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: isAppBar
          ? AppBar(
              centerTitle: isTitleCenter,
              title: widgetCustomTitle == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title ?? '',
                            // style: Theme.of(context).appBarTheme.titleTextStyle,
                            style: TextStyle(
                              fontSize: text_16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: textTheme.bodyText2!.copyWith(
                              fontSize: text_14,
                              color: kCGrey136,
                            ),
                          )
                      ],
                    )
                  : widgetCustomTitle,
              leading: hideBackButton
                  ? null
                  : IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        color: kColorPrimary,
                      ),
                      onPressed: onBackPress ?? _onBackPress,
                    ),
              actions: actions,
              automaticallyImplyLeading: false,
            )
          : null,
      body: body,
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
