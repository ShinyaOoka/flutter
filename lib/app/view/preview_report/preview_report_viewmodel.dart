import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../../di/injection.dart';
import '../../model/dt_report.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class PreviewReportViewModel extends BaseViewModel {
  late String assetFile;
  late String pdfName = '';
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  DBHelper dbHelper = getIt<DBHelper>();

  List<dynamic> databaseList = [];
  List<DTReport> dtReports = [];

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void openSendReport() async {
    _navigationService.pushScreenWithFade(SendReportPage());
  }

  void openEditReport() async {
    _navigationService.pushScreenWithFade(EditReportPage());
  }

  PreviewReportViewModel(this._dataRepo, this.assetFile, this.pdfName);

  String generatedPdfFilePath = '';

  Future<void> initData() async {
    await getReports();
    generatedPdfFilePath = await generateExampleDocument(assetFile ?? '');
    notifyListeners();
  }

  Future<String> generateExampleDocument(String assetFile) async {
    var fileHtmlContents = await rootBundle.loadString(assetFile);

    //format data from db to html file
    fileHtmlContents =
        await fetchDataToReportForm(dtReports[0], fileHtmlContents);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        fileHtmlContents, targetPath, pdfFileName);
    return generatedPdfFile.path;
  }

  Future<void> getReports() async {
    dtReports = await dbHelper.getAllReport() ?? [];
    notifyListeners();
  }

  String fetchDataToReportForm(DTReport dtReport, String htmlInput) {
    var totalYesPos = 0;
    var totalNoPos = 0;
    var totalYesDotNoPos = 0;
    var totalYesUrineFecesNoPos = 0;
    var totalYesSpaceNoPos = 0;

    //replace □ => <span class="square"></span>
    htmlInput = htmlInput.replaceAll('□', '<span class="square"></span>');

    //add style
    htmlInput = htmlInput.replaceAll('</style>', styleCSSMore + '</style>');

    //fill yyyy mm dd
    var y = DateFormat.y().format(DateTime.now());
    var m = DateFormat.M().format(DateTime.now());
    var d = DateFormat.d().format(DateTime.now());
    //1
    htmlInput = htmlInput
        .replaceFirst('YYYY', y)
        .replaceFirst('MM', m)
        .replaceFirst('DD', d);
    //2
    htmlInput = htmlInput.replaceFirst('TeamName', dtReport.TeamName ?? '');
    //3
    htmlInput = htmlInput.replaceFirst(
        'TeamCaptainName', dtReport.TeamCaptainName ?? '');
    //4
    if (dtReport.LifesaverQualification == 1) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 1 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 1 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    }

    //5
    if (dtReport.WithLifeSavers == 1) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 2 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 2 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    }

    //6
    htmlInput = htmlInput.replaceFirst('TeamTEL', dtReport.TeamTEL ?? '');

    //7
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAddress', dtReport.SickInjuredPersonAddress ?? '');
    //8
    if (dtReport.SickInjuredPersonGender == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　男', checkIcon + '　男');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　女', checkIcon + '　女');
    }

    //9
    var SickInjuredPersonBirthDateYear = DateFormat.y().format(
        Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate,
            format: yyyy_MM_dd_));
    var SickInjuredPersonBirthDateMonth = DateFormat.M().format(
        Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate,
            format: yyyy_MM_dd_));
    var SickInjuredPersonBirthDateDay = DateFormat.d().format(
        Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate,
            format: yyyy_MM_dd_));
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateYear',
        SickInjuredPersonBirthDateYear.toString());
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateMonth',
        SickInjuredPersonBirthDateMonth.toString());
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateDay',
        SickInjuredPersonBirthDateDay.toString());

    //10
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAge',
        Utils.calculateAge(Utils.stringToDateTime(
                dtReport.SickInjuredPersonBirthDate,
                format: yyyy_MM_dd_))
            .toString());

    //11
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonKANA', dtReport.SickInjuredPersonKANA ?? '');

    //12
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonName', dtReport.SickInjuredPersonName ?? '');

    //13
    List<String> SickInjuredPersonTELs =
        Utils.split4CharPhone(dtReport.SickInjuredPersonTEL.toString().trim());
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTELFirst', SickInjuredPersonTELs[0].toString());
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTELMiddle', SickInjuredPersonTELs[1].toString());
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonTELLast', SickInjuredPersonTELs[2].toString());

    //14
    List<String> SickInjuredPersonFamilyTELs = Utils.split4CharPhone(
        dtReport.SickInjuredPersonFamilyTEL.toString().trim());
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELFirst',
        SickInjuredPersonFamilyTELs[0].toString());
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELMiddle',
        SickInjuredPersonFamilyTELs[1].toString());
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELLast',
        SickInjuredPersonFamilyTELs[2].toString());

    //15
    if (dtReport.SickInjuredPersonMedicalHistroy == null) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 3 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 3 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    }

    //16
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicalHistroy',
        dtReport.SickInjuredPersonMedicalHistroy ?? '');

    //17
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonHistoryHospital',
        dtReport.SickInjuredPersonHistoryHospital ?? '');

    //18
    if (dtReport.SickInjuredPersonKakaritsuke == null) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 4 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 4 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    }

    //19
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonKakaritsuke',
        dtReport.SickInjuredPersonKakaritsuke ?? '');

    //20
    if (dtReport.SickInjuredPersonMedication == '無') {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 5 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    } else if (dtReport.SickInjuredPersonMedication == '有') {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 5 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>手帳', checkIcon + '手帳');
    }

    //21
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicationDetail',
        dtReport.SickInjuredPersonMedicationDetail ?? '');

    //22
    if (dtReport.SickInjuredPersonAllergy == null) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 6 - totalNoPos, checkIcon + '無');
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 6 - totalYesPos, checkIcon + '有');
      totalYesPos += 1;
    }

    //23
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAllergy', dtReport.SickInjuredPersonAllergy ?? '');

    //24
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>急病', checkIcon + '急病');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>交通', checkIcon + '交通');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>一般', checkIcon + '一般');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>労災', checkIcon + '労災');
    } else if (dtReport.TypeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>自損', checkIcon + '自損');
    } else if (dtReport.TypeOfAccident == '005') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>運動', checkIcon + '運動');
    } else if (dtReport.TypeOfAccident == '006') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>転院', checkIcon + '転院');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>その他', checkIcon + 'その他');
    }

    //25
    var DateOfOccurrenceYear = DateFormat.y().format(
        Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var DateOfOccurrenceMonth = DateFormat.M().format(
        Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var DateOfOccurrenceDay = DateFormat.d().format(
        Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var TimeOfOccurrenceHour = DateFormat.j().format(
        Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: hh_mm_));
    var TimeOfOccurrenceMinute = DateFormat.m().format(
        Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: hh_mm_));
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceYear', DateOfOccurrenceYear.toString());
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceMonth', DateOfOccurrenceMonth.toString());
    htmlInput = htmlInput.replaceFirst(
        'DateOfOccurrenceDay', DateOfOccurrenceDay.toString());
    htmlInput = htmlInput.replaceFirst(
        'TimeOfOccurrenceHour', TimeOfOccurrenceHour.toString());
    htmlInput = htmlInput.replaceFirst(
        'TimeOfOccurrenceMinute', TimeOfOccurrenceMinute.toString());

    //26
    htmlInput = htmlInput.replaceFirst(
        'PlaceOfIncident', dtReport.PlaceOfIncident ?? '');

    //27
    htmlInput = htmlInput.replaceFirst(
        'AccidentSummary', dtReport.AccidentSummary ?? '');

    //28
    if (dtReport.ADL == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>自立', checkIcon + '自立');
    } else if (dtReport.ADL == '001') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>全介助', checkIcon + '全介助');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>部分介助', checkIcon + '部分介助');
    }

    //"06時30分",

    //29
    htmlInput = htmlInput.replaceFirst(
        'SenseTime',
        Utils.formatToOtherFormat(
            dtReport.SenseTime ?? '', hh_mm_, hh_space_mm));
    //30
    htmlInput = htmlInput.replaceFirst(
        'CommandTime',
        Utils.formatToOtherFormat(
            dtReport.CommandTime ?? '', hh_mm_, hh_space_mm));
    //31
    htmlInput = htmlInput.replaceFirst(
        'AttendanceTime',
        Utils.formatToOtherFormat(
            dtReport.AttendanceTime ?? '', hh_mm_, hh_space_mm));
    //32
    htmlInput = htmlInput.replaceFirst(
        'On-siteArrivalTime',
        Utils.formatToOtherFormat(
            dtReport.OnsiteArrivalTime ?? '', hh_mm_, hh_space_mm));
    //33
    htmlInput = htmlInput.replaceFirst(
        'ContactTime',
        Utils.formatToOtherFormat(
            dtReport.ContactTime ?? '', hh_mm_, hh_space_mm));
    //34
    htmlInput = htmlInput.replaceFirst(
        'In-vehicleTime',
        Utils.formatToOtherFormat(
            dtReport.InvehicleTime ?? '', hh_mm_, hh_space_mm));
    //35
    htmlInput = htmlInput.replaceFirst(
        'StartOfTransportTime',
        Utils.formatToOtherFormat(
            dtReport.StartOfTransportTime ?? '', hh_mm_, hh_space_mm));
    //36
    htmlInput = htmlInput.replaceFirst(
        'HospitalArrivalTime',
        Utils.formatToOtherFormat(
            dtReport.HospitalArrivalTime ?? '', hh_mm_, hh_space_mm));
    //37
    htmlInput = htmlInput.replaceFirst(
        'FamilyContactTime',
        Utils.formatToOtherFormat(
            dtReport.FamilyContactTime ?? '', hh_mm_, hh_space_mm));
    //38
    htmlInput = htmlInput.replaceFirst(
        'PoliceContactTime',
        Utils.formatToOtherFormat(
            dtReport.PoliceContactTime ?? '', hh_mm_, hh_space_mm));

    //39
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>シートベルト', checkIcon + 'シートベルト');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>エアバック', checkIcon + 'エアバック');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>不明', checkIcon + '不明');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>チャイルドシート', checkIcon + 'チャイルドシート');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>ヘルメット', checkIcon + 'ヘルメット');
    }

    //40
    if (dtReport.Witnesses == 0) {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>無', 7 - totalNoPos, checkIcon + '無');
    } else {
      htmlInput = Utils.customReplace(htmlInput,
          '<span class="square"></span>有', 7 - totalYesPos, checkIcon + '有');
    }

    //41
    htmlInput = htmlInput.replaceFirst(
        'BystanderCPR',
        Utils.formatToOtherFormat(
            dtReport.BystanderCPR ?? '', hh_mm_, hh_space_mm));

    //42
    htmlInput =
        htmlInput.replaceFirst('VerbalGuidance', dtReport.VerbalGuidance ?? '');

    //layout 5
    //43
    htmlInput = htmlInput.replaceFirst(
        'ObservationTime1',
        Utils.formatToOtherFormat(
            dtReport.ObservationTime?[0] ?? '', hh_mm_, hh_space_mm));
    htmlInput = htmlInput.replaceFirst(
        'ObservationTime2',
        Utils.formatToOtherFormat(
            dtReport.ObservationTime?[1] ?? '', hh_mm_, hh_space_mm));
    htmlInput = htmlInput.replaceFirst(
        'ObservationTime3',
        Utils.formatToOtherFormat(
            dtReport.ObservationTime?[2] ?? '', hh_mm_, hh_space_mm));

    //44
    htmlInput = htmlInput.replaceFirst('JCS1', dtReport.JCS?[0] ?? '');
    htmlInput = htmlInput.replaceFirst('JCS2', dtReport.JCS?[1] ?? '');
    htmlInput = htmlInput.replaceFirst('JCS3', dtReport.JCS?[2] ?? '');

    //45
    htmlInput = htmlInput.replaceFirst('GCS_E1', dtReport.GCSE?[0] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_E2', dtReport.GCSE?[1] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_E3', dtReport.GCSE?[2] ?? '');

    htmlInput = htmlInput.replaceFirst('GCS_V1', dtReport.GCSV?[0] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_V2', dtReport.GCSV?[1] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_V3', dtReport.GCSV?[2] ?? '');

    htmlInput = htmlInput.replaceFirst('GCS_M1', dtReport.GCSM?[0] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_M2', dtReport.GCSM?[1] ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_M3', dtReport.GCSM?[2] ?? '');

    //46
    htmlInput =
        htmlInput.replaceFirst('Respiration1', dtReport.Respiration?[0].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Respiration2', dtReport.Respiration?[1].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Respiration3', dtReport.Respiration?[2].toString() ?? '');

    //47
    htmlInput =
        htmlInput.replaceFirst('Pulse1', dtReport.Pulse?[0].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Pulse2', dtReport.Pulse?[1].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Pulse3', dtReport.Pulse?[2].toString() ?? '');

    //48
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_High1', dtReport.BloodPressureHigh?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_High2', dtReport.BloodPressureHigh?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_High3', dtReport.BloodPressureHigh?[2].toString() ?? '');

    //49
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_Low1', dtReport.BloodPressureLow?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_Low2', dtReport.BloodPressureLow?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BloodPressure_Low3', dtReport.BloodPressureLow?[2].toString() ?? '');

    //50
    htmlInput = htmlInput.replaceFirst(
        'SpO2Percent1', dtReport.SpO2Percent?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SpO2Percent2', dtReport.SpO2Percent?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SpO2Percent3', dtReport.SpO2Percent?[2].toString() ?? '');

    //51
    htmlInput = htmlInput.replaceFirst(
        'SpO2Liter1', dtReport.SpO2Liter?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SpO2Liter2', dtReport.SpO2Liter?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'SpO2Liter3', dtReport.SpO2Liter?[2].toString() ?? '');

    //52
    htmlInput = htmlInput.replaceFirst(
        'PupilRight1', dtReport.PupilRight?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'PupilRight2', dtReport.PupilRight?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'PupilRight3', dtReport.PupilRight?[2].toString() ?? '');

    //53
    htmlInput = htmlInput.replaceFirst(
        'PupilLeft1', dtReport.PupilLeft?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'PupilLeft2', dtReport.PupilLeft?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'PupilLeft3', dtReport.PupilLeft?[2].toString() ?? '');

    //54
    //1
    if (dtReport.LightReflexRight?[0] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 1 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 1 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }

    //55
    //1
    if (dtReport.PhotoreflexLeft?[0] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 2 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 2 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }

    //54
    //2
    if (dtReport.LightReflexRight?[1] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 3 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 3 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }
    //55
    //2
    if (dtReport.PhotoreflexLeft?[1] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 4 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 4 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }

    //54
    //3
    if (dtReport.LightReflexRight?[2] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 5 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 5 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }

    //55
    //3
    if (dtReport.PhotoreflexLeft?[2] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 6 - totalYesDotNoPos,
          '有・<span class="text-circle">無</span>');
      totalYesDotNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有・無', 6 - totalYesDotNoPos,
          '<span class="text-circle">有</span>・無');
      totalYesDotNoPos += 1;
    }

    //56
    htmlInput = htmlInput.replaceFirst(
        'BodyTemperature1', dtReport.BodyTemperature?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BodyTemperature2', dtReport.BodyTemperature?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'BodyTemperature3', dtReport.BodyTemperature?[2].toString() ?? '');

    // //57
    if (dtReport.FacialFeatures?[0] == '000') {
      htmlInput = Utils.customReplace(
          htmlInput, '正常', 1, '<span class="text-circle">正常</span>');
    } else if (dtReport.FacialFeatures?[0] == '001') {
      htmlInput = Utils.customReplace(
          htmlInput, '紅潮', 1, '<span class="text-circle">紅潮</span>');
    } else if (dtReport.FacialFeatures?[0] == '002') {
      htmlInput = Utils.customReplace(
          htmlInput, '蒼白', 1, '<span class="text-circle">蒼白</span>');
    } else if (dtReport.FacialFeatures?[0] == '003') {
      htmlInput = Utils.customReplace(
          htmlInput, 'チアノーゼ', 1, '<span class="text-circle">チアノーゼ</span>');
    } else if (dtReport.FacialFeatures?[0] == '004') {
      htmlInput = Utils.customReplace(
          htmlInput, '発汗', 1, '<span class="text-circle">発汗</span>');
    } else {
      htmlInput = Utils.customReplace(
          htmlInput, '苦悶', 1, '<span class="text-circle">苦悶</span>');
    }

    if (dtReport.FacialFeatures?[1] == '000') {
      htmlInput = Utils.customReplace(
          htmlInput, '正常', 2, '<span class="text-circle">正常</span>');
    } else if (dtReport.FacialFeatures?[1] == '001') {
      htmlInput = Utils.customReplace(
          htmlInput, '紅潮', 2, '<span class="text-circle">紅潮</span>');
    } else if (dtReport.FacialFeatures?[1] == '002') {
      htmlInput = Utils.customReplace(
          htmlInput, '蒼白', 2, '<span class="text-circle">蒼白</span>');
    } else if (dtReport.FacialFeatures?[1] == '003') {
      htmlInput = Utils.customReplace(
          htmlInput, 'チアノーゼ', 2, '<span class="text-circle">チアノーゼ</span>');
    } else if (dtReport.FacialFeatures?[1] == '004') {
      htmlInput = Utils.customReplace(
          htmlInput, '発汗', 2, '<span class="text-circle">発汗</span>');
    } else {
      htmlInput = Utils.customReplace(
          htmlInput, '苦悶', 2, '<span class="text-circle">苦悶</span>');
    }

    if (dtReport.FacialFeatures?[2] == '000') {
      htmlInput = Utils.customReplace(
          htmlInput, '正常', 3, '<span class="text-circle">正常</span>');
    } else if (dtReport.FacialFeatures?[2] == '001') {
      htmlInput = Utils.customReplace(
          htmlInput, '紅潮', 3, '<span class="text-circle">紅潮</span>');
    } else if (dtReport.FacialFeatures?[2] == '002') {
      htmlInput = Utils.customReplace(
          htmlInput, '蒼白', 3, '<span class="text-circle">蒼白</span>');
    } else if (dtReport.FacialFeatures?[2] == '003') {
      htmlInput = Utils.customReplace(
          htmlInput, 'チアノーゼ', 3, '<span class="text-circle">チアノーゼ</span>');
    } else if (dtReport.FacialFeatures?[2] == '004') {
      htmlInput = Utils.customReplace(
          htmlInput, '発汗', 3, '<span class="text-circle">発汗</span>');
    } else {
      htmlInput = Utils.customReplace(
          htmlInput, '苦悶', 3, '<span class="text-circle">苦悶</span>');
    }

    //58
    htmlInput = htmlInput.replaceFirst(
        'Hemorrhage1', dtReport.Hemorrhage?[0].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'Hemorrhage2', dtReport.Hemorrhage?[1].toString() ?? '');
    htmlInput = htmlInput.replaceFirst(
        'Hemorrhage3', dtReport.Hemorrhage?[2].toString() ?? '');

    //59
    //1
    List<String> incontinences1 = dtReport.Incontinence?[0].split(comma) ?? [];
    List<String> incontinences2 = dtReport.Incontinence?[1].split(comma) ?? [];
    List<String> incontinences3 = dtReport.Incontinence?[2].split(comma) ?? [];
    for(String i in incontinences1){
      if (i == '000') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　便　）　<span class="text-circle">無</span>');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '001') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　便　）　無');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '002') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      } else {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      }
    }


    for(String i in incontinences2){
      if (i == '000') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　便　）　<span class="text-circle">無</span>');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '001') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　便　）　無');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '002') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      } else {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      }
    }

    for(String i in incontinences3){
      if (i == '000') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　便　）　<span class="text-circle">無</span>');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '001') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　便　）　無');
        totalYesUrineFecesNoPos += 1;
      } else if (i == '002') {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　尿　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      } else {
        htmlInput = Utils.customReplace(
            htmlInput,
            '有（　尿　　便　）　無',
            1 - totalYesUrineFecesNoPos,
            '有（　<span class="text-circle">尿</span>　　<span class="text-circle">便</span>　）　無');
        totalYesUrineFecesNoPos += 1;
      }
    }


    //60
    //1
    if (dtReport.Vomiting?[0] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 1 - totalYesSpaceNoPos,
          '<span class="text-circle">有</span>　　無');
      totalYesSpaceNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 1 - totalYesSpaceNoPos,
          '有　　<span class="text-circle">無</span>');
      totalYesSpaceNoPos += 1;
    }
    if (dtReport.Vomiting?[1] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 2 - totalYesSpaceNoPos,
          '<span class="text-circle">有</span>　　無');
      totalYesSpaceNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 2 - totalYesSpaceNoPos,
          '有　　<span class="text-circle">無</span>');
      totalYesSpaceNoPos += 1;
    }
    if (dtReport.Vomiting?[2] == 0) {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 3 - totalYesSpaceNoPos,
          '<span class="text-circle">有</span>　　無');
      totalYesSpaceNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, '有　　無', 3 - totalYesSpaceNoPos,
          '有　　<span class="text-circle">無</span>');
      totalYesSpaceNoPos += 1;
    }

    //61
    htmlInput =
        htmlInput.replaceFirst('Extremities1', dtReport.Extremities?[0].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Extremities2', dtReport.Extremities?[1].toString() ?? '');
    htmlInput =
        htmlInput.replaceFirst('Extremities3', dtReport.Extremities?[2].toString() ?? '');

    //62
    if (dtReport.SecuringAirway != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　気道確保', checkIcon + '　気道確保');
    }

    //63
    if (dtReport.SecuringAirway == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>用手', checkIcon + '用手');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>エアウェイ', checkIcon + 'エアウェイ');
    }

    //64
    if (dtReport.ForeignBodyRemoval == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　異物除去', checkIcon + '　異物除去');
    }

    //65
    if (dtReport.Suction == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　吸引', checkIcon + '　吸引');
    }

    //66
    if (dtReport.ArtificialRespiration == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　人口呼吸', checkIcon + '　人口呼吸');
    }

    //67
    if (dtReport.ChestCompressions == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　胸骨圧迫', checkIcon + '　胸骨圧迫');
    }

    //68
    if (dtReport.ECGMonitor == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　ECGモニター', checkIcon + '　ECGモニター');
    }

    //69
    if (dtReport.O2Administration != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　O2投与', checkIcon + '　O2投与');
    }

    //70
    htmlInput = htmlInput.replaceFirst(
        'O2Administration', dtReport.O2Administration.toString() ?? '');

    //71
    htmlInput = htmlInput.replaceFirst(
        'O2AdministrationTime',
        Utils.formatToOtherFormat(
            dtReport.O2AdministrationTime ?? '', hh_mm_, hh_space_mm));

    //72
    if (dtReport.SpinalCordMovementLimitation != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　脊髄運動制限', checkIcon + '　脊髄運動制限');
    }

    //73
    if (dtReport.SpinalCordMovementLimitation == '000') {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>頸椎のみ', checkIcon + '頸椎のみ');
    } else {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>バックボード', checkIcon + 'バックボード');
    }

    //74
    if (dtReport.HemostaticTreatment == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　止血措置', checkIcon + '　止血措置');
    }

    //75
    if (dtReport.AdductorFixation == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　副子固定', checkIcon + '　副子固定');
    }

    //76
    if (dtReport.Coating == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　被覆処置', checkIcon + '　被覆処置');
    }

    //77
    if (dtReport.BurnTreatment == 1) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　被覆処置', checkIcon + '　被覆処置');
    }

    //78
    if (dtReport.Other != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　その他', checkIcon + '　その他');
    }

    //79
    htmlInput =
        htmlInput.replaceFirst('Other', dtReport.Other.toString() ?? '');

    //80
    if (dtReport.BSMeasurement1 != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　BS測定', checkIcon + '　BS測定');
    }

    //81
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurement1', dtReport.BSMeasurement1.toString() ?? '');

    //82
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurementTime1',
        Utils.formatToOtherFormat(
            dtReport.BSMeasurementTime1 ?? '', hh_mm_, hh_space_mm));

    //83
    htmlInput = htmlInput.replaceFirst(
        'PunctureSite1', dtReport.PunctureSite1.toString() ?? '');

    //84
    if (dtReport.BSMeasurement2 != null) {
      htmlInput = htmlInput.replaceFirst(
          '<span class="square"></span>　BS測定', checkIcon + '　BS測定');
    }

    //85
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurement2', dtReport.BSMeasurement2.toString() ?? '');

    //86
    htmlInput = htmlInput.replaceFirst(
        'BSMeasurementTime2',
        Utils.formatToOtherFormat(
            dtReport.BSMeasurementTime2 ?? '', hh_mm_, hh_space_mm));

    //87
    htmlInput = htmlInput.replaceFirst(
        'PunctureSite2', dtReport.PunctureSite2.toString() ?? '');

    return htmlInput;
  }


}
