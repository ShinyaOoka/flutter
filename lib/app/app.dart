import 'package:ak_azm_flutter/app/view/input_report/input_report_page.dart';
import 'package:ak_azm_flutter/app/view/list_report/list_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/flutter_easyloading/src/easy_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flavors.dart';
import 'di/injection.dart';
import 'module/common/navigator_screen.dart';
import 'module/common/system_utils.dart';
import 'module/res/themes.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SystemUtils.setPortraitScreenOrientation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        theme: theme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: F.title,
        debugShowCheckedModeBanner: false,
        home: ListReportPage(),
        //home: InputReportPage(),
        //home: SendReportPage(),
        builder: EasyLoading.init(),
        navigatorKey: getIt<NavigationService>().navigatorKey,
      ),
    );
  }
}
