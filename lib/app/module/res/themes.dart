import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'text.dart';

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
);

class LightTheme {
  Color colorPrimary = const Color(0xFF599CF7);
  Color colorStatusBar = Colors.black;
  Color? colorBackground = Colors.grey[50]; //color default of scaffold
  Color colorPrimaryDark = const Color(0xFF217CFF);
  Color colorAccent = const Color(0xFF599CF7);
  Color colorSearchBar = Colors.white;
}

class DarkTheme {
  Color colorPrimary = const Color(0xFF665EFF);
  Color colorPrimaryDark = const Color(0xFF363279);
  Color colorStatusBar = const Color(0xFF181B2D);
  Color colorBackground = const Color(0xFF181B2D);
  Color colorAccent = const Color(0xFF599CF7);
  Color colorFF2A2E43 = const Color(0xFF2A2E43);
  Color colorFF454F63 = const Color(0xFF454F63);
  Color colorSearchBar = const Color(0xFF2A2E43);
  Color colorFFE6E8EB = const Color(0xFFE6E8EB);
  Color colorFF393E46 = const Color(0xFF464C5E);
  Color colorFF3E455C = const Color(0xFF3E455C);
}

