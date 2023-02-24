import 'dart:convert';
import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/report_type.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
          filledReport, tempDir.path, 'report.pdf');
    } else if (reportType == ReportType.ambulance) {
      String reportTemplate =
          await rootBundle.loadString(AppConstants.reportAmbulanceTemplatePath);
      String filledReport = fillAmbulanceData(reportTemplate);
      return await FlutterHtmlToPdf.convertFromHtmlContent(
          filledReport, tempDir.path, 'report.pdf');
    } else {
      assert(false);
    }
  }

  String fillAmbulanceData(String template) {
    String result = template;
    Report report = _reportStore.selectingReport!;
    Map<String, dynamic> reportMap = _reportStore.selectingReport!.toMap();
    result = result.replaceAll('.5pt', '0.5pt');
    // Remove default margin from page
    result = result.replaceAll('margin:.75in .7in .75in .7in', 'margin:0');
    result =
        result.replaceAll('NumberOfDispatches_VALUE', reportMap['Total'] ?? '');
    result = result.replaceAll(
        'NumberOfDispatchesPerTeam_VALUE', reportMap['Team'] ?? '');
    result = result.replaceAll('TeamName_VALUE', report.team?.name ?? '');
    result = result.replaceAll(
        'TypeOfAccident_VALUE', report.accidentType?.value ?? '');
    result = result.replaceAll(
        'PlaceOfIncident_VALUE', report.placeOfIncident ?? '');
    result = result.replaceAll(
        'TeamCaptainName_VALUE', report.teamCaptain?.name ?? '');
    result = result.replaceAll(
        'TeamMemberName_VALUE', report.teamMember?.name ?? '');
    result = result.replaceAll('InstitutionalMemberName_VALUE',
        report.institutionalMember?.name ?? '');
    result =
        result.replaceAll('PerceiverName_VALUE', report.perceiverName ?? '');
    result = result.replaceAll(
        'TypeOfDetection_VALUE', report.detectionType?.value ?? '');
    result = result.replaceAll('CallerName_VALUE', report.callerName ?? '');
    result = result.replaceAll('CallerTEL_VALUE', report.callerTel ?? '');
    result = result.replaceAll('SickInjuredPersonAddress_VALUE',
        report.sickInjuredPersonAddress ?? '');
    result = result.replaceAll(
        'SickInjuredPersonName_VALUE', report.sickInjuredPersonName ?? '');
    result = result.replaceAll(
        'SickInjuredPersonGender_VALUE', report.gender?.value ?? '');
    result = result.replaceAll('SickInjuredPersonNameOfInjuaryOrSickness_VALUE',
        report.sickInjuredPersonNameOfInjuryOrSickness ?? '');
    result = result.replaceAll('SickInjuredPersonAge_VALUE',
        report.sickInjuredPersonAge?.toString() ?? '');
    result = result.replaceAll('SickInjuredPersonTEL_VALUE',
        report.sickInjuredPersonTel?.toString() ?? '');
    result = result.replaceAll('MedicalTransportFacility_VALUE',
        report.medicalTransportFacility ?? '');
    result = result.replaceAll('TransferringMedicalInstitution_VALUE',
        report.transferringMedicalInstitution ?? '');
    result = result.replaceAll(
        'ReasonForTransfer_VALUE', report.reasonForTransfer ?? '');
    result = result.replaceAll('ReasonForNotTransferring_VALUE',
        report.reasonForNotTransferring ?? '');
    result = result.replaceAll(
        'AffiliationOfReporter_VALUE',
        report.reporter?.teamCd != null
            ? report.teamStore?.teams[report.reporter?.teamCd]?.name ?? ''
            : '');
    result = result.replaceAll(
        'PositionOfReporter_VALUE', report.reporter?.position ?? '');
    result =
        result.replaceAll('NameOfReporter_VALUE', report.reporter?.name ?? '');
    result = result.replaceAll(
        'SummaryOfOccurrence_VALUE', report.summaryOfOccurrence ?? '');
    result = result.replaceAll(
        'SickInjuredPersonDegree_VALUE', report.sickInjuredPersonDegree ?? '');

    result = fillTime(result, 'SenseTime', report.senseTime);
    result = fillTime(result, 'AttendanceTime', report.attendanceTime);
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
    }
    result = result.replaceAll('Remark', report.remarks ?? '');
    return result;
  }

  String fillTime(String template, String key, TimeOfDay? time) {
    template = template.replaceAll('${key}_H', time?.hour.toString() ?? '');
    template = template.replaceAll('${key}_M', time?.minute.toString() ?? '');
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

  String yearToWareki(num year, num month, num day) {
    var wareki = "エラー";

    if ((year == 2019) && (month < 5)) {
      wareki = "平成 31";
    } else if ((year == 1989) && (month < 2) && (day < 8)) {
      wareki = "昭和 64";
    } else if ((year == 1926) && (month < 13) && (day < 26)) {
      wareki = "大正 15";
    } else if ((year == 1926) && (month < 12)) {
      wareki = "大正 15";
    } else if ((year == 1868) && (month < 8) && (day < 31)) {
      wareki = "明治 45";
    } else if ((year == 1868) && (month < 7)) {
      wareki = "明治 45";
    } else if (year > 2018) {
      wareki = "令和 " + (year - 2018).toString();
    } else if (year > 1988) {
      wareki = "平成 " + (year - 1988).toString();
    } else if (year > 1925) {
      wareki = "昭和 " + (year - 1925).toString();
    } else if (year > 1911) {
      wareki = "大正 " + (year - 1911).toString();
    } else {
      wareki = "明治 " + (year - 1867).toString();
    }

    return wareki;
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

  String fillCertificateData(String htmlInput) {
    final Report report = _reportStore.selectingReport!;
    final team = report.team;
    final teamCaptain = report.teamCaptain;
    final teamMember = report.teamMember;
    final institutionalMember = report.institutionalMember;
    bool? withLifesaver;
    if (teamCaptain?.lifesaverQualification != null) {
      withLifesaver = (withLifesaver != null && withLifesaver) ||
          teamCaptain!.lifesaverQualification!;
    }
    if (teamMember?.lifesaverQualification != null) {
      withLifesaver = (withLifesaver != null && withLifesaver) ||
          teamMember!.lifesaverQualification!;
    }
    if (institutionalMember?.lifesaverQualification != null) {
      withLifesaver = (withLifesaver != null && withLifesaver) ||
          institutionalMember!.lifesaverQualification!;
    }
    const uncheckIcon = '<span class="square"></span>';
    const checkIcon = '<span class="square-black"></span>';
    const String styleCSSMore =
        '.square {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid;}.square-black {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid;background: black;}.text-circle {border-radius: 100%;padding: 2px;background: #fff;border: 1px solid #000;text-align: center}';
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

    //increment border-width style: .5pt - 0.5pt
    htmlInput = htmlInput.replaceAll('.5pt', '0.5pt');

    //add style
    htmlInput = htmlInput.replaceAll('</style>', '$styleCSSMore</style>');

    //add overflow hide in TeamName, TeamCaptainName, Other
    htmlInput = htmlInput.replaceFirst('\'>TeamName', '$overflow\'>TeamName');
    htmlInput = htmlInput.replaceFirst(
        '\'>TeamCaptainName', '$overflow\'>TeamCaptainName');
    htmlInput = htmlInput.replaceFirst('>Other', '$overflowStyle>Other');

    //fill yyyy mm dd now
    var y = DateFormat.y().format(DateTime.now()).replaceFirst('年', '');
    var m = DateFormat.M().format(DateTime.now()).replaceFirst('月', '');
    var d = DateFormat.d().format(DateTime.now()).replaceFirst('日', '');
    //1
    htmlInput = htmlInput
        .replaceFirst('YYYY', y)
        .replaceFirst('MM', m)
        .replaceFirst('DD', d);
    //2
    htmlInput = htmlInput.replaceFirst('TeamName', team?.name ?? '');
    //3
    htmlInput =
        htmlInput.replaceFirst('TeamCaptainName', teamCaptain?.name ?? '');
    //4
    if (teamCaptain?.lifesaverQualification != null) {
      if (teamCaptain!.lifesaverQualification!) {
        htmlInput =
            customReplace(htmlInput, uncheckYes, 1 - totalYesPos, checkedYes);
        totalYesPos += 1;
      } else {
        htmlInput =
            customReplace(htmlInput, uncheckNo, 1 - totalNoPos, checkedNo);
        totalNoPos += 1;
      }
    }

    //5
    if (withLifesaver != null) {
      if (!withLifesaver) {
        htmlInput =
            customReplace(htmlInput, uncheckNo, 2 - totalNoPos, checkedNo);
        totalNoPos += 1;
      } else {
        htmlInput =
            customReplace(htmlInput, uncheckYes, 2 - totalYesPos, checkedYes);
        totalYesPos += 1;
      }
    }

    //6
    htmlInput = htmlInput.replaceFirst('TeamTEL', team?.tel ?? '');

    //7
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAddress', report.sickInjuredPersonAddress ?? '');
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
            ? report.sickInjuredPersonBirthDate!.year.toString()
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
    List<String?> SickInjuredPersonTELs =
        split4CharPhone(report.sickInjuredPersonTel?.toString().trim() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELFirst',
        SickInjuredPersonTELs[0]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELMiddle',
        SickInjuredPersonTELs[1]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTELLast', SickInjuredPersonTELs[2]?.toString() ?? '');

    //14
    List<String?> SickInjuredPersonFamilyTELs = split4CharPhone(
        report.sickInjuredPersonFamilyTel?.toString().trim() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELFirst',
        SickInjuredPersonFamilyTELs[0]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELMiddle',
        SickInjuredPersonFamilyTELs[1]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELLast',
        SickInjuredPersonFamilyTELs[2]?.toString() ?? '');

    //15
    if (report.sickInjuredPersonMedicalHistory == null) {
      htmlInput =
          customReplace(htmlInput, uncheckNo, 3 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 3 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //16
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicalHistroy',
        report.sickInjuredPersonMedicalHistory ?? '');

    //17
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonHistoryHospital',
        report.sickInjuredPersonHistoryHospital ?? '');

    //18
    if (report.sickInjuredPersonKakaritsuke == null) {
      htmlInput =
          customReplace(htmlInput, uncheckNo, 4 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 4 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //19
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonKakaritsuke',
        report.sickInjuredPersonKakaritsuke ?? '');

    //20
    if (report.sickInjuredPersonMedication == '000') {
      htmlInput =
          customReplace(htmlInput, uncheckNo, 5 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else if (report.sickInjuredPersonMedication == '001') {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 5 - totalYesPos, checkedYes);
      totalYesPos += 1;
    } else if (report.sickInjuredPersonMedication == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon手帳', '$checkIcon手帳');
    }

    //21
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicationDetail',
        report.sickInjuredPersonMedicationDetail ?? '');

    //22
    if (report.sickInjuredPersonAllergy == null) {
      htmlInput =
          customReplace(htmlInput, uncheckNo, 6 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput =
          customReplace(htmlInput, uncheckYes, 6 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //23
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAllergy', report.sickInjuredPersonAllergy ?? '');

    //24
    if (report.typeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon急病', '$checkIcon急病');
    } else if (report.typeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon交通', '$checkIcon交通');
    } else if (report.typeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon一般', '$checkIcon一般');
    } else if (report.typeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon労災', '$checkIcon労災');
    } else if (report.typeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon自損', '$checkIcon自損');
    } else if (report.typeOfAccident == '005') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon運動', '$checkIcon運動');
    } else if (report.typeOfAccident == '006') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon転院', '$checkIcon転院');
    } else if (report.typeOfAccident == '007') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconその他', '$checkIconその他');
    }

    //25
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceYear',
        report.dateOfOccurrence?.year != null
            ? report.dateOfOccurrence!.year.toString()
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
    htmlInput =
        htmlInput.replaceFirst('PlaceOfIncident', report.placeOfIncident ?? '');

    //27
    htmlInput =
        htmlInput.replaceFirst('AccidentSummary', report.accidentSummary ?? '');

    //28
    if (report.adl == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon自立', '$checkIcon自立');
    } else if (report.adl == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon全介助', '$checkIcon全介助');
    } else if (report.adl == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon部分介助', '$checkIcon部分介助');
    }

    //29
    htmlInput = htmlInput.replaceFirst('SenseTime',
        '${report.senseTime?.hour ?? ''} ${report.senseTime?.minute ?? ''}');
    //30
    htmlInput = htmlInput.replaceFirst('CommandTime',
        '${report.commandTime?.hour ?? ''} ${report.commandTime?.minute ?? ''}');
    //31
    htmlInput = htmlInput.replaceFirst('AttendanceTime',
        '${report.attendanceTime?.hour ?? ''} ${report.attendanceTime?.minute ?? ''}');
    //32
    htmlInput = htmlInput.replaceFirst('On-siteArrivalTime',
        '${report.onSiteArrivalTime?.hour ?? ''} ${report.onSiteArrivalTime?.minute ?? ''}');
    //33
    htmlInput = htmlInput.replaceFirst('ContactTime',
        '${report.contactTime?.hour ?? ''} ${report.contactTime?.minute ?? ''}');
    //34
    htmlInput = htmlInput.replaceFirst('In-vehicleTime',
        '${report.inVehicleTime?.hour ?? ''} ${report.inVehicleTime?.minute ?? ''}');
    //35
    htmlInput = htmlInput.replaceFirst('StartOfTransportTime',
        '${report.startOfTransportTime?.hour ?? ''} ${report.startOfTransportTime?.minute ?? ''}');
    //36
    htmlInput = htmlInput.replaceFirst('HospitalArrivalTime',
        '${report.hospitalArrivalTime?.hour ?? ''} ${report.hospitalArrivalTime?.minute ?? ''}');
    //37
    htmlInput = htmlInput.replaceFirst('FamilyContactTime',
        '${report.familyContactTime?.hour ?? ''} ${report.familyContactTime?.minute ?? ''}');
    //38
    htmlInput = htmlInput.replaceFirst('PoliceContactTime',
        '${report.policeContactTime?.hour ?? ''} ${report.policeContactTime?.minute ?? ''}');

    //39
    if (report.typeOfAccident == '000') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconシートベルト', '$checkIconシートベルト');
    } else if (report.typeOfAccident == '001') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconエアバック', '$checkIconエアバック');
    } else if (report.typeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon不明', '$checkIcon不明');
    } else if (report.typeOfAccident == '003') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconチャイルドシート', '$checkIconチャイルドシート');
    } else if (report.typeOfAccident == '004') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconヘルメット', '$checkIconヘルメット');
    }

    //40
    if (report.witnesses != null && !report.witnesses!) {
      htmlInput = customReplace(
          htmlInput, '$uncheckIcon無', 7 - totalNoPos, '$checkIcon無');
    } else if (report.witnesses != null && report.witnesses!) {
      htmlInput = customReplace(
          htmlInput, '$uncheckIcon有', 7 - totalYesPos, '$checkIcon有');
    }

    //41
    htmlInput = htmlInput.replaceFirst('BystanderCPR',
        '${report.bystanderCpr?.hour ?? ''} ${report.bystanderCpr?.minute ?? ''}');

    //42
    htmlInput =
        htmlInput.replaceFirst('VerbalGuidance', report.verbalGuidance ?? '');

    //43-61
    htmlInput = handleDatLayout578(htmlInput);

    //62
    if (report.securingAirway != null) {
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
        '${report.o2AdministrationTime?.hour ?? ''} ${report.o2AdministrationTime?.minute ?? ''}');

    //72
    if (report.spinalCordMovementLimitation != null) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　脊髄運動制限', '$checkIcon　脊髄運動制限');
    }

    //73
    if (report.spinalCordMovementLimitation == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon頸椎のみ', '$checkIcon頸椎のみ');
    } else if (report.spinalCordMovementLimitation == '001') {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIconバックボード', '$checkIconバックボード');
    }

    //74
    if (report.hemostaticTreatment != null && report.hemostaticTreatment!) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　止血措置', '$checkIcon　止血措置');
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
    htmlInput = htmlInput.replaceFirst('Other', report.other?.toString() ?? '');

    //80
    if (report.bsMeasurement1 != null) {
      htmlInput =
          htmlInput.replaceFirst('$uncheckIcon　BS測定', '$checkIcon　BS測定');
    }

    //81
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurement1', report.bsMeasurement1?.toString() ?? '');

    //82
    htmlInput = htmlInput.replaceFirst('BSMeasurementTime1',
        '${report.bsMeasurementTime1?.hour ?? ''} ${report.bsMeasurementTime1?.minute ?? ''}');

    //83
    htmlInput = htmlInput.replaceFirst(
        'PunctureSite1', report.punctureSite1?.toString() ?? '');

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
        '${report.bsMeasurementTime2?.hour ?? ''} ${report.bsMeasurementTime2?.minute ?? ''}');

    //87
    htmlInput = htmlInput.replaceFirst(
        'PunctureSite2', report.punctureSite2?.toString() ?? '');

    return htmlInput;
  }

  String handleDatLayout578(String htmlInput) {
    final Report report = _reportStore.selectingReport!;
    var totalYesDotNoPos = 0;
    var totalYesUrineFecesNoPos = 0;
    var totalYesSpaceNoPos = 0;
    String defaultIncontinenceStr = '有（　尿　　便　）　無';
    for (var i = 0; i < 3; i++) {
      //43
      htmlInput = htmlInput.replaceFirst('ObservationTime${i + 1}',
          '${report.observationTime?[i]?.hour ?? ''} ${report.observationTime?[i]?.minute ?? ''}');
      //44
      htmlInput = htmlInput.replaceFirst('JCS${i + 1}', report.jcs?[i] ?? '');
      //45
      htmlInput = htmlInput.replaceFirst(
          'GCS_E${i + 1}', report.gcsETypes[i]?.value ?? '');
      htmlInput = htmlInput.replaceFirst(
          'GCS_V${i + 1}', report.gcsVTypes[i]?.value ?? '');
      htmlInput = htmlInput.replaceFirst(
          'GCS_M${i + 1}', report.gcsMTypes[i]?.value ?? '');
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
      if (report.lightReflexRight
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          !report.lightReflexRight![i]!) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            1 + 2 * i - totalYesDotNoPos,
            '有・<span class="text-circle">無</span>');
        totalYesDotNoPos += 1;
      } else if (report.lightReflexRight
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          report.lightReflexRight![i]!) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            1 + 2 * i - totalYesDotNoPos,
            '<span class="text-circle">有</span>・無');
        totalYesDotNoPos += 1;
      }
      //55
      if (report.lightReflexLeft
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          !report.lightReflexLeft![i]!) {
        htmlInput = customReplace(
            htmlInput,
            '有・無',
            2 + 2 * i - totalYesDotNoPos,
            '有・<span class="text-circle">無</span>');
        totalYesDotNoPos += 1;
      } else if (report.lightReflexLeft
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          report.lightReflexLeft![i]!) {
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
      htmlInput = htmlInput.replaceFirst(
          'Hemorrhage${i + 1}',
          report.hemorrhage
                  ?.firstWhereIndexedOrNull((index, element) => index == i)
                  ?.toString() ??
              '');
      //59
      int index001 = report.incontinence?.indexOf("001") ?? -1;
      int index002 = report.incontinence?.indexOf("002") ?? -1;
      int index003 = report.incontinence?.indexOf("003") ?? -1;
      if (index001 >= 0 && index003 >= 0) report.incontinence?[index001] = '';
      if (index002 >= 0 && index003 >= 0) report.incontinence?[index002] = '';
      String incontinenceStr = defaultIncontinenceStr;
      for (String? incon in report.incontinence?.toList() ?? []) {
        if (incon == '000') {
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
      }
      if (incontinenceStr != defaultIncontinenceStr) {
        htmlInput = customReplace(htmlInput, defaultIncontinenceStr,
            i + 1 - totalYesUrineFecesNoPos, incontinenceStr);
        totalYesUrineFecesNoPos += 1;
      }

      //60
      if (report.vomiting
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          !report.vomiting![i]!) {
        htmlInput = customReplace(htmlInput, '有　　無', i + 1 - totalYesSpaceNoPos,
            '<span class="text-circle">有</span>　　無');
        totalYesSpaceNoPos += 1;
      } else if (report.vomiting
                  ?.firstWhereIndexedOrNull((index, element) => index == i) !=
              null &&
          report.vomiting![i]!) {
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title:
          Text(reportType == ReportType.certificate ? '傷病者輸送証' : '救急業務実施報告書'),
      actions: _buildActions(),
      centerTitle: true,
      leading: _buildBackButton(),
      leadingWidth: 100,
    );
  }

  List<Widget> _buildActions() {
    return [
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 0, child: Text('送信・印刷'.i18n())),
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
          }
        },
      )
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back),
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        return _file != null
            ? PdfPreview(
                useActions: false,
                build: (format) {
                  return _file!.readAsBytes();
                },
              )
            : const CustomProgressIndicatorWidget();
      },
    );
  }
}
