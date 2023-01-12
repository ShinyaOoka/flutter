import 'dart:async';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path/path.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:webcontent_converter/webcontent_converter.dart';

import '../../di/injection.dart';
import '../../model/dt_report.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class PreviewReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  DBHelper dbHelper = getIt<DBHelper>();
  late String assetFile;
  late String pdfName = '';
  final DTReport dtReport;
  String generatedPdfFilePath = '';

  List<dynamic?>? ObservationTimes, JCSs, GCSEs, GCSVs, GCSMs, Respirations, Pulses, BloodPressureHighs, BloodPressureLows, SpO2Percents, SpO2Liters, PupilRights, PupilLefts, LightReflexRights, PhotoreflexLefts, BodyTemperatures, FacialFeaturess, Hemorrhages, Incontinences, Vomitings, Extremitiess;

  PreviewReportViewModel(this._dataRepo, this.assetFile, this.pdfName, this.dtReport);

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

  Future<void> initData() async {
    getListDataLayout578();
    generatedPdfFilePath = await generateExampleDocument(assetFile ?? '');
    notifyListeners();
  }

  Future<String> generateExampleDocument(String assetFile) async {
    var fileHtmlContents = await rootBundle.loadString(assetFile);
    //format data from db to html file
    fileHtmlContents = await fetchDataToReportForm(dtReport, fileHtmlContents);
    //get pdf file
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var savedPath = join(appDocDir.path, pdfFile);
    /*var pdfPath = await WebcontentConverter.contentToPDF(
      content: fileHtmlContents,
      savedPath: savedPath,
      format: PaperFormat.a4,
      margins: PdfMargins.px(top: 35, bottom: 35, right: 35, left: 35),
    );*/
    final targetPath = appDocDir.path;
    final targetFileName = "example-pdf";
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(fileHtmlContents, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;

    return generatedPdfFilePath ?? '';
  }

  void getListDataLayout578() {
    ObservationTimes = Utils.exportDataFromDb(dtReport.ObservationTime);
    JCSs = Utils.exportDataFromDb(dtReport.JCS);
    GCSEs = Utils.exportDataFromDb(dtReport.GCSE);
    GCSVs = Utils.exportDataFromDb(dtReport.GCSV);
    GCSMs = Utils.exportDataFromDb(dtReport.GCSM);
    Respirations = Utils.exportDataFromDb(dtReport.Respiration);
    Pulses = Utils.exportDataFromDb(dtReport.Pulse);
    BloodPressureHighs = Utils.exportDataFromDb(dtReport.BloodPressureHigh);
    BloodPressureLows = Utils.exportDataFromDb(dtReport.BloodPressureLow);
    SpO2Percents = Utils.exportDataFromDb(dtReport.SpO2Percent);
    SpO2Liters = Utils.exportDataFromDb(dtReport.SpO2Liter);
    PupilRights = Utils.exportDataFromDb(dtReport.PupilRight);
    PupilLefts = Utils.exportDataFromDb(dtReport.PupilLeft);
    LightReflexRights = Utils.exportDataFromDb(dtReport.LightReflexRight);
    PhotoreflexLefts = Utils.exportDataFromDb(dtReport.PhotoreflexLeft);
    BodyTemperatures = Utils.exportDataFromDb(dtReport.BodyTemperature);
    FacialFeaturess = Utils.exportDataFromDb(dtReport.FacialFeatures);
    Hemorrhages = Utils.exportDataFromDb(dtReport.Hemorrhage);
    Incontinences = Utils.exportDataFromDb(dtReport.Incontinence);
    Vomitings = Utils.exportDataFromDb(dtReport.Vomiting);
    Extremitiess = Utils.exportDataFromDb(dtReport.Extremities);
  }

  String fetchDataToReportForm(DTReport dtReport, String htmlInput) {
    var totalYesPos = 0;
    var totalNoPos = 0;

    //replace □ => uncheckIcon style
    htmlInput = htmlInput.replaceAll('□', uncheckIcon);

    //increment border-width style: .5pt - 0.5pt
    htmlInput = htmlInput.replaceAll(dot5pt, zeroDot5pt);

    //add style
    htmlInput = htmlInput.replaceAll('</style>', '$styleCSSMore</style>');

    //add overflow hide in TeamName, TeamCaptainName, Other
    htmlInput = htmlInput.replaceFirst('\'>$TeamName', overflow + '\'>$TeamName');
    htmlInput = htmlInput.replaceFirst('\'>$TeamCaptainName', overflow + '\'>$TeamCaptainName');
    htmlInput = htmlInput.replaceFirst('>$Other', overflowStyle + '>$Other');

    //fill yyyy mm dd now
    var y = DateFormat.y().format(DateTime.now());
    var m = DateFormat.M().format(DateTime.now());
    var d = DateFormat.d().format(DateTime.now());
    //1
    htmlInput = htmlInput.replaceFirst('YYYY', y).replaceFirst('MM', m).replaceFirst('DD', d);
    //2
    htmlInput = htmlInput.replaceFirst(TeamName, dtReport.TeamName ?? '');
    //3
    htmlInput = htmlInput.replaceFirst(TeamCaptainName, dtReport.TeamCaptainName ?? '');
    //4
    if (dtReport.LifesaverQualification == 0) {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 1 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else if (dtReport.LifesaverQualification == 1) {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 1 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //5
    if (dtReport.WithLifeSavers == 0) {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 2 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else if (dtReport.WithLifeSavers == 1) {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 2 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //6
    htmlInput = htmlInput.replaceFirst(TeamTEL, dtReport.TeamTEL ?? '');

    //7
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonAddress, dtReport.SickInjuredPersonAddress ?? '');
    //8
    if (dtReport.SickInjuredPersonGender == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　男', '$checkIcon　男');
    } else if (dtReport.SickInjuredPersonGender == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　女', '$checkIcon　女');
    }

    //9
    dynamic? SickInjuredPersonBirthDateYear = dtReport.SickInjuredPersonBirthDate == null ? null :  DateFormat.y().format(Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate, format: yyyy_MM_dd_)!);
    dynamic? SickInjuredPersonBirthDateMonth = dtReport.SickInjuredPersonBirthDate == null ? null : DateFormat.M().format(Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate, format: yyyy_MM_dd_)!);
    dynamic? SickInjuredPersonBirthDateDay = dtReport.SickInjuredPersonBirthDate == null ? null : DateFormat.d().format(Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate, format: yyyy_MM_dd_)!);
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateYear', SickInjuredPersonBirthDateYear?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateMonth', SickInjuredPersonBirthDateMonth?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonBirthDateDay', SickInjuredPersonBirthDateDay?.toString() ?? '');

    //10
    var age = Utils.calculateAge(Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate, format: yyyy_MM_dd_), Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonAge, age > 0 ? age.toString() : '');

    //11
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonKANA, dtReport.SickInjuredPersonKANA ?? '');

    //12
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonName, dtReport.SickInjuredPersonName ?? '');

    //13
    List<String?> SickInjuredPersonTELs = Utils.split4CharPhone(dtReport.SickInjuredPersonTEL?.toString().trim() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELFirst', SickInjuredPersonTELs[0]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELMiddle', SickInjuredPersonTELs[1]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonTELLast', SickInjuredPersonTELs[2]?.toString() ?? '');

    //14
    List<String?> SickInjuredPersonFamilyTELs = Utils.split4CharPhone(dtReport.SickInjuredPersonFamilyTEL?.toString().trim() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELFirst', SickInjuredPersonFamilyTELs[0]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELMiddle', SickInjuredPersonFamilyTELs[1]?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonFamilyTELLast', SickInjuredPersonFamilyTELs[2]?.toString() ?? '');

    //15
    if (dtReport.SickInjuredPersonMedicalHistroy == null) {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 3 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 3 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //16
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonMedicalHistroy, dtReport.SickInjuredPersonMedicalHistroy ?? '');

    //17
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonHistoryHospital, dtReport.SickInjuredPersonHistoryHospital ?? '');

    //18
    if (dtReport.SickInjuredPersonKakaritsuke == null) {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 4 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 4 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //19
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonKakaritsuke, dtReport.SickInjuredPersonKakaritsuke ?? '');

    //20
    if (dtReport.SickInjuredPersonMedication == '000') {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 5 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else if (dtReport.SickInjuredPersonMedication == '001') {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 5 - totalYesPos, checkedYes);
      totalYesPos += 1;
    } else if (dtReport.SickInjuredPersonMedication == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon手帳', '$checkIcon手帳');
    }

    //21
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonMedicationDetail, dtReport.SickInjuredPersonMedicationDetail ?? '');

    //22
    if (dtReport.SickInjuredPersonAllergy == null) {
      htmlInput = Utils.customReplace(htmlInput, uncheckNo, 6 - totalNoPos, checkedNo);
      totalNoPos += 1;
    } else {
      htmlInput = Utils.customReplace(htmlInput, uncheckYes, 6 - totalYesPos, checkedYes);
      totalYesPos += 1;
    }

    //23
    htmlInput = htmlInput.replaceFirst(SickInjuredPersonAllergy, dtReport.SickInjuredPersonAllergy ?? '');

    //24
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon急病', '$checkIcon急病');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon交通', '$checkIcon交通');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon一般', '$checkIcon一般');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon労災', '$checkIcon労災');
    } else if (dtReport.TypeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon自損', '$checkIcon自損');
    } else if (dtReport.TypeOfAccident == '005') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon運動', '$checkIcon運動');
    } else if (dtReport.TypeOfAccident == '006') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon転院', '$checkIcon転院');
    } else if (dtReport.TypeOfAccident == '007') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconその他', '$checkIconその他');
    }

    //25
    dynamic? DateOfOccurrenceYear = dtReport.DateOfOccurrence == null ? null : DateFormat.y().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_)!);
    dynamic? DateOfOccurrenceMonth = dtReport.DateOfOccurrence == null ? null : DateFormat.M().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_)!);
    dynamic? DateOfOccurrenceDay = dtReport.DateOfOccurrence == null ? null : DateFormat.d().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_)!);
    dynamic? TimeOfOccurrenceHour = dtReport.TimeOfOccurrence == null ? null : DateFormat.j().format(Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: HH_mm_)!);
    dynamic? TimeOfOccurrenceMinute = dtReport.TimeOfOccurrence == null ? null : DateFormat.m().format(Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: HH_mm_)!);
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceYear', DateOfOccurrenceYear?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceMonth', DateOfOccurrenceMonth?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceDay', DateOfOccurrenceDay?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('TimeOfOccurrenceHour', TimeOfOccurrenceHour?.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('TimeOfOccurrenceMinute', TimeOfOccurrenceMinute?.toString() ?? '');

    //26
    htmlInput = htmlInput.replaceFirst(PlaceOfIncident, dtReport.PlaceOfIncident ?? '');

    //27
    htmlInput = htmlInput.replaceFirst(AccidentSummary, dtReport.AccidentSummary ?? '');

    //28
    if (dtReport.ADL == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon自立', '$checkIcon自立');
    } else if (dtReport.ADL == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon全介助', '$checkIcon全介助');
    } else if (dtReport.ADL == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon部分介助', '$checkIcon部分介助');
    }

    //29
    htmlInput = htmlInput.replaceFirst(SenseTime, Utils.formatToOtherFormat(dtReport.SenseTime ?? '', HH_mm_, HH_space_mm));
    //30
    htmlInput = htmlInput.replaceFirst(CommandTime, Utils.formatToOtherFormat(dtReport.CommandTime ?? '', HH_mm_, HH_space_mm));
    //31
    htmlInput = htmlInput.replaceFirst(AttendanceTime, Utils.formatToOtherFormat(dtReport.AttendanceTime ?? '', HH_mm_, HH_space_mm));
    //32
    htmlInput = htmlInput.replaceFirst('On-siteArrivalTime', Utils.formatToOtherFormat(dtReport.OnsiteArrivalTime ?? '', HH_mm_, HH_space_mm));
    //33
    htmlInput = htmlInput.replaceFirst(ContactTime, Utils.formatToOtherFormat(dtReport.ContactTime ?? '', HH_mm_, HH_space_mm));
    //34
    htmlInput = htmlInput.replaceFirst('In-vehicleTime', Utils.formatToOtherFormat(dtReport.InvehicleTime ?? '', HH_mm_, HH_space_mm));
    //35
    htmlInput = htmlInput.replaceFirst(StartOfTransportTime, Utils.formatToOtherFormat(dtReport.StartOfTransportTime ?? '', HH_mm_, HH_space_mm));
    //36
    htmlInput = htmlInput.replaceFirst(HospitalArrivalTime, Utils.formatToOtherFormat(dtReport.HospitalArrivalTime ?? '', HH_mm_, HH_space_mm));
    //37
    htmlInput = htmlInput.replaceFirst(FamilyContactTime, Utils.formatToOtherFormat(dtReport.FamilyContactTime ?? '', HH_mm_, HH_space_mm));
    //38
    htmlInput = htmlInput.replaceFirst(PoliceContactTime, Utils.formatToOtherFormat(dtReport.PoliceContactTime ?? '', HH_mm_, HH_space_mm));

    //39
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconシートベルト', '$checkIconシートベルト');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconエアバック', '$checkIconエアバック');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon不明', '$checkIcon不明');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconチャイルドシート', '$checkIconチャイルドシート');
    } else if (dtReport.TypeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconヘルメット', '$checkIconヘルメット');
    }

    //40
    if (dtReport.Witnesses == 0) {
      htmlInput = Utils.customReplace(htmlInput, '$uncheckIcon無', 7 - totalNoPos, '$checkIcon無');
    } else if (dtReport.Witnesses == 1) {
      htmlInput = Utils.customReplace(htmlInput, '$uncheckIcon有', 7 - totalYesPos, '$checkIcon有');
    }

    //41
    htmlInput = htmlInput.replaceFirst(BystanderCPR, Utils.formatToOtherFormat(dtReport.BystanderCPR ?? '', HH_mm_, HH_space_mm));

    //42
    htmlInput = htmlInput.replaceFirst(VerbalGuidance, dtReport.VerbalGuidance ?? '');

    //43-61
    htmlInput = handleDatLayout578(htmlInput);

    //62
    if (dtReport.SecuringAirway != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　気道確保', '$checkIcon　気道確保');
    }

    //63
    if (dtReport.SecuringAirway == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon用手', '$checkIcon用手');
    } else if (dtReport.SecuringAirway == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconエアウェイ', '$checkIconエアウェイ');
    }

    //64
    if (dtReport.ForeignBodyRemoval == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　異物除去', '$checkIcon　異物除去');
    }

    //65
    if (dtReport.Suction == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　吸引', '$checkIcon　吸引');
    }

    //66
    if (dtReport.ArtificialRespiration == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　人口呼吸', '$checkIcon　人口呼吸');
    }

    //67
    if (dtReport.ChestCompressions == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　胸骨圧迫', '$checkIcon　胸骨圧迫');
    }

    //68
    if (dtReport.ECGMonitor == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　ECGモニター', '$checkIcon　ECGモニター');
    }

    //69
    if (dtReport.O2Administration != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　O2投与', '$checkIcon　O2投与');
    }

    //70
    htmlInput = htmlInput.replaceFirst(O2Administration, dtReport.O2Administration?.toString() ?? '');

    //71
    htmlInput = htmlInput.replaceFirst(O2AdministrationTime, Utils.formatToOtherFormat(dtReport.O2AdministrationTime ?? '', HH_mm_, HH_space_mm));

    //72
    if (dtReport.SpinalCordMovementLimitation != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　脊髄運動制限', '$checkIcon　脊髄運動制限');
    }

    //73
    if (dtReport.SpinalCordMovementLimitation == '000') {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon頸椎のみ', '$checkIcon頸椎のみ');
    } else if (dtReport.SpinalCordMovementLimitation == '001') {
      htmlInput = htmlInput.replaceFirst('$uncheckIconバックボード', '$checkIconバックボード');
    }

    //74
    if (dtReport.HemostaticTreatment == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　止血措置', '$checkIcon　止血措置');
    }

    //75
    if (dtReport.AdductorFixation == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　副子固定', '$checkIcon　副子固定');
    }

    //76
    if (dtReport.Coating == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　被覆処置', '$checkIcon　被覆処置');
    }

    //77
    if (dtReport.BurnTreatment == 1) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　被覆処置', '$checkIcon　被覆処置');
    }

    //78
    if (dtReport.Other != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　その他', '$checkIcon　その他');
    }

    //79
    htmlInput = htmlInput.replaceFirst(Other, dtReport.Other?.toString() ?? '');

    //80
    if (dtReport.BSMeasurement1 != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　BS測定', '$checkIcon　BS測定');
    }

    //81
    htmlInput = htmlInput.replaceFirst(BSMeasurement1, dtReport.BSMeasurement1?.toString() ?? '');

    //82
    htmlInput = htmlInput.replaceFirst(BSMeasurementTime1, Utils.formatToOtherFormat(dtReport.BSMeasurementTime1 ?? '', HH_mm_, HH_space_mm));

    //83
    htmlInput = htmlInput.replaceFirst(PunctureSite1, dtReport.PunctureSite1?.toString() ?? '');

    //84
    if (dtReport.BSMeasurement2 != null) {
      htmlInput = htmlInput.replaceFirst('$uncheckIcon　BS測定', '$checkIcon　BS測定');
    }

    //85
    htmlInput = htmlInput.replaceFirst(BSMeasurement2, dtReport.BSMeasurement2?.toString() ?? '');

    //86
    htmlInput = htmlInput.replaceFirst(BSMeasurementTime2, Utils.formatToOtherFormat(dtReport.BSMeasurementTime2 ?? '', HH_mm_, HH_space_mm));

    //87
    htmlInput = htmlInput.replaceFirst(PunctureSite2, dtReport.PunctureSite2?.toString() ?? '');

    return htmlInput;
  }

  String handleDatLayout578(String htmlInput) {
    var totalYesDotNoPos = 0;
    var totalYesUrineFecesNoPos = 0;
    var totalYesSpaceNoPos = 0;
    String defaultIncontinenceStr = '有（　尿　　便　）　無';

    for (var i = 0; i < 3; i++) {
      //43
      htmlInput = htmlInput.replaceFirst('$ObservationTime${i + 1}', Utils.formatToOtherFormat(ObservationTimes?[i] ?? '', HH_mm_, HH_space_mm));
      //44
      htmlInput = htmlInput.replaceFirst('$JCS${i + 1}', JCSs?[i] ?? '');
      //45
      htmlInput = htmlInput.replaceFirst('GCS_E${i + 1}', GCSEs?[i] ?? '');
      htmlInput = htmlInput.replaceFirst('GCS_V${i + 1}', GCSVs?[i] ?? '');
      htmlInput = htmlInput.replaceFirst('GCS_M${i + 1}', GCSMs?[i] ?? '');
      //46
      htmlInput = htmlInput.replaceFirst('$Respiration${i + 1}', Respirations?[i] ?? '');
      //47
      htmlInput = htmlInput.replaceFirst('$Pulse${i + 1}', Pulses?[i] ?? '');
      //48
      htmlInput = htmlInput.replaceFirst('BloodPressure_High${i + 1}', BloodPressureHighs?[i] ?? '');
      //49
      htmlInput = htmlInput.replaceFirst('BloodPressure_Low${i + 1}', BloodPressureLows?[i] ?? '');
      //50
      htmlInput = htmlInput.replaceFirst('$SpO2Percent${i + 1}', SpO2Percents?[i] ?? '');
      //51
      htmlInput = htmlInput.replaceFirst('$SpO2Liter${i + 1}', SpO2Liters?[i] ?? '');
      //52
      htmlInput = htmlInput.replaceFirst('$PupilRight${i + 1}', PupilRights?[i] ?? '');
      //53
      htmlInput = htmlInput.replaceFirst('$PupilLeft${i + 1}', PupilLefts?[i] ?? '');
      //54
      if (LightReflexRights?[i] == "0") {
        htmlInput = Utils.customReplace(htmlInput, '有・無', 1 + 2 * i - totalYesDotNoPos, '有・${LocaleKeys.text_circle.tr(namedArgs: {'text': '無'})}');
        totalYesDotNoPos += 1;
      } else if (LightReflexRights?[i] == "1") {
        htmlInput = Utils.customReplace(htmlInput, '有・無', 1 + 2 * i - totalYesDotNoPos, '${LocaleKeys.text_circle.tr(namedArgs: {'text': '有'})}・無');
        totalYesDotNoPos += 1;
      }
      //55
      if (PhotoreflexLefts?[i] == "0") {
        htmlInput = Utils.customReplace(htmlInput, '有・無', 2 + 2 * i- totalYesDotNoPos, '有・${LocaleKeys.text_circle.tr(namedArgs: {'text': '無'})}');
        totalYesDotNoPos += 1;
      } else if (PhotoreflexLefts?[i] == "1") {
        htmlInput = Utils.customReplace(htmlInput, '有・無', 2 + 2 * i - totalYesDotNoPos, '${LocaleKeys.text_circle.tr(namedArgs: {'text': '有'})}・無');
        totalYesDotNoPos += 1;
      }
      //56
      htmlInput = htmlInput.replaceFirst('$BodyTemperature${i + 1}', BodyTemperatures?[i].toString() ?? '');
      //57
      if (FacialFeaturess?[i] == '000') {
        htmlInput = Utils.customReplace(htmlInput, '正常', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': '正常'}));
      } else if (FacialFeaturess?[i] == '001') {
        htmlInput = Utils.customReplace(htmlInput, '紅潮', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': '紅潮'}));
      } else if (FacialFeaturess?[i] == '002') {
        htmlInput = Utils.customReplace(htmlInput, '蒼白', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': '蒼白'}));
      } else if (FacialFeaturess?[i] == '003') {
        htmlInput = Utils.customReplace(htmlInput, 'チアノーゼ', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': 'チアノーゼ'}));
      } else if (FacialFeaturess?[i] == '004') {
        htmlInput = Utils.customReplace(htmlInput, '発汗', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': '発汗'}));
      } else if (FacialFeaturess?[i] == '005') {
        htmlInput = Utils.customReplace(htmlInput, '苦悶', i + 1, LocaleKeys.text_circle.tr(namedArgs: {'text': '苦悶'}));
      }
      //58
      htmlInput = htmlInput.replaceFirst('$Hemorrhage${i + 1}', Hemorrhages?[i].toString() ?? '');
      //59
      List<String> incontinences = Incontinences?[i].split(comma) ?? [];
      int index001 = incontinences.indexOf("001");
      int index002 = incontinences.indexOf("002");
      int index003 = incontinences.indexOf("003");
      if(index001 >= 0 && index003 >= 0) incontinences[index001] = '';
      if(index002 >= 0 && index003 >= 0) incontinences[index002] = '';
      print(incontinences);
      String incontinenceStr = defaultIncontinenceStr;
      for (String incon in incontinences) {
        if (incon == '000') {
          incontinenceStr = incontinenceStr.replaceFirst('無', LocaleKeys.text_circle.tr(namedArgs: {'text': '無'}));
        } else if (incon == '001') {
          incontinenceStr = incontinenceStr.replaceFirst('尿', LocaleKeys.text_circle.tr(namedArgs: {'text': '尿'}));
        } else if (incon == '002') {
          incontinenceStr = incontinenceStr.replaceFirst('便', LocaleKeys.text_circle.tr(namedArgs: {'text': '便'}));
        }else if (incon == '003') {
          incontinenceStr = incontinenceStr.replaceFirst('尿', LocaleKeys.text_circle.tr(namedArgs: {'text': '尿'}));
          incontinenceStr = incontinenceStr.replaceFirst('便', LocaleKeys.text_circle.tr(namedArgs: {'text': '便'}));
        }
      }
      if(incontinenceStr != defaultIncontinenceStr){
        htmlInput = Utils.customReplace(htmlInput, defaultIncontinenceStr, i + 1 - totalYesUrineFecesNoPos, incontinenceStr);
         totalYesUrineFecesNoPos += 1;
      }


      //60
      if (Vomitings?[i] == "0") {
        htmlInput = Utils.customReplace(htmlInput, '有　　無', i + 1 - totalYesSpaceNoPos, '${LocaleKeys.text_circle.tr(namedArgs: {'text': '有'})}　　無');
        totalYesSpaceNoPos += 1;
      } else if (Vomitings?[i] == "1") {
        htmlInput = Utils.customReplace(htmlInput, '有　　無', i + 1 - totalYesSpaceNoPos, '有　　${LocaleKeys.text_circle.tr(namedArgs: {'text': '無'})}');
        totalYesSpaceNoPos += 1;
      }
      //61
      htmlInput = htmlInput.replaceFirst('$Extremities${i + 1}', Extremitiess?[i].toString() ?? '');
    }
    return htmlInput;
  }
}
