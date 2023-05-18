import 'dart:convert';
import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/report_type.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
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
    String extraCss =
        '.text-circle {border-radius: 100%;padding: 2px;border: 1px solid #000;text-align: center}';
    result = result.replaceAll('</style>', '$extraCss</style>');

    result = result.replaceAll('height:30.0pt', 'height:26pt');
    result = result.replaceAll('.5pt', '0.5pt');
    result = result.replaceAll('padding:0px;', 'padding:0 3pt;');
    // Remove default margin from page
    result = result.replaceAll('margin:.75in .7in .75in .7in', 'margin:0');
    result = result.replaceAll(
        'NumberOfDispatches_VALUE', report.totalCount?.toString() ?? '');
    result = result.replaceAll(
        'NumberOfDispatchesPerTeam_VALUE', report.teamCount?.toString() ?? '');
    result = result.replaceAll('TeamName_VALUE', report.team?.name ?? '');
    result = result.replaceAll(
        'TypeOfAccident_VALUE', report.accidentType?.value ?? '');
    result = result.replaceAll('PlaceOfIncident_VALUE',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.placeOfIncident, 3, 26) ?? ''}</div>');
    result = result.replaceAll('TeamCaptainName_VALUE',
        report.teamCaptainName?.characters.take(15).toString() ?? '');
    result = result.replaceAll('TeamMemberName_VALUE',
        report.teamMemberName?.characters.take(15).toString() ?? '');
    result = result.replaceAll('InstitutionalMemberName_VALUE',
        report.institutionalMemberName?.characters.take(15).toString() ?? '');
    result = result.replaceAll('PerceiverName_VALUE',
        report.perceiverName?.characters.take(15).toString() ?? '');
    result = result.replaceAll(
        'TypeOfDetection_VALUE', report.detectionType?.value ?? '');
    result = result.replaceAll('CallerName_VALUE',
        report.callerName?.characters.take(15).toString() ?? '');
    result = result.replaceAll('CallerTEL_VALUE', report.callerTel ?? '');
    result = result.replaceAll('SickInjuredPersonAddress_VALUE',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.sickInjuredPersonAddress, 4, 22) ?? ''}</div>');
    result = result.replaceAll('SickInjuredPersonName_VALUE',
        report.sickInjuredPersonName?.characters.take(17).string ?? '');
    result = result.replaceAll('SickInjuredPersonKANA_VALUE',
        report.sickInjuredPersonKana?.characters.take(17).string ?? '');
    result = result.replaceAll(
        'SickInjuredPersonGender_VALUE', report.gender?.value ?? '');
    final sickness = report.sickInjuredPersonNameOfInjuryOrSickness == null ||
            report.sickInjuredPersonNameOfInjuryOrSickness == ''
        ? '　\n　'
        : '${limitNumberOfChars(report.sickInjuredPersonNameOfInjuryOrSickness, 2, 18)}${report.sickInjuredPersonNameOfInjuryOrSickness!.length < 18 ? '\n　' : ''}';
    result = result.replaceAll('SickInjuredPersonNameOfInjuaryOrSickness_VALUE',
        '<div style="white-space: pre-wrap;">$sickness</div>');
    result = result.replaceAll('SickInjuredPersonAge_VALUE',
        report.sickInjuredPersonAge?.toString() ?? '');
    result = result.replaceAll('SickInjuredPersonTEL_VALUE',
        report.sickInjuredPersonTel?.toString() ?? '');
    result = result.replaceAll(
        'MedicalTransportFacility_VALUE',
        report.otherMedicalTransportFacility != null &&
                report.otherMedicalTransportFacility != ''
            ? report.otherMedicalTransportFacility!
            : report.medicalTransportFacilityType?.name ?? '');
    result = result.replaceAll(
        'TransferringMedicalInstitution_VALUE',
        report.otherTransferringMedicalInstitution != null &&
                report.otherTransferringMedicalInstitution != ''
            ? report.otherTransferringMedicalInstitution!
            : report.transferringMedicalInstitutionType?.name ?? '');
    result = result.replaceAll(
        'ReasonForTransfer_VALUE',
        report.reasonForTransferType?.value == 'その他'
            ? report.otherReasonForTransfer ?? ''
            : report.reasonForTransferType?.value ?? '');
    result = result.replaceAll('ReasonForNotTransferring_VALUE',
        '<div style="white-space: pre-wrap;">${limitNumberOfChars(report.reasonForNotTransferringType?.value == 'その他' ? report.otherReasonForNotTransferring ?? '' : report.reasonForNotTransferringType?.value ?? '', 6, 23) ?? ''}</div>');
    result = result.replaceAll('AffiliationOfReporter_VALUE',
        report.affiliationOfReporter?.characters.take(12).toString() ?? '');
    result = result.replaceAll(
        'PositionOfReporter_VALUE', report.positionOfReporterType?.value ?? '');
    result = result.replaceAll('NameOfReporter_VALUE',
        report.nameOfReporter?.characters.take(14).toString() ?? '');
    result = result.replaceAll('SummaryOfOccurrence_VALUE',
        '<div style="white-space: pre-wrap; line-height: 25px;">${limitNumberOfChars(report.summaryOfOccurrence, 12, 44) ?? ''}</div>');
    result = result.replaceAll('SickInjuredPersonDegree_VALUE',
        '<div style="line-height: 50px">${report.degree?.value ?? ''}</div>');

    result = fillTime(result, 'SenseTime', report.senseTime);
    result = fillTime(result, 'AttendanceTime', report.dispatchTime);
    result = fillTime(result, 'On-siteArrivalTime', report.onSiteArrivalTime);
    result = fillTime(result, 'TimeOfArrival', report.timeOfArrival);
    result =
        fillTime(result, 'HospitalArrivalTime', report.hospitalArrivalTime);
    result = fillTime(result, 'ReturnTime', report.returnTime);
    result = fillTime(result, 'TransferSourceReceivingTime',
        report.transferSourceReceivingTime);
    result = fillDate(result, 'SickInjuredPersonBirthDate',
        report.sickInjuredPersonBirthDate);
    result = fillDate(result, 'DateOfOccurrence', report.dateOfOccurrence);

    result = fillToday(result);

    result = result.replaceAll(
        'PlaceOfDispatch_TITLE',
        report.placeOfDispatch != null && report.placeOfDispatch! != ''
            ? '出場場所'
            : '');
    result = result.replaceAll(
        'PlaceOfDispatch_VALUE', report.placeOfDispatch ?? '');

    for (int i = 0; i < 3; i++) {
      result = result.replaceAll('DescriptionOfObservationTime_${i}_VALUE',
          report.observationTimeDescriptionTypes[i]?.value ?? '');
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
      result =
          result.replaceAll('EachECG_${i}_VALUE', report.eachEcg?[i] ?? '');
      result = result.replaceAll('SpO2Liter_${i}_VALUE',
          report.spO2Liter?[i]?.toStringAsFixed(1) ?? '');
      result = result.replaceAll('EachHemostasis_${i}_VALUE',
          (report.eachHemostasis?[i]) == true ? '有' : '');
      result = result.replaceAll('EachSuction_${i}_VALUE',
          (report.eachSuction?[i]) == true ? '有' : '');
      result = result.replaceAll(
          'OtherProcess1_${i}_VALUE', report.otherProcess1?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess2_${i}_VALUE', report.otherProcess2?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess3_${i}_VALUE', report.otherProcess3?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess4_${i}_VALUE', report.otherProcess4?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess5_${i}_VALUE', report.otherProcess5?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess6_${i}_VALUE', report.otherProcess6?[i] ?? '');
      result = result.replaceAll(
          'OtherProcess7_${i}_VALUE', report.otherProcess7?[i] ?? '');
    }
    result = result.replaceAll('Remark',
        '<div style="white-space: pre-wrap; line-height: 25px;">${limitNumberOfChars(report.remarks, 5, 45) ?? ''}</div>');
    result = fillBoolCircle(
        result, 'RecordOfRefusalOfTransfer', report.recordOfRefusalOfTransfer);
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
      template =
          template.replaceFirst(key, '<span class="square-black"></span>');
    } else {
      template = template.replaceFirst(key, '<span class="square"></span>');
    }
    return template;
  }

  String fillBoolCheck(String template, String key, bool? value) {
    template = fillCheck(template, '${key}_CHECK_TRUE', value != null && value);
    template =
        fillCheck(template, '${key}_CHECK_FALSE', value != null && !value);
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
      template = template.replaceAll('${key}_GGYY', "");
    }
    template = template.replaceAll('${key}_MM', date?.month.toString() ?? '');
    template = template.replaceAll('${key}_DD', date?.day.toString() ?? '');
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
    if (weekday == null) return '';
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
    return '';
  }

  String fillToday(String template) {
    DateTime date = DateTime.now();
    template = template.replaceAll(
        'GGYY', yearToWareki(date.year, date.month, date.day));
    template = template.replaceAll('MM', date.month.toString());
    template = template.replaceAll('DD', date.day.toString());
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

  String fillCertificateData(String template) {
    String result = template;
    Report report = _reportStore.selectingReport!;
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
          background: black;
          vertical-align: middle;
          margin-bottom: 4px;
      }

      .text-circle {
          border-radius: 100%;
          padding: 2px;
          background: #fff;
          border: 1px solid #000;
          text-align: center
      }
      ''';
    result = result.replaceAll('</style>', '$extraCss</style>');

    result = result.replaceAll('height:20.5pt', 'height:19pt');
    result = result.replaceAll('.5pt', '0.5pt');
    result = result.replaceAll('padding:0px;', 'padding:0 3pt;');

    result = result.replaceAll('TeamName',
        report.team?.abbreviation?.characters.take(11).toString() ?? '');
    result = result.replaceFirst('TeamCaptainName',
        report.teamCaptainName?.characters.take(11).toString() ?? '');

    final now = DateTime.now();
    var m = DateFormat.M().format(now).replaceFirst('月', '');
    var d = DateFormat.d().format(now).replaceFirst('日', '');
    result = result
        .replaceFirst('YYYY', yearToWareki(now.year, now.month, now.day))
        .replaceFirst('MM', m)
        .replaceFirst('DD', d);

    result = fillBoolCheck(
        result, 'LifesaverQualification', report.lifesaverQualification);
    result = fillBoolCheck(result, 'WithLifeSavers', report.withLifesavers);
    result = result.replaceFirst('TeamTEL', report.team?.tel ?? '');
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
            : '');
    result = result.replaceFirst(
        'SickInjuredPersonBirthDateMonth',
        report.sickInjuredPersonBirthDate?.month != null
            ? report.sickInjuredPersonBirthDate!.month.toString()
            : '');
    result = result.replaceFirst(
        'SickInjuredPersonBirthDateDay',
        report.sickInjuredPersonBirthDate?.day != null
            ? report.sickInjuredPersonBirthDate!.day.toString()
            : '');
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
    result = result.replaceAll(
        'SickInjuredPersonFamilyTEL', report.sickInjuredPersonFamilyTel ?? '');
    result = result.replaceAll(
        'SickInjuredPersonFamily', report.sickInjuredPersonFamily ?? '');
    result = fillBoolCheck(result, 'SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory?.isNotEmpty);
    result = result.replaceFirst('SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory ?? '');
    result = result.replaceFirst('SickInjuredPersonHistoryHospital',
        report.sickInjuredPersonHistoryHospital ?? '');
    result = fillBoolCheck(result, 'SickInjuredPersonKakaritsuke',
        report.sickInjuredPersonKakaritsuke?.isNotEmpty);
    result = result.replaceFirst(
        'SickInjuredPersonKakaritsuke',
        report.sickInjuredPersonKakaritsuke?.characters.take(19).toString() ??
            '');
    result = fillBoolCheck(
        result,
        'SickInjuredPersonMedicationDetail',
        report.medication?.classificationSubCd == '001' ||
            report.medication?.classificationSubCd == '002');
    result = fillCheck(
        result,
        'SickInjuredPersonMedicationDetail_CHECK_NOTEBOOK',
        report.medication?.classificationSubCd == '002');
    result = result.replaceFirst(
        'SickInjuredPersonMedicationDetail',
        report.sickInjuredPersonMedicationDetail?.characters
                .take(15)
                .toString() ??
            '');
    result = fillBoolCheck(result, 'SickInjuredPersonAllergy',
        report.sickInjuredPersonAllergy?.isNotEmpty);
    result = result.replaceFirst('SickInjuredPersonAllergy',
        report.sickInjuredPersonAllergy?.characters.take(19).toString() ?? '');

    result = fillClassificationCheck(
        result,
        'TypeOfAccident',
        getClassifications(AppConstants.typeOfAccidentCode),
        report.accidentType?.classificationSubCd);
    result = fillCheck(
        result,
        'TypeOfAccident_CHECK_OTHER',
        report.accidentType?.classificationSubCd == '010' ||
            report.accidentType?.classificationSubCd == '099');
    result = result.replaceFirst(
        'TypeOfAccident_VALUE', report.accidentType?.value ?? '');

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
    result = result.replaceFirst('SenseTime',
        '${report.senseTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.senseTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('CommandTime',
        '${report.commandTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.commandTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('AttendanceTime',
        '${report.dispatchTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.dispatchTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('On-siteArrivalTime',
        '${report.onSiteArrivalTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.onSiteArrivalTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('ContactTime',
        '${report.contactTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.contactTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('In-vehicleTime',
        '${report.inVehicleTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.inVehicleTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('StartOfTransportTime',
        '${report.startOfTransportTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.startOfTransportTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('HospitalArrivalTime',
        '${report.hospitalArrivalTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.hospitalArrivalTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = fillBoolCheck(result, 'FamilyContact', report.familyContact);
    result = fillBoolCheck(result, 'PoliceContact', report.policeContact);
    if (report.familyContactTime != null) {
      result = result.replaceFirst('FamilyContactTime',
          '${report.familyContactTime!.hour.toString().padLeft(2, '0')}:${report.familyContactTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('FamilyContactTime', '  --:--  ');
    }
    if (report.policeContactTime != null) {
      result = result.replaceFirst('PoliceContactTime',
          '${report.policeContactTime!.hour.toString().padLeft(2, '0')}:${report.policeContactTime!.minute.toString().padLeft(2, '0')}');
    } else {
      result = result.replaceFirst('PoliceContactTime', '  --:--  ');
    }
    result = fillClassificationCheck(
        result,
        'ADL',
        getClassifications(AppConstants.adlCode),
        report.adlType?.classificationSubCd);
    result = fillCheck(result, 'TrafficAccident_Unknown_CHECK',
        report.trafficAccidentUnknown == true);
    result = fillCheck(result, 'TrafficAccident_Seatbelt_CHECK',
        report.trafficAccidentSeatbelt == true);
    result = fillCheck(result, 'TrafficAccident_Childseat_CHECK',
        report.trafficAccidentChildseat == true);
    result = fillCheck(result, 'TrafficAccident_Airbag_CHECK',
        report.trafficAccidentAirbag == true);
    result = fillCheck(result, 'TrafficAccident_Helmet_CHECK',
        report.trafficAccidentHelmet == true);
    result = fillBoolCheck(result, 'Witnesses', report.witnesses);
    result = fillBoolCheck(result, 'VerbalGuidance', report.verbalGuidance);
    result = fillBoolCheck(result, 'BystanderCPR', report.bystanderCpr);
    if (report.bystanderCprTime != null) {
      result = result.replaceFirst('BystanderCPR',
          '${report.bystanderCprTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bystanderCprTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    } else {
      result = result.replaceFirst('BystanderCPR', '');
    }
    result = result.replaceFirst('VerbalGuidance',
        report.verbalGuidanceText?.characters.take(18).toString() ?? '');
    result = fillClassificationCheck(
        result,
        'SecuringAirway',
        getClassifications(AppConstants.securingAirwayCode),
        report.securingAirwayType?.classificationSubCd);
    result = fillCheck(result, 'SecuringAirway_CHECK',
        report.securingAirway != null && report.securingAirway != '');

    for (int i = 0; i < 3; i++) {
      result = result.replaceFirst('ObservationTime${i + 1}',
          '${report.observationTime?[i]?.hour.toString().padLeft(2, '0') ?? '--'}:${report.observationTime?[i]?.minute.toString().padLeft(2, '0') ?? '--'}');
      result =
          result.replaceFirst('JCS${i + 1}', report.jcsTypes[i]?.value ?? '');
      result = result.replaceFirst(
          'GCS_E${i + 1}', report.gcsETypes[i]?.value ?? '');
      result = result.replaceFirst(
          'GCS_V${i + 1}', report.gcsVTypes[i]?.value ?? '');
      result = result.replaceFirst(
          'GCS_M${i + 1}', report.gcsMTypes[i]?.value ?? '');
      final e = int.parse(report.gcsETypes[i]?.value ?? '0');
      final v = int.parse(report.gcsVTypes[i]?.value ?? '0');
      final m = int.parse(report.gcsMTypes[i]?.value ?? '0');
      final sum = e + v + m;
      result =
          result.replaceFirst('SumEVM${i + 1}', sum != 0 ? sum.toString() : '');
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
          'SpO2Liter${i + 1}',
          report.spO2Liter?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.spO2Liter![i].toString()
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
      result = fillBoolCircle(
          result, 'LightReflexLeft_$i', report.lightReflexLeft?[i]);
      result = fillBoolCircle(
          result, 'LightReflexRight_$i', report.lightReflexRight?[i]);
      result = result.replaceFirst('BodyTemperature${i + 1}',
          report.bodyTemperature?[i]?.toString() ?? '');
      result = fillClassificationCircle(
          result,
          'FacialFeatures_$i',
          getClassifications(AppConstants.facialFeaturesCode),
          report.facialFeatureTypes[i]?.classificationSubCd);
      final hemorrhage = report.hemorrhage
          ?.firstWhereIndexedOrNull((index, element) => index == i)
          ?.toString();
      result = fillBoolCircle(result, 'Hemorrhage_$i', hemorrhage?.isNotEmpty);
      result = result.replaceFirst('Hemorrhage${i + 1}', hemorrhage ?? '');
      final incon = report.incontinenceTypes[i]?.classificationSubCd;
      result = fillClassificationCircle(result, 'Incontinence_$i',
          getClassifications(AppConstants.incontinenceCode), incon);
      result = fillBoolCircle(
          result,
          'Incontinence_$i',
          report.observationTime?[i] == null
              ? null
              : (incon != '000' && incon != null));
      result = fillBoolCircle(result, 'Vomiting_$i', report.vomiting?[i]);
      result = result.replaceFirst(
          'Extremities${i + 1}',
          report.extremities
                  ?.firstWhereIndexedOrNull((index, element) => index == i) ??
              '');
    }
    result = fillCheck(result, 'Coating_CHECK', report.coating == true);
    result =
        fillCheck(result, 'BurnTreatment_CHECK', report.burnTreatment == true);
    result = fillCheck(
        result, 'ForeignBodyRemoval_CHECK', report.foreignBodyRemoval == true);
    result = fillCheck(result, 'Suction_CHECK', report.suction == true);
    result = fillCheck(result, 'ArtificialRespiration_CHECK',
        report.artificialRespiration == true);
    result = fillCheck(
        result, 'ChestCompressions_CHECK', report.chestCompressions == true);
    result = fillCheck(result, 'ECGMonitor_CHECK', report.ecgMonitor == true);
    result = fillCheck(
        result, 'O2Administration_CHECK', report.o2Administration != null);
    result = result.replaceFirst(
        'O2Administration', report.o2Administration?.toString() ?? '');
    result = result.replaceFirst('O2AdministrationTime',
        '${report.o2AdministrationTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.o2AdministrationTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = fillCheck(result, 'LimitationOfSpinalMotion_CHECK',
        report.limitationOfSpinalMotionType != null);
    result = fillClassificationCheck(
        result,
        'LimitationOfSpinalMotion',
        getClassifications(AppConstants.limitationOfSpinalMotionCode),
        report.limitationOfSpinalMotionType?.classificationSubCd);
    result = fillCheck(result, 'HemostaticTreatment_CHECK',
        report.hemostaticTreatment == true);
    result = fillCheck(
        result, 'AdductorFixation_CHECK', report.adductorFixation == true);
    result = fillCheck(
        result, 'Other_CHECK', report.other != null && report.other != '');
    result = result.replaceFirst('Other',
        '<div style="white-space: pre-wrap; font-size: 7pt; margin-left: 3pt">${report.other?.split('').slices(10).map((e) => e.join()).join('\n') ?? ''}</div>');
    result = fillCheck(result, 'BSMeasurement_CHECK',
        report.bsMeasurement1 != null || report.bsMeasurement2 != null);
    result = result.replaceFirst(
        'BSMeasurement1', report.bsMeasurement1?.toString() ?? '');
    result = result.replaceFirst('BSMeasurementTime1',
        '${report.bsMeasurementTime1?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bsMeasurementTime1?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('PunctureSite1',
        report.punctureSite1?.characters.take(9).toString().toString() ?? '');
    result = result.replaceFirst(
        'BSMeasurement2', report.bsMeasurement2?.toString() ?? '');
    result = result.replaceFirst('BSMeasurementTime2',
        '${report.bsMeasurementTime2?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bsMeasurementTime2?.minute.toString().padLeft(2, '0') ?? '--'}');
    result = result.replaceFirst('PunctureSite2',
        report.punctureSite2?.characters.take(9).toString().toString() ?? '');

    return result;
  }

  List<Classification> getClassifications(String code) {
    return _classificationStore.classifications.values
        .where((e) => e.classificationCd == code)
        .toList();
  }

  String fillCertificateDataOld(String htmlInput) {
    final Report report = _reportStore.selectingReport!;
    final team = report.team;
    bool? withLifesaver = report.withLifesavers;
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
    //2
    htmlInput = htmlInput.replaceFirst(
        'TeamName', team?.abbreviation?.characters.take(11).toString() ?? '');
    //3
    htmlInput = htmlInput.replaceFirst('TeamCaptainName',
        report.teamCaptainName?.characters.take(11).toString() ?? '');
    //4
    if (report.lifesaverQualification != null) {
      if (report.lifesaverQualification!) {
        htmlInput = customReplace(
            htmlInput, uncheckYes, 1 - totalYesPos, '$checkIcon 有');
        htmlInput = customReplace(
            htmlInput, uncheckNo, 1 - totalNoPos, '$uncheckIcon 無');
        totalYesPos += 1;
        totalNoPos += 1;
      } else {
        htmlInput = customReplace(
            htmlInput, uncheckYes, 1 - totalYesPos, '$uncheckIcon 有');
        htmlInput =
            customReplace(htmlInput, uncheckNo, 1 - totalNoPos, '$checkIcon 無');
        totalYesPos += 1;
        totalNoPos += 1;
      }
    } else {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 1 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 1 - totalNoPos, '$uncheckIcon 無');
      totalYesPos += 1;
      totalNoPos += 1;
    }

    //5
    if (withLifesaver != null) {
      if (!withLifesaver) {
        htmlInput = customReplace(
            htmlInput, uncheckYes, 2 - totalYesPos, '$uncheckIcon 有');
        htmlInput =
            customReplace(htmlInput, uncheckNo, 2 - totalNoPos, '$checkIcon 無');
        totalNoPos += 1;
        totalYesPos += 1;
      } else {
        htmlInput = customReplace(
            htmlInput, uncheckYes, 2 - totalYesPos, '$checkIcon 有');
        htmlInput = customReplace(
            htmlInput, uncheckNo, 2 - totalNoPos, '$uncheckIcon 無');
        totalYesPos += 1;
        totalNoPos += 1;
      }
    } else {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 2 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 2 - totalNoPos, '$uncheckIcon 無');
      totalYesPos += 1;
      totalNoPos += 1;
    }

    //6
    htmlInput = htmlInput.replaceFirst('TeamTEL', team?.tel ?? '');

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

    //14
    htmlInput = htmlInput.replaceAll(
        'SickInjuredPersonFamilyTEL', report.sickInjuredPersonFamilyTel ?? '');
    htmlInput = htmlInput.replaceAll(
        'SickInjuredPersonFamily', report.sickInjuredPersonFamily ?? '');

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

    //18
    if (report.sickInjuredPersonKakaritsuke == null ||
        report.sickInjuredPersonKakaritsuke == '') {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 4 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 4 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 4 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 4 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //19
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonKakaritsuke',
        report.sickInjuredPersonKakaritsuke?.characters.take(19).toString() ??
            '');

    //20
    htmlInput = htmlInput.replaceFirst('$uncheckIcon手帳', '$uncheckIcon 手帳');
    if (report.sickInjuredPersonMedication == '000') {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 5 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 5 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.sickInjuredPersonMedication == '001') {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 5 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 5 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.sickInjuredPersonMedication == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 手帳', '$checkIcon 手帳');
      htmlInput =
          customReplace(htmlInput, uncheckYes, 5 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 5 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //21
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonMedicationDetail',
        report.sickInjuredPersonMedicationDetail?.characters
                .take(15)
                .toString() ??
            '');

    //22
    if (report.sickInjuredPersonAllergy == null ||
        report.sickInjuredPersonAllergy == '') {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 6 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 6 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 6 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 6 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //23
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonAllergy',
        report.sickInjuredPersonAllergy?.characters.take(19).toString() ?? '');

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
    if (report.adl == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon自立', '$checkIcon自立');
    } else if (report.adl == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon全介助', '$checkIcon全介助');
    } else if (report.adl == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon部分介助', '$checkIcon部分介助');
    }

    //29
    htmlInput = htmlInput.replaceFirst('SenseTime',
        '${report.senseTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.senseTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //30
    htmlInput = htmlInput.replaceFirst('CommandTime',
        '${report.commandTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.commandTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //31
    htmlInput = htmlInput.replaceFirst('AttendanceTime',
        '${report.dispatchTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.dispatchTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //32
    htmlInput = htmlInput.replaceFirst('On-siteArrivalTime',
        '${report.onSiteArrivalTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.onSiteArrivalTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //33
    htmlInput = htmlInput.replaceFirst('ContactTime',
        '${report.contactTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.contactTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //34
    htmlInput = htmlInput.replaceFirst('In-vehicleTime',
        '${report.inVehicleTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.inVehicleTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //35
    htmlInput = htmlInput.replaceFirst('StartOfTransportTime',
        '${report.startOfTransportTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.startOfTransportTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    //36
    htmlInput = htmlInput.replaceFirst('HospitalArrivalTime',
        '${report.hospitalArrivalTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.hospitalArrivalTime?.minute.toString().padLeft(2, '0') ?? '--'}');
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

    if (report.familyContactTime != null) {
      htmlInput = htmlInput.replaceFirst('FamilyContactTime',
          '${report.familyContactTime!.hour.toString().padLeft(2, '0')}:${report.familyContactTime!.minute.toString().padLeft(2, '0')}');
    } else {
      htmlInput = htmlInput.replaceFirst('FamilyContactTime', '  --:--  ');
    }
    //38

    if (report.policeContact == true) {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 8 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 8 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.policeContact == false) {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 8 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 8 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    if (report.policeContactTime != null) {
      htmlInput = htmlInput.replaceFirst('PoliceContactTime',
          '${report.policeContactTime!.hour.toString().padLeft(2, '0')}:${report.policeContactTime!.minute.toString().padLeft(2, '0')}');
    } else {
      htmlInput = htmlInput.replaceFirst('PoliceContactTime', '  --:--  ');
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

    if (report.trafficAccidentSeatbelt == true) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon シートベルト', '$checkIconシートベルト');
    }
    if (report.trafficAccidentAirbag == true) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon エアバック', '$checkIconエアバック');
    }
    if (report.trafficAccidentUnknown == true) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon 不明', '$checkIcon不明');
    }
    if (report.trafficAccidentChildseat == true) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon チャイルドシート', '$checkIconチャイルドシート');
    }
    if (report.trafficAccidentHelmet == true) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon ヘルメット', '$checkIconヘルメット');
    }

    //40
    if (report.witnesses == true) {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 9 - totalYesPos, '$checkIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 9 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.witnesses == false) {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 9 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 9 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }

    //41
    if (report.bystanderCpr == true) {
      htmlInput = htmlInput.replaceAll('$uncheckIcon有（', '$checkIcon有（');
    } else if (report.bystanderCpr == false) {
      htmlInput = htmlInput.replaceAll('）　$uncheckIcon無', '）　$checkIcon無');
    }

    if (report.bystanderCprTime != null) {
      htmlInput = htmlInput.replaceFirst('BystanderCPR',
          '${report.bystanderCprTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bystanderCprTime?.minute.toString().padLeft(2, '0') ?? '--'}');
    } else {
      htmlInput = htmlInput.replaceFirst('BystanderCPR', '');
    }

    //42
    if (report.verbalGuidance == true) {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 10 - totalYesPos, '$checkIcon 有');
      htmlInput = customReplace(
          htmlInput, uncheckNo, 10 - totalNoPos, '$uncheckIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    } else if (report.verbalGuidance == false) {
      htmlInput = customReplace(
          htmlInput, uncheckYes, 10 - totalYesPos, '$uncheckIcon 有');
      htmlInput =
          customReplace(htmlInput, uncheckNo, 10 - totalNoPos, '$checkIcon 無');
      totalNoPos += 1;
      totalYesPos += 1;
    }
    htmlInput = htmlInput.replaceFirst('VerbalGuidance',
        report.verbalGuidanceText?.characters.take(18).toString() ?? '');

    //42

    //43-61
    htmlInput = handleDatLayout578(htmlInput);

    //62
    if (report.securingAirway != null && report.securingAirway != '') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　気道確保', '$checkIcon　気道確保');
    }

    //63
    if (report.securingAirway == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon用手', '$checkIcon用手');
    } else if (report.securingAirway == '001') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconエアウェイ', '$checkIconエアウェイ');
    }

    //64
    if (report.foreignBodyRemoval != null && report.foreignBodyRemoval!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　異物除去', '$checkIcon　異物除去');
    }

    //65
    if (report.suction != null && report.suction!) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　吸引', '$checkIcon　吸引');
    }

    //66
    if (report.artificialRespiration != null && report.artificialRespiration!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　人口呼吸', '$checkIcon　人口呼吸');
    }

    //67
    if (report.chestCompressions != null && report.chestCompressions!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　胸骨圧迫', '$checkIcon　胸骨圧迫');
    }

    //68
    if (report.ecgMonitor != null && report.ecgMonitor!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　ECGモニター', '$checkIcon　ECGモニター');
    }

    //69
    if (report.o2Administration != null) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　O2投与', '$checkIcon　O2投与');
    }

    //70
    htmlInput = htmlInput.replaceFirst(
        'O2Administration', report.o2Administration?.toString() ?? '');

    //71
    htmlInput = htmlInput.replaceFirst('O2AdministrationTime',
        '${report.o2AdministrationTime?.hour.toString().padLeft(2, '0') ?? '--'}:${report.o2AdministrationTime?.minute.toString().padLeft(2, '0') ?? '--'}');

    //72
    if (report.limitationOfSpinalMotion != null &&
        report.limitationOfSpinalMotion != '') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　脊椎運動制限', '$checkIcon　脊椎運動制限');
    }

    //73
    if (report.limitationOfSpinalMotion == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon頸椎のみ', '$checkIcon頸椎のみ');
    } else if (report.limitationOfSpinalMotion == '001') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconバックボード', '$checkIconバックボード');
    }

    //74
    if (report.hemostaticTreatment != null && report.hemostaticTreatment!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　止血処置', '$checkIcon　止血処置');
    }

    //75
    if (report.adductorFixation != null && report.adductorFixation!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　副子固定', '$checkIcon　副子固定');
    }

    //76
    if (report.coating != null && report.coating!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　被覆処置', '$checkIcon　被覆処置');
    }

    //77
    if (report.coating != null && report.coating!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　被覆処置', '$checkIcon　被覆処置');
    }

    //77
    if (report.burnTreatment != null && report.burnTreatment!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　熱傷処置', '$checkIcon　熱傷処置');
    }

    //78
    if (report.other != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　その他', '$checkIcon　その他');
    }

    //79
    htmlInput = htmlInput.replaceFirst('Other',
        '<div style="white-space: pre-wrap; font-size: 7pt; margin-left: 3pt">${report.other?.split('').slices(10).map((e) => e.join()).join('\n') ?? ''}</div>');

    //80
    if (report.bsMeasurement1 != null || report.bsMeasurement2 != null) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　BS測定', '$checkIcon　BS測定');
    }

    //81
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurement1', report.bsMeasurement1?.toString() ?? '');

    //82
    htmlInput = htmlInput.replaceFirst('BSMeasurementTime1',
        '${report.bsMeasurementTime1?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bsMeasurementTime1?.minute.toString().padLeft(2, '0') ?? '--'}');

    //83
    htmlInput = htmlInput.replaceFirst('PunctureSite1',
        report.punctureSite1?.characters.take(9).toString().toString() ?? '');

    //84
    if (report.bsMeasurement2 != null) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　BS測定', '$checkIcon　BS測定');
    }

    //85
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurement2', report.bsMeasurement2?.toString() ?? '');

    //86
    htmlInput = htmlInput.replaceFirst('BSMeasurementTime2',
        '${report.bsMeasurementTime2?.hour.toString().padLeft(2, '0') ?? '--'}:${report.bsMeasurementTime2?.minute.toString().padLeft(2, '0') ?? '--'}');

    //87
    htmlInput = htmlInput.replaceFirst('PunctureSite2',
        report.punctureSite2?.characters.take(9).toString().toString() ?? '');

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
          '${report.observationTime?[i]?.hour.toString().padLeft(2, '0') ?? '--'}:${report.observationTime?[i]?.minute.toString().padLeft(2, '0') ?? '--'}');
      //44
      htmlInput = htmlInput.replaceFirst(
          'JCS${i + 1}', report.jcsTypes[i]?.value ?? '');
      //45
      htmlInput = htmlInput.replaceFirst(
          'GCS_E${i + 1}', report.gcsETypes[i]?.value ?? '');
      htmlInput = htmlInput.replaceFirst(
          'GCS_V${i + 1}', report.gcsVTypes[i]?.value ?? '');
      htmlInput = htmlInput.replaceFirst(
          'GCS_M${i + 1}', report.gcsMTypes[i]?.value ?? '');
      final e = int.parse(report.gcsETypes[i]?.value ?? '0');
      final v = int.parse(report.gcsVTypes[i]?.value ?? '0');
      final m = int.parse(report.gcsMTypes[i]?.value ?? '0');
      final sum = e + v + m;
      htmlInput = htmlInput.replaceFirst(
          'SumEVM${i + 1}', sum != 0 ? sum.toString() : '');
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
      //51
      htmlInput = htmlInput.replaceFirst(
          'SpO2Liter${i + 1}',
          report.spO2Liter?.firstWhereIndexedOrNull(
                      (index, element) => index == i) !=
                  null
              ? report.spO2Liter![i].toString()
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
      //54
      if (report.lightReflexRight?[i] == false) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            1 + 2 * i - totalYesDotNoPos,
            '有・<span class="text-circle">無</span>');
        totalYesDotNoPos += 1;
      } else if (report.lightReflexRight?[i] == true) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            1 + 2 * i - totalYesDotNoPos,
            '<span class="text-circle">有</span>・無');
        totalYesDotNoPos += 1;
      }

      //55
      if (report.lightReflexLeft?[i] == false) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            2 + 2 * i - totalYesDotNoPos,
            '有・<span class="text-circle">無</span>');
        totalYesDotNoPos += 1;
      } else if (report.lightReflexLeft?[i] == true) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            2 + 2 * i - totalYesDotNoPos,
            '<span class="text-circle">有</span>・無');
        totalYesDotNoPos += 1;
      }

      //56
      htmlInput = htmlInput.replaceFirst('BodyTemperature${i + 1}',
          report.bodyTemperature?[i]?.toString() ?? '');
      //57
      if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '000') {
        htmlInput = customReplace(
            htmlInput, '正常', i + 1, '<span class="text-circle">正常</span>');
      } else if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '001') {
        htmlInput = customReplace(
            htmlInput, '紅潮', i + 1, '<span class="text-circle">紅潮</span>');
      } else if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '002') {
        htmlInput = customReplace(
            htmlInput, '蒼白', i + 1, '<span class="text-circle">蒼白</span>');
      } else if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '003') {
        htmlInput = customReplace(htmlInput, 'チアノーゼ', i + 1,
            '<span class="text-circle">チアノーゼ</span>');
      } else if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '004') {
        htmlInput = customReplace(
            htmlInput, '発汗', i + 1, '<span class="text-circle">発汗</span>');
      } else if (report.facialFeatures
              ?.firstWhereIndexedOrNull((index, element) => index == i) ==
          '005') {
        htmlInput = customReplace(
            htmlInput, '苦悶', i + 1, '<span class="text-circle">苦悶</span>');
      }
      //58
      final hemorrhage = report.hemorrhage
          ?.firstWhereIndexedOrNull((index, element) => index == i)
          ?.toString();
      final hasHemorrhage = hemorrhage != null && hemorrhage != '';
      if (hasHemorrhage) {
        htmlInput =
            htmlInput.replaceFirst('有(', '<span class="text-circle">有</span>(');
        htmlInput = htmlInput.replaceFirst(')　無', ') 無');
      } else if (report.observationTime?[i] != null) {
        htmlInput = htmlInput.replaceFirst('有(', '有 (');
        htmlInput = htmlInput.replaceFirst(
            ')　無', ') <span class="text-circle">無</span>');
      } else {
        htmlInput = htmlInput.replaceFirst('有(', '有 (');
        htmlInput = htmlInput.replaceFirst(')　無', ') 無');
      }
      htmlInput = htmlInput.replaceFirst('Hemorrhage${i + 1}',
          hasHemorrhage ? hemorrhage.characters.take(8).toString() : '');
      //59
      // int index001 = report.incontinence?.indexOf("001") ?? -1;
      // int index002 = report.incontinence?.indexOf("002") ?? -1;
      // int index003 = report.incontinence?.indexOf("003") ?? -1;
      // if (index001 >= 0 && index003 >= 0) report.incontinence?[index001] = '';
      // if (index002 >= 0 && index003 >= 0) report.incontinence?[index002] = '';
      final incon = report.incontinence?[i];
      String incontinenceStr = defaultIncontinenceStr;
      if ((incon == '000' || incon == null) &&
          report.observationTime?[i] != null) {
        incontinenceStr = incontinenceStr.replaceFirst(
            '無', '<span class="text-circle">無</span>');
      } else if (incon == '001') {
        incontinenceStr = incontinenceStr.replaceFirst(
            '尿', '<span class="text-circle">尿</span>');
      } else if (incon == '002') {
        incontinenceStr = incontinenceStr.replaceFirst(
            '便', '<span class="text-circle">便</span>');
      } else if (incon == '003') {
        incontinenceStr = incontinenceStr.replaceFirst(
            '尿', '<span class="text-circle">尿</span>');
        incontinenceStr = incontinenceStr.replaceFirst(
            '便', '<span class="text-circle">便</span>');
      }
      if (incontinenceStr != defaultIncontinenceStr) {
        htmlInput =
            htmlInput.replaceFirst(defaultIncontinenceStr, incontinenceStr);
      } else {
        htmlInput =
            htmlInput.replaceFirst(defaultIncontinenceStr, '> 有（　尿　　便　）　無 <');
      }

      //60
      if (report.vomiting
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          report.vomiting![i]!) {
        htmlInput = customReplace(htmlInput, '有　　無', i + 1 - totalYesSpaceNoPos,
            '<span class="text-circle">有</span>　　無');
        totalYesSpaceNoPos += 1;
      } else if (report.observationTime?[i] != null) {
        htmlInput = customReplace(htmlInput, '有　　無', i + 1 - totalYesSpaceNoPos,
            '有　　<span class="text-circle">無</span>');
        totalYesSpaceNoPos += 1;
      }
      //61
      htmlInput = htmlInput.replaceFirst(
          'Extremities${i + 1}',
          report.extremities
                  ?.firstWhereIndexedOrNull((index, element) => index == i) ??
              '');
    }
    return htmlInput;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  String getReportName() {
    return reportType == ReportType.certificate ? '傷病者輸送証' : '救急業務実施報告書';
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(getReportName(),
          style: TextStyle(color: Theme.of(context).primaryColor)),
      actions: _buildActions(),
      centerTitle: true,
      leading: _buildBackButton(),
      leadingWidth: 88,
    );
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
        : const CustomProgressIndicatorWidget();
  }
}
