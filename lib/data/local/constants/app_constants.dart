import 'package:intl/intl.dart';

class Era {
  final String name;
  final DateTime? start;
  final DateTime? end;

  const Era({required this.name, this.start, this.end});
}

class AppConstants {
  static const appName = 'Report';

  static const genderCode = '001';
  static const typeOfAccidentCode = '002';
  static const adlCode = '003';
  static const trafficAccidentCode = '004';
  static const facialFeaturesCode = '005';
  static const incontinenceCode = '006';
  static const securingAirwayCode = '007';
  static const limitationOfSpinalMotionCode = '008';
  static const typeOfDetectionCode = '009';
  static const medicationCode = '010';
  static const jcsCode = '011';
  static const gcsECode = '012';
  static const gcsVCode = '013';
  static const gcsMCode = '014';
  static const descriptionOfObservationTimeCode = '015';
  static const degreeCode = '016';
  static const positionOfReporterCode = '017';
  static final dateFormat = DateFormat('yyyy/MM/dd');
  static final dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
  static final timeFormat = DateFormat.Hms();

  static const reportCertificateTemplatePath =
      'assets/template/certificate.html';
  static const reportAmbulanceTemplatePath = 'assets/template/ambulance.html';

  static const lastEditedValueKey = 'lastEditedValue';
  static const lastEditedAtKey = 'lastEditedAt';
  static const doNotShowDeleteDialogAgainDate =
      'doNotShowDeleteDialogAgainDate';

  static const autoDeleteReportAfterDays = 5;

  static final eras = [
    Era(name: '明治', start: DateTime(1868, 9, 4), end: DateTime(1912, 7, 30)),
    Era(name: '大正', start: DateTime(1912, 7, 31), end: DateTime(1926, 12, 26)),
    Era(name: '昭和', start: DateTime(1926, 12, 27), end: DateTime(1989, 1, 7)),
    Era(name: '平成', start: DateTime(1989, 1, 8), end: DateTime(2019, 4, 30)),
    Era(name: '令和', start: DateTime(2019, 5, 1)),
  ];
}
