import 'dart:convert';
import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/report_type.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:localization/localization.dart';
import 'package:collection/collection.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:share_plus/share_plus.dart';

class PreviewReportScreenArguments {
  ReportType reportType;
  PreviewReportScreenArguments({required this.reportType});
}

class PreviewReportScreen extends StatefulWidget {
  const PreviewReportScreen({super.key});

  @override
  _PreviewReportScreenState createState() => _PreviewReportScreenState();
}

class _PreviewReportScreenState extends State<PreviewReportScreen> {
  late ReportStore _reportStore;
  late ClassificationStore _classificationStore;
  late ReportType reportType;

  File? _file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments
        as PreviewReportScreenArguments;
    reportType = args.reportType;

    _reportStore = context.read();
    _classificationStore = context.read();

    final file = await generatePdf();
    setState(() {
      _file = file;
    });
  }

  Future<File?> generatePdf() async {
    Directory tempDir = await getTemporaryDirectory();
    if (reportType == ReportType.certificate) {
      String reportTemplate = await rootBundle
          .loadString(AppConstants.reportCertificateTemplatePath);
      String filledReport = fillCertificateData(reportTemplate);
      final image = await rootBundle.load('assets/img/human_body.png');
      final imageData = base64.encode(image.buffer.asUint8List());
      filledReport = filledReport.replaceAll('IMAGE_PLACEHOLDER', imageData);
      return await FlutterHtmlToPdf.convertFromHtmlContent(
          filledReport, tempDir.path, getReportName());
    } else if (reportType == ReportType.ambulance) {
      String reportTemplate =
          await rootBundle.loadString(AppConstants.reportAmbulanceTemplatePath);
      String filledReport = fillAmbulanceData(reportTemplate);
      return await FlutterHtmlToPdf.convertFromHtmlContent(
          filledReport, tempDir.path, getReportName());
    } else {
      assert(false);
    }
    return null;
  }

  String fillAmbulanceData(String template) {
    String result = template;
    Report report = _reportStore.selectingReport!;
    result = addCss(result);
    result = result.replaceAll('□', '<span class="square"></span>');

    result = result.replaceAll('height:30.0pt', 'height:26pt');
    result = result.replaceAll('.5pt', '0.5pt');
    result = result.replaceAll('padding:0px;', 'padding:0 3pt;');
    // Remove default margin from page
    result = result.replaceAll('margin:.75in .7in .75in .7in', 'margin:0');
    result = result.replaceAll(
        'TypeOfAccident_VALUE', report.accidentType?.value ?? '');
    result = result.replaceAll('PlaceOfIncident_VALUE',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.placeOfIncident, 3, 26) ?? ''}</div>');
    result = result.replaceAll('TeamCaptainName_VALUE',
        report.teamCaptainName?.characters.take(15).toString() ?? '');
    result = result.replaceAll('SickInjuredPersonAddress_VALUE',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.sickInjuredPersonAddress, 4, 22) ?? ''}</div>');
    result = result.replaceAll('SickInjuredPersonName_VALUE',
        report.sickInjuredPersonName?.characters.take(17).string ?? '');
    result = result.replaceAll('SickInjuredPersonKANA_VALUE',
        report.sickInjuredPersonKana?.characters.take(17).string ?? '');
    result = result.replaceAll(
        'SickInjuredPersonGender_VALUE', report.gender?.value ?? '');
    result = result.replaceAll('SickInjuredPersonAge_VALUE',
        report.sickInjuredPersonAge?.toString() ?? '');
    result = result.replaceAll('SickInjuredPersonTEL_VALUE',
        report.sickInjuredPersonTel?.toString() ?? '');
    result = fillTime(result, 'SenseTime', report.senseTime);
    result = fillTime(result, 'On-siteArrivalTime', report.onSiteArrivalTime);
    result =
        fillTime(result, 'HospitalArrivalTime', report.hospitalArrivalTime);
    result = fillDate(result, 'SickInjuredPersonBirthDate',
        report.sickInjuredPersonBirthDate);
    result = fillDate(result, 'DateOfOccurrence', report.dateOfOccurrence);
    for (int i = 0; i < 3; i++) {
      result =
          fillTime(result, 'ObservationTime_$i', report.observationTime?[i]);
      result =
          result.replaceAll('JCS_${i}_VALUE', report.jcsTypes[i]?.value ?? '');
      result = result.replaceAll(
          'Respiration_${i}_VALUE', report.respiration?[i]?.toString() ?? '');
      result = result.replaceAll(
          'Pulse_${i}_VALUE', report.pulse?[i]?.toString() ?? '');
      result = result.replaceAll('BloodPressure_High_${i}_VALUE',
          report.bloodPressureHigh?[i]?.toString() ?? '');
      result = result.replaceAll('BloodPressure_Low_${i}_VALUE',
          report.bloodPressureLow?[i]?.toString() ?? '');
      result = result.replaceAll(
          'SpO2Percent_${i}_VALUE', report.spO2Percent?[i]?.toString() ?? '');
      result = result.replaceAll('BodyTemperature_${i}_VALUE',
          report.bodyTemperature?[i]?.toStringAsFixed(1) ?? '');
    }
    return result;
  }

  String fillClassificationCheck(String template, String key,
      List<Classification> values, String? checked) {
    for (final value in values) {
      template = fillCheck(
          template,
          '${key}_CHECK_${value.classificationSubCd}',
          value.classificationSubCd == checked);
    }
    return template;
  }

  String fillClassificationCircle(String template, String key,
      List<Classification> values, String? checked) {
    for (final value in values) {
      template = fillCircle(
          template,
          '${key}_CIRCLE_${value.classificationSubCd}',
          value.value ?? '',
          value.classificationSubCd == checked);
    }
    return template;
  }

  String fillCircle(String template, String key, String text, bool checked) {
    if (checked) {
      template =
          template.replaceFirst(key, '<span class="text-circle">$text</span>');
    } else {
      template = template.replaceFirst(key, text);
    }
    return template;
  }

  String fillCheck(String template, String key, bool checked) {
    if (checked) {
      template = template.replaceFirst(key,
          '<span class="square-black"><span class="tick"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path stroke="blue" fill="blue" d="M20.285 2l-11.285 11.567-5.286-5.011-3.714 3.716 9 8.728 15-15.285z"/></svg></span></span>');
    } else {
      template = template.replaceFirst(key, '<span class="square"></span>');
    }
    return template;
  }

  String fillBoolCheck(String template, String key, bool? value,
      {fillFalse = false}) {
    template = fillCheck(template, '${key}_CHECK_TRUE', value != null && value);
    if (fillFalse) {
      template =
          fillCheck(template, '${key}_CHECK_FALSE', value == null || !value);
    } else {
      template = fillCheck(template, '${key}_CHECK_FALSE', false);
    }
    return template;
  }

  String fillBoolCircle(String template, String key, bool? value) {
    if (value == true) {
      template = template.replaceFirst(
          '${key}_CIRCLE_TRUE', '<span class="text-circle">有</span>');
      template = template.replaceFirst('${key}_CIRCLE_FALSE', '無');
    } else if (value == false) {
      template = template.replaceFirst('${key}_CIRCLE_TRUE', '有');
      template = template.replaceFirst(
          '${key}_CIRCLE_FALSE', '<span class="text-circle">無</span>');
    } else {
      template = template.replaceFirst('${key}_CIRCLE_TRUE', '有');
      template = template.replaceFirst('${key}_CIRCLE_FALSE', '無');
    }
    return template;
  }

  String fillTime(String template, String key, TimeOfDay? time) {
    template = template.replaceAll('${key}_H', time?.hour.toString() ?? '--');
    template = template.replaceAll('${key}_M', time?.minute.toString() ?? '--');
    return template;
  }

  String fillDate(String template, String key, DateTime? date) {
    if (date != null) {
      template = template.replaceAll(
          '${key}_GGYY', yearToWareki(date.year, date.month, date.day));
    } else {
      template = template.replaceAll('${key}_GGYY', "　　　");
    }
    template = template.replaceAll('${key}_MM', date?.month.toString() ?? '　');
    template = template.replaceAll('${key}_DD', date?.day.toString() ?? '　');
    template =
        template.replaceAll('${key}_DW', weekdayToJapanese(date?.weekday));
    return template;
  }

  String? limitNumberOfChars(String? input, int row, int col) {
    if (input == null) return null;
    int currentRow = 1;
    int currentCol = 1;
    List<String> chars = [];
    for (final x in input.split('')) {
      if (currentRow > row) {
        break;
      } else if (x == '\n') {
        currentCol = 1;
        currentRow += 1;
        chars.add(x);
        if (currentRow > row) {
          break;
        }
        continue;
      } else if (currentCol > col) {
        currentCol = 1;
        currentRow += 1;
        chars.add('\n');
        if (currentRow > row) {
          break;
        }
      }
      chars.add(x);
      currentCol += 1;
    }
    return chars.join('');
  }

  String weekdayToJapanese(int? weekday) {
    if (weekday == null) return '　　';
    switch (weekday) {
      case 1:
        return '月';
      case 2:
        return '火';
      case 3:
        return '水';
      case 4:
        return '木';
      case 5:
        return '金';
      case 6:
        return '土';
      case 7:
        return '日';
    }
    return '　　';
  }

  String fillToday(String template, {DateTime? date}) {
    if (date == null) {
      template = template.replaceAll('GGYY', "　　　　");
      template = template.replaceAll('MM', "　　");
      template = template.replaceAll('DD', "　　");
    } else {
      template = template.replaceAll(
          'GGYY', yearToWareki(date.year, date.month, date.day));
      template = template.replaceAll('MM', date.month.toString());
      template = template.replaceAll('DD', date.day.toString());
    }
    return template;
  }

  String yearToWareki(int year, int month, int day) {
    DateTime date = DateTime(year, month, day);

    for (final era in AppConstants.eras) {
      if (era.start != null && era.start!.isAfter(date)) continue;
      if (era.end != null && era.end!.isBefore(date)) continue;
      return '${era.name}　${date.year - era.start!.year + 1}';
    }

    return "エラー";
  }

  String customReplace(
      String text, String searchText, int replaceOn, String replaceText) {
    Match result = searchText.allMatches(text).elementAt(replaceOn - 1);
    return text.replaceRange(result.start, result.end, replaceText);
  }

  DateTime? stringToDateTime(String? stringDate,
      {String format = 'yyyy/MM/dd'}) {
    return stringDate == null || stringDate.isEmpty
        ? null
        : DateFormat(format).parse(stringDate);
  }

  List<String> split4CharPhone(String text) {
    if (text.isEmpty) return ['', '', ''];
    var tempText = text.split('').reversed.join('');
    var buffer = StringBuffer();
    for (int i = 0; i < tempText.length; i++) {
      buffer.write(tempText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 &&
          nonZeroIndex != tempText.length &&
          nonZeroIndex < 9) {
        buffer.write(' ');
      }
    }
    List<String> tempTELs = buffer.toString().split(' ');
    //if list = 1 add middle & first
    if (tempTELs.length < 2) {
      tempTELs.add('');
      tempTELs.add('');
    }
    //if list = 2 add  first
    if (tempTELs.length < 3) {
      tempTELs.add('');
    }
    //revert list
    tempTELs = tempTELs.reversed.toList();
    //revert string in element of list
    return tempTELs.map((e) => e.split('').reversed.join('')).toList();
  }

  String addCss(String template) {
    String extraCss = '''
      .square {
          display: inline-block;
          width: 12px;
          height: 12px;
          margin-left: 2px;
          margin-right: 2px;
          border: 1px black solid;
          vertical-align: middle;
          margin-bottom: 4px;
      }

      .square-black {
          display: inline-block;
          width: 12px;
          height: 12px;
          margin-left: 2px;
          margin-right: 2px;
          border: 1px black solid;
          vertical-align: middle;
          margin-bottom: 4px;
          position: relative;
          color: #0000ff;
      }

      .square-black .tick {
          position: absolute;
          top: 0;
          left: 0;
          transform: translate(0px, -4px);
          color: #0000ff;
      }

      .text-circle {
          border-radius: 100%;
          padding: 2px;
          background: #fff;
          border: 1px solid #00f;
          text-align: center
      }
      ''';
    return template.replaceAll('</style>', '$extraCss</style>');
  }

  String fillCertificateData(String template) {
    String result = template;
    Report report = _reportStore.selectingReport!;

    result = addCss(result);
    result = result.replaceAll('□', '<span class="square"></span>');

    result = result.replaceAll('height:20.5pt', 'height:19pt');
    result = result.replaceAll('.5pt', '0.5pt');
    result = result.replaceAll('padding:0px;', 'padding:0 3pt;');

    result = result.replaceFirst('TeamCaptainName',
        report.teamCaptainName?.characters.take(11).toString() ?? '');

    final now = DateTime.now();
    var m = DateFormat.M().format(now).replaceFirst('月', '');
    var d = DateFormat.d().format(now).replaceFirst('日', '');
    result = result
        .replaceFirst('YYYY', yearToWareki(now.year, now.month, now.day))
        .replaceFirst('MM', m)
        .replaceFirst('DD', d);

    result = result.replaceFirst('SickInjuredPersonAddress',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.sickInjuredPersonAddress, 3, 20) ?? ''}</div>');
    result = fillClassificationCheck(
        result,
        'Gender',
        getClassifications(AppConstants.genderCode),
        report.gender?.classificationSubCd);
    result = result.replaceFirst(
        'SickInjuredPersonBirthDateYear',
        report.sickInjuredPersonBirthDate?.year != null
            ? yearToWareki(
                report.sickInjuredPersonBirthDate!.year,
                report.sickInjuredPersonBirthDate!.month,
                report.sickInjuredPersonBirthDate!.day)
            : '　');
    result = result.replaceFirst(
        'SickInjuredPersonBirthDateMonth',
        report.sickInjuredPersonBirthDate?.month != null
            ? report.sickInjuredPersonBirthDate!.month.toString()
            : '　');
    result = result.replaceFirst(
        'SickInjuredPersonBirthDateDay',
        report.sickInjuredPersonBirthDate?.day != null
            ? report.sickInjuredPersonBirthDate!.day.toString()
            : '　');
    int? age;
    if (report.dateOfOccurrence != null &&
        report.sickInjuredPersonBirthDate != null) {
      age = Jiffy(report.dateOfOccurrence)
          .diff(report.sickInjuredPersonBirthDate, Units.YEAR)
          .toInt();
    }
    result = result.replaceFirst(
        'SickInjuredPersonAge', age != null ? age.toString() : '');
    result = result.replaceFirst(
        'SickInjuredPersonKANA', report.sickInjuredPersonKana ?? '');
    result = result.replaceFirst(
        'SickInjuredPersonName', report.sickInjuredPersonName ?? '');
    result = result.replaceFirst(
        'SickInjuredPersonTEL', report.sickInjuredPersonTel ?? '');
    result = fillBoolCheck(result, 'SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory?.isNotEmpty,
        fillFalse: true);
    result = result.replaceFirst('SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory ?? '');
    result = result.replaceFirst('SickInjuredPersonHistoryHospital',
        report.sickInjuredPersonHistoryHospital ?? '');

    result = fillClassificationCheck(
        result,
        'TypeOfAccident',
        getClassifications(AppConstants.typeOfAccidentCode),
        report.accidentType?.classificationSubCd);
    if (report.accidentType?.classificationSubCd != '009' &&
        report.accidentType?.classificationSubCd != '003' &&
        report.accidentType?.classificationSubCd != '006' &&
        report.accidentType?.classificationSubCd != '004' &&
        report.accidentType?.classificationSubCd != '008' &&
        report.accidentType?.classificationSubCd != '005' &&
        report.accidentType?.classificationSubCd != null &&
        report.accidentType?.classificationSubCd != '') {
      result = fillCheck(result, 'TypeOfAccident_CHECK_OTHER', true);
      if (report.accidentType?.classificationSubCd != '010' &&
          report.accidentType?.classificationSubCd != '099') {
        result = result.replaceFirst(
            'TypeOfAccident_VALUE', report.accidentType?.value ?? '');
      } else {
        result = result.replaceFirst('TypeOfAccident_VALUE', '');
      }
    } else {
      result = fillCheck(result, 'TypeOfAccident_CHECK_OTHER', false);
      result = result.replaceFirst('TypeOfAccident_VALUE', '');
    }
    result = result.replaceFirst(
        'DateOfOccurrenceYear',
        report.dateOfOccurrence?.year != null
            ? yearToWareki(report.dateOfOccurrence!.year,
                report.dateOfOccurrence!.month, report.dateOfOccurrence!.day)
            : '');
    result = result.replaceFirst(
        'DateOfOccurrenceMonth',
        report.dateOfOccurrence?.month != null
            ? report.dateOfOccurrence!.month.toString()
            : '');
    result = result.replaceFirst(
        'DateOfOccurrenceDay',
        report.dateOfOccurrence?.day != null
            ? report.dateOfOccurrence!.day.toString()
            : '');
    result = result.replaceFirst(
        'TimeOfOccurrenceHour',
        report.timeOfOccurrence?.hour != null
            ? report.timeOfOccurrence!.hour.toString()
            : '');
    result = result.replaceFirst(
        'TimeOfOccurrenceMinute',
        report.timeOfOccurrence?.minute != null
            ? report.timeOfOccurrence!.minute.toString()
            : '');
    result = result.replaceFirst('PlaceOfIncident',
        '<div style="white-space: pre-wrap;">${report.placeOfIncident?.replaceAll("\n", ' ').characters.take(35).toString() ?? ''}</div>');
    result = result.replaceFirst('AccidentSummary',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.accidentSummary, 8, 23) ?? ''}</div>');
    if (report.senseTime != null) {
      result = result.replaceFirst('SenseTime',
          '${report.senseTime!.hour.toString().padLeft(2, '0')}:${report.senseTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('SenseTime', '');
    }
    if (report.onSiteArrivalTime != null) {
      result = result.replaceFirst('On-siteArrivalTime',
          '${report.onSiteArrivalTime!.hour.toString().padLeft(2, '0')}:${report.onSiteArrivalTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('On-siteArrivalTime', '');
    }
    if (report.contactTime != null) {
      result = result.replaceFirst('ContactTime',
          '${report.contactTime!.hour.toString().padLeft(2, '0')}:${report.contactTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('ContactTime', '');
    }
    if (report.inVehicleTime != null) {
      result = result.replaceFirst('In-vehicleTime',
          '${report.inVehicleTime!.hour.toString().padLeft(2, '0')}:${report.inVehicleTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('In-vehicleTime', '');
    }
    if (report.startOfTransportTime != null) {
      result = result.replaceFirst('StartOfTransportTime',
          '${report.startOfTransportTime!.hour.toString().padLeft(2, '0')}:${report.startOfTransportTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('StartOfTransportTime', '');
    }
    if (report.hospitalArrivalTime != null) {
      result = result.replaceFirst('HospitalArrivalTime',
          '${report.hospitalArrivalTime!.hour.toString().padLeft(2, '0')}:${report.hospitalArrivalTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('HospitalArrivalTime', '');
    }
    result = fillBoolCheck(result, 'FamilyContact', report.familyContact,
        fillFalse: report.familyContact != null);

    for (int i = 0; i < 3; i++) {
      if (report.observationTime?[i] != null) {
        result = result.replaceFirst('ObservationTime${i + 1}',
            '${report.observationTime?[i]?.hour.toString().padLeft(2, '0')}:${report.observationTime?[i]?.minute.toString().padLeft(2, '0')}');
      } else {
        result = result.replaceFirst('ObservationTime${i + 1}', '');
      }
      result =
          result.replaceFirst('JCS${i + 1}', report.jcsTypes[i]?.value ?? '');
      if (report.gcsVTypes[i]?.value == null) {
        result = result.replaceFirst('VGCS_V${i + 1}', '');
      } else {
        result = result.replaceFirst(
            'GCS_V${i + 1}', report.gcsVTypes[i]?.value ?? '');
      }
      if (report.gcsMTypes[i]?.value == null) {
        result = result.replaceFirst('MGCS_M${i + 1}', '');
      } else {
        result = result.replaceFirst(
            'GCS_M${i + 1}', report.gcsMTypes[i]?.value ?? '');
      }

      result = result.replaceFirst(
          'Respiration${i + 1}',
          report.respiration?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.respiration![i].toString()
              : '');
      result = result.replaceFirst(
          'Pulse${i + 1}',
          report.pulse?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pulse![i].toString()
              : '');
      result = result.replaceFirst(
          'BloodPressure_High${i + 1}',
          report.bloodPressureHigh?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.bloodPressureHigh![i].toString()
              : '');
      result = result.replaceFirst(
          'BloodPressure_Low${i + 1}',
          report.bloodPressureLow?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.bloodPressureLow![i].toString()
              : '');
      result = result.replaceFirst(
          'SpO2Percent${i + 1}',
          report.spO2Percent?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.spO2Percent![i].toString()
              : '');
      result = result.replaceFirst(
          'PupilRight${i + 1}',
          report.pupilRight?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pupilRight![i].toString()
              : '');
      result = result.replaceFirst(
          'PupilLeft${i + 1}',
          report.pupilLeft?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pupilLeft![i].toString()
              : '');

      result = result.replaceFirst('BodyTemperature${i + 1}',
          report.bodyTemperature?[i]?.toString() ?? '');

      result = fillCircle(result, 'FacialFeatures_${i}_CIRCLE_005', "苦悶",
          report.facialFeaturesAnguish?[i] == true);
    }
    return result;
  }

  List<Classification> getClassifications(String code) {
    return _classificationStore.classifications.values
        .where((e) => e.classificationCd == code)
        .toList();
  }

  String fillCertificateDataOld(String htmlInput) {
    final Report report = _reportStore.selectingReport!;
    const uncheckIcon = '<span class="square"></span>';
    const checkIcon = '<span class="square-black"></span>';
    const String styleCSSMore =
        '.square {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid; vertical-align: middle; margin-bottom: 4px;}.square-black {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid;background: black;vertical-align: middle; margin-bottom: 4px;}.text-circle {border-radius: 100%;padding: 2px;background: #fff;border: 1px solid #000;text-align: center}';
    const overflow = ';overflow: hidden;';
    const overflowStyle = 'style=\'overflow: hidden\'';

    var totalYesPos = 0;
    var totalNoPos = 0;

    const uncheckYes = '$uncheckIcon有';
    const checkedYes = '$checkIcon有';
    const uncheckNo = '$uncheckIcon無';
    const checkedNo = '$checkIcon無';

    //replace □ => uncheckIcon style
    htmlInput = htmlInput.replaceAll('□', uncheckIcon);

    htmlInput = htmlInput.replaceAll('height:20.5pt', 'height:19pt');

    //increment border-width style: .5pt - 0.5pt
    htmlInput = htmlInput.replaceAll('.5pt', '0.5pt');
    htmlInput = htmlInput.replaceAll('padding:0px;', 'padding:0 3pt;');

    //add style
    htmlInput = htmlInput.replaceAll('</style>', '$styleCSSMore</style>');

    //add overflow hide in TeamName, TeamCaptainName, Other
    htmlInput = htmlInput.replaceFirst('\'>TeamName', '$overflow\'>TeamName');
    htmlInput = htmlInput.replaceFirst(
        '\'>TeamCaptainName', '$overflow\'>TeamCaptainName');
    htmlInput = htmlInput.replaceFirst('>Other', '$overflowStyle>Other');

    //fill yyyy mm dd now
    final now = DateTime.now();
    var y = DateFormat.y().format(now).replaceFirst('年', '');
    var m = DateFormat.M().format(now).replaceFirst('月', '');
    var d = DateFormat.d().format(now).replaceFirst('日', '');
    //1
    htmlInput = htmlInput
        .replaceFirst('YYYY', yearToWareki(now.year, now.month, now.day))
        .replaceFirst('MM', m)
        .replaceFirst('DD', d);

    //3
    htmlInput = htmlInput.replaceFirst('TeamCaptainName',
        report.teamCaptainName?.characters.take(11).toString() ?? '');
    //7
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonAddress',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.sickInjuredPersonAddress, 3, 20) ?? ''}</div>');
    //8
    if (report.sickInjuredPersonGender == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　男', '$checkIcon　男');
    } else if (report.sickInjuredPersonGender == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　女', '$checkIcon　女');
    }

    //9
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonBirthDateYear',
        report.sickInjuredPersonBirthDate?.year != null
            ? yearToWareki(
                report.sickInjuredPersonBirthDate!.year,
                report.sickInjuredPersonBirthDate!.month,
                report.sickInjuredPersonBirthDate!.day)
            : '');
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonBirthDateMonth',
        report.sickInjuredPersonBirthDate?.month != null
            ? report.sickInjuredPersonBirthDate!.month.toString()
            : '');
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonBirthDateDay',
        report.sickInjuredPersonBirthDate?.day != null
            ? report.sickInjuredPersonBirthDate!.day.toString()
            : '');

    //10
    int? age;
    if (report.dateOfOccurrence != null &&
        report.sickInjuredPersonBirthDate != null) {
      age = Jiffy(report.dateOfOccurrence)
          .diff(report.sickInjuredPersonBirthDate, Units.YEAR)
          .toInt();
    }
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAge', age != null ? age.toString() : '');

    //11
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonKANA', report.sickInjuredPersonKana ?? '');

    //12
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonName', report.sickInjuredPersonName ?? '');

    //13
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTEL', report.sickInjuredPersonTel ?? '');
    List<String?> SickInjuredPersonTELs =
        split4CharPhone(report.sickInjuredPersonTel?.toString().trim() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELFirst',
        SickInjuredPersonTELs[0]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELMiddle',
        SickInjuredPersonTELs[1]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTELLast', SickInjuredPersonTELs[2]?.toString() ?? '');

    //15
    if (report.sickInjuredPersonMedicalHistory == null ||
        report.sickInjuredPersonMedicalHistory == '') {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 3 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 3 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 3 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 3 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //16
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory ?? '');

    //17
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonHistoryHospital',
        report.sickInjuredPersonHistoryHospital ?? '');

    //24
    htmlInput = htmlInput.replaceFirst('$uncheckIcon急病', '$uncheckIcon 急病');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon交通', '$uncheckIcon 交通');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon一般', '$uncheckIcon 一般');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon労災', '$uncheckIcon 労災');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon自損', '$uncheckIcon 自損');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon運動', '$uncheckIcon 運動');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon転院', '$uncheckIcon 転院');
    htmlInput = htmlInput.replaceFirst('$uncheckIconその他', '$uncheckIcon その他');

    if (report.typeOfAccident == '009') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 急病', '$checkIcon 急病');
    } else if (report.typeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 交通', '$checkIcon 交通');
    } else if (report.typeOfAccident == '006') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 一般', '$checkIcon 一般');
    } else if (report.typeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 労災', '$checkIcon 労災');
    } else if (report.typeOfAccident == '008') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 自損', '$checkIcon 自損');
    } else if (report.typeOfAccident == '005') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 運動', '$checkIcon 運動');
    } else if (report.typeOfAccident == '010') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon その他', '$checkIcon その他');
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 転院', '$checkIcon 転院');
    } else if (report.typeOfAccident == '099') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon その他', '$checkIcon その他');
    } else if (report.typeOfAccident != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon その他', '$checkIcon その他');
      htmlInput = htmlInput.replaceFirst(
          'TypeOfAccident_VALUE', report.accidentType!.value!);
    }
    htmlInput = htmlInput.replaceFirst('TypeOfAccident_VALUE', '');

    //25
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceYear',
        report.dateOfOccurrence?.year != null
            ? yearToWareki(report.dateOfOccurrence!.year,
                report.dateOfOccurrence!.month, report.dateOfOccurrence!.day)
            : '');
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceMonth',
        report.dateOfOccurrence?.month != null
            ? report.dateOfOccurrence!.month.toString()
            : '');
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceDay',
        report.dateOfOccurrence?.day != null
            ? report.dateOfOccurrence!.day.toString()
            : '');
    htmlInput = htmlInput.replaceFirst(
        'TimeOfOccurrenceHour',
        report.timeOfOccurrence?.hour != null
            ? report.timeOfOccurrence!.hour.toString()
            : '');
    htmlInput = htmlInput.replaceFirst(
        'TimeOfOccurrenceMinute',
        report.timeOfOccurrence?.minute != null
            ? report.timeOfOccurrence!.minute.toString()
            : '');

    //26
    htmlInput = htmlInput.replaceFirst('PlaceOfIncident',
        '<div style="white-space: pre-wrap;">${report.placeOfIncident?.replaceAll("\n", ' ').characters.take(35).toString() ?? ''}</div>');

    //27
    htmlInput = htmlInput.replaceFirst('AccidentSummary',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.accidentSummary, 8, 23) ?? ''}</div>');

    //28
    htmlInput = htmlInput.replaceFirst('$uncheckIcon自立', '$uncheckIcon自立');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon全介助', '$uncheckIcon全介助');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon部分介助', '$uncheckIcon部分介助');
    //29
    htmlInput = htmlInput.replaceFirst('SenseTime',
        '${report.senseTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.senseTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //32
    htmlInput = htmlInput.replaceFirst('On-siteArrivalTime',
        '${report.onSiteArrivalTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.onSiteArrivalTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //33
    htmlInput = htmlInput.replaceFirst('ContactTime',
        '${report.contactTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.contactTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //34
    htmlInput = htmlInput.replaceFirst('In-vehicleTime',
        '${report.inVehicleTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.inVehicleTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //35
    htmlInput = htmlInput.replaceFirst('StartOfTransportTime',
        '${report.startOfTransportTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.startOfTransportTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //36
    htmlInput = htmlInput.replaceFirst('HospitalArrivalTime',
        '${report.hospitalArrivalTime?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.hospitalArrivalTime?.minute.toString().padLeft(2, '0') ?? '　　'}');
    //37
    if (report.familyContact == true) {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 7 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 7 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.familyContact == false) {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 7 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 7 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //39
    htmlInput =
        htmlInput.replaceFirst('$uncheckIconシートベルト', '$uncheckIcon シートベルト');
    htmlInput =
        htmlInput.replaceFirst('$uncheckIconエアバック', '$uncheckIcon エアバック');
    htmlInput =
        htmlInput.replaceFirst('$uncheckIconチャイルドシート', '$uncheckIcon チャイルドシート');
    htmlInput = htmlInput.replaceFirst('$uncheckIcon不明', '$uncheckIcon 不明');
    htmlInput =
        htmlInput.replaceFirst('$uncheckIconヘルメット', '$uncheckIcon ヘルメット');

    //43-61
    htmlInput = handleDatLayout578(htmlInput);

    return htmlInput;
  }

  String handleDatLayout578(String htmlInput) {
    final Report report = _reportStore.selectingReport!;
    var totalYesDotNoPos = 0;
    var totalYesUrineFecesNoPos = 0;
    var totalYesSpaceNoPos = 0;
    String defaultIncontinenceStr = '>有（　尿　　便　）　無<';
    for (var i = 0; i < 3; i++) {
      //43
      htmlInput = htmlInput.replaceFirst('ObservationTime${i + 1}',
          '${report.observationTime?[i]?.hour.toString().padLeft(2, '0') ?? '　　'}:${report.observationTime?[i]?.minute.toString().padLeft(2, '0') ?? '　　'}');
      //44
      htmlInput = htmlInput.replaceFirst(
          'JCS${i + 1}', report.jcsTypes[i]?.value ?? '');
      //46
      htmlInput = htmlInput.replaceFirst(
          'Respiration${i + 1}',
          report.respiration?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.respiration![i].toString()
              : '');
      //47
      htmlInput = htmlInput.replaceFirst(
          'Pulse${i + 1}',
          report.pulse?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pulse![i].toString()
              : '');
      //48
      htmlInput = htmlInput.replaceFirst(
          'BloodPressure_High${i + 1}',
          report.bloodPressureHigh?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.bloodPressureHigh![i].toString()
              : '');
      //49
      htmlInput = htmlInput.replaceFirst(
          'BloodPressure_Low${i + 1}',
          report.bloodPressureLow?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.bloodPressureLow![i].toString()
              : '');
      //50
      htmlInput = htmlInput.replaceFirst(
          'SpO2Percent${i + 1}',
          report.spO2Percent?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.spO2Percent![i].toString()
              : '');
      //52
      htmlInput = htmlInput.replaceFirst(
          'PupilRight${i + 1}',
          report.pupilRight?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pupilRight![i].toString()
              : '');
      //53
      htmlInput = htmlInput.replaceFirst(
          'PupilLeft${i + 1}',
          report.pupilLeft?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.pupilLeft![i].toString()
              : '');

      //56
      htmlInput = htmlInput.replaceFirst('BodyTemperature${i + 1}',
          report.bodyTemperature?[i]?.toString() ?? '');
    }
    return htmlInput;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      title: getReportName(),
      actions: _buildActions(),
      leadings: [_buildBackButton()],
      leadingWidth: 88,
    );
  }

  String getReportName() {
    return reportType == ReportType.certificate ? '傷病者輸送証' : '救急業務実施報告書';
  }

  List<Widget> _buildActions() {
    return [
      PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                value: 0,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 10,
                    leading: const Icon(Icons.print),
                    title: Text('印刷'.i18n()))),
            PopupMenuItem(
                value: 1,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 10,
                    leading: const Icon(Icons.ios_share),
                    title: Text('送信'.i18n()))),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case 0:
              if (_file != null) {
                final bytes = await _file!.readAsBytes();
                await Printing.layoutPdf(
                    onLayout: (_) => bytes, format: PdfPageFormat.a4);
              }
              break;
            case 1:
              if (_file != null) {
                await Share.shareXFiles([
                  XFile(_file!.absolute.path,
                      name: getReportName(), mimeType: 'application/pdf')
                ],
                    subject: getReportName(),
                    sharePositionOrigin: Rect.fromCenter(
                        center: const Offset(700, 20), width: 20, height: 20));
              }
              break;
          }
        },
      )
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const SizedBox(
        width: 12,
        child: Icon(Icons.arrow_back_ios),
      ),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return _file != null
        ? PdfPreview(
            useActions: false,
            build: (format) {
              return _file!.readAsBytes();
            },
            initialPageFormat: PdfPageFormat.a4,
          )
        : CustomProgressIndicatorWidget();
  }
}
