import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/routes.dart';

class MyApp extends StatelessWidget {
  final ReportStore _reportStore = getIt<ReportStore>();
  final TeamStore _teamStore = getIt<TeamStore>();
  final HospitalStore _hospitalStore = getIt<HospitalStore>();
  final FireStationStore _fireStationStore = getIt<FireStationStore>();
  final ClassificationStore _classificationStore = getIt<ClassificationStore>();
  final ZollSdkHostApi _hostApi = getIt<ZollSdkHostApi>();
  final ZollSdkStore _zollSdkStore = getIt<ZollSdkStore>();
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MultiProvider(
      providers: [
        Provider<ReportStore>(create: (_) => _reportStore),
        Provider<TeamStore>(create: (_) => _teamStore),
        Provider<HospitalStore>(create: (_) => _hospitalStore),
        Provider<FireStationStore>(create: (_) => _fireStationStore),
        Provider<ClassificationStore>(create: (_) => _classificationStore),
        Provider<ZollSdkHostApi>(create: (_) => _hostApi),
        Provider<ZollSdkStore>(create: (_) => _zollSdkStore),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: FlexThemeData.light(
          appBarBackground: Colors.white,
          scaffoldBackground: Colors.white,
          background: Colors.white,
          colors: const FlexSchemeColor(
            primary: Color(0xff0082C8),
            secondary: Color(0xff0082C8),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
                color: Color(0xff0082C8), fontWeight: FontWeight.bold),
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
        ),
        routes: Routes.routes,
        locale: const Locale('ja', 'JP'),
        supportedLocales: const [Locale('ja', 'JP')],
        localizationsDelegates: [
          // delegate from flutter_localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // delegate from localization package.
          LocalJsonLocalization.delegate,
        ],
        initialRoute: Routes.deletePreviousReport,
        navigatorObservers: [_routeObserver],
      ),
    );
  }
}
