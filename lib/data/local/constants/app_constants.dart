import 'package:intl/intl.dart';

class AppConstants {
  AppConstants._();
  static const appName = 'Report';

  static const genderCode = '001';
  static const typeOfAccidentCode = '002';
  static const adlCode = '003';
  static const trafficAccidentCode = '004';
  static const facialFeaturesCode = '005';
  static const incontinenceCode = '006';
  static const securingAirwayCode = '007';
  static const spinalCordMovementLimitationCode = '008';
  static const typeOfDetectionCode = '009';
  static const medicationCode = '010';
  static const jcsCode = '011';
  static const gcsECode = '012';
  static const gcsVCode = '013';
  static const gcsMCode = '014';
  static const descriptionOfObservationTimeCode = '015';
  static final dateFormat = DateFormat('yyyy/MM/dd');
  static final dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm');
  static final timeFormat = DateFormat.Hms();

  static const reportTemplatePath = 'assets/template/report.html';
}
