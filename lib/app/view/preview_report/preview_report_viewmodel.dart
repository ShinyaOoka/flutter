import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/snack_bar_util.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/module/form_report/injured_person_transport_certificate_atribute_name.dart';
import 'package:ak_azm_flutter/app/view/edit_report/edit_report_page.dart';
import 'package:ak_azm_flutter/app/view/send_report/send_report_page.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webcontent_converter/webcontent_converter.dart';

import '../../di/injection.dart';
import '../../model/dt_report.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/response/databases_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class PreviewReportViewModel extends BaseViewModel {
  late String assetFile;
  late String pdfName = '';
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  DBHelper dbHelper = getIt<DBHelper>();
  final serverFC = FocusNode();
  final portFC = FocusNode();
  List<String> yesNothings = [
    LocaleKeys.yes_dropdown.tr(),
    LocaleKeys.nothing.tr()
  ];
  bool isExpandQualification = false;
  bool isExpandRide = false;
  String? emt_qualification;
  String? emt_ride;
  String server = '';
  String port = '';
  var serverController = TextEditingController();
  var portController = TextEditingController();

  List<dynamic> databaseList = [];
  List<DTReport> dtReports = [];
  DatabasesResponse? _databasesResponse;

  set databasesResponse(DatabasesResponse? databasesResponse) {
    _databasesResponse = databasesResponse;
    notifyListeners();
  }

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

  DatabasesResponse? get databasesResponse => _databasesResponse;

  PreviewReportViewModel(this._dataRepo, this.assetFile, this.pdfName);

  String generatedPdfFilePath = '';

  Future<void> initData() async {
    await getReports();
    generatedPdfFilePath = await generateExampleDocument(assetFile ?? '');
    print('Test: $generatedPdfFilePath');
    notifyListeners();
  }

  Future<String> generateExampleDocument(String assetFile) async {
    var fileHtmlContents = await rootBundle.loadString(assetFile);

    //format data from db to html file
    fileHtmlContents = await formatDataToForm(dtReports[0], fileHtmlContents);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    const targetFileName = "report.pdf";

    var dir = await getApplicationDocumentsDirectory();
    var savedPath = join(dir.path, targetFileName);
    var result = await WebcontentConverter.contentToPDF(
     content:  fileHtmlContents,
      savedPath: savedPath,
      format: PaperFormat.a3,
      margins: PdfMargins.px(top: 35, bottom: 35, right: 35, left: 35),
    );

    return result ?? '';

    // final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
    //     fileHtmlContents, targetPath, targetFileName);
    // return generatedPdfFile.path;
  }

  Future<void> getReports() async {
    dtReports = await dbHelper.getAllReport() ?? [];
    notifyListeners();
  }

  Future<String> formatDataToForm(DTReport dtReport, String htmlInput) async {
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
      htmlInput = Utils.customReplace(htmlInput, '□有', 1, checkIcon + '有');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□無', 1, checkIcon + '無');
    }

    //5
    if (dtReport.WithLifeSavers == 1) {
      htmlInput = Utils.customReplace(htmlInput, '□有', 2, checkIcon + '有');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□無', 2, checkIcon + '無');
    }

    //6
    htmlInput = htmlInput.replaceFirst('TeamTEL', dtReport.TeamTEL ?? '');

    //7
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAddress', dtReport.SickInjuredPersonAddress ?? '');
    //8
    if (dtReport.SickInjuredPersonGender == '男性') {
      htmlInput =  htmlInput.replaceFirst('□　男', checkIcon + '　男');
    } else if (dtReport.SickInjuredPersonGender == '女性') {
      htmlInput = htmlInput.replaceFirst('□　女', checkIcon + '　女');
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
        Utils.calculateAge(
                Utils.stringToDateTime(dtReport.SickInjuredPersonBirthDate, format: yyyy_MM_dd_))
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
      htmlInput = Utils.customReplace(htmlInput, '□無', 3, checkIcon + '無');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□有', 3, checkIcon + '有');
    }

    //16
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicalHistroy',
        dtReport.SickInjuredPersonMedicalHistroy ?? '');

    //17
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonHistoryHospital',
        dtReport.SickInjuredPersonHistoryHospital ?? '');

    //18
    if (dtReport.SickInjuredPersonKakaritsuke == null) {
      htmlInput = Utils.customReplace(htmlInput, '□無', 4, checkIcon + '無');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□有', 4, checkIcon + '有');
    }

    //19
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonKakaritsuke',
        dtReport.SickInjuredPersonKakaritsuke ?? '');

    //20
    if (dtReport.SickInjuredPersonMedication == '無') {
      htmlInput = Utils.customReplace(htmlInput, '□無', 5, checkIcon + '無');
    } else if (dtReport.SickInjuredPersonMedication == '有') {
      htmlInput = Utils.customReplace(htmlInput, '□有', 5, checkIcon + '有');
    } else {
      htmlInput = htmlInput.replaceFirst('□手帳', checkIcon + '手帳');
    }

    //21
    htmlInput = htmlInput.replaceFirst('SickInjuredPersonMedicationDetail',
        dtReport.SickInjuredPersonMedicationDetail ?? '');

    //22
    if (dtReport.SickInjuredPersonAllergy == null) {
      htmlInput = Utils.customReplace(htmlInput, '□無', 5, checkIcon + '無');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□有', 5, checkIcon + '有');
    }

    //23
    htmlInput = htmlInput.replaceFirst(
        'SickInjuredPersonAllergy', dtReport.SickInjuredPersonAllergy ?? '');

    //24
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst('□急病', checkIcon + '急病');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst('□交通', checkIcon + '交通');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('□一般', checkIcon + '一般');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('□労災', checkIcon + '労災');
    } else if (dtReport.TypeOfAccident == '004') {
      htmlInput = htmlInput.replaceFirst('□自損', checkIcon + '自損');
    } else if (dtReport.TypeOfAccident == '005') {
      htmlInput = htmlInput.replaceFirst('□運動', checkIcon + '運動');
    } else if (dtReport.TypeOfAccident == '006') {
      htmlInput = htmlInput.replaceFirst('□転院', checkIcon + '転院');
    } else {
      htmlInput = htmlInput.replaceFirst('□その他', checkIcon + 'その他');
    }

    //25
    var DateOfOccurrenceYear = DateFormat.y().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var DateOfOccurrenceMonth = DateFormat.M().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var DateOfOccurrenceDay = DateFormat.d().format(Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    var TimeOfOccurrenceHour = DateFormat.j().format(Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: hh_mm_));
    var TimeOfOccurrenceMinute = DateFormat.m().format(Utils.stringToDateTime(dtReport.TimeOfOccurrence, format: hh_mm_));
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceYear', DateOfOccurrenceYear.toString());
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceMonth', DateOfOccurrenceMonth.toString());
    htmlInput = htmlInput.replaceFirst('DateOfOccurrenceDay', DateOfOccurrenceDay.toString());
    htmlInput = htmlInput.replaceFirst('TimeOfOccurrenceHour', TimeOfOccurrenceHour.toString());
    htmlInput = htmlInput.replaceFirst('TimeOfOccurrenceMinute', TimeOfOccurrenceMinute.toString());

    //26
    htmlInput = htmlInput.replaceFirst('PlaceOfIncident', dtReport.PlaceOfIncident ?? '');

    //27
    htmlInput = htmlInput.replaceFirst('AccidentSummary', dtReport.AccidentSummary ?? '');


    //28
    if (dtReport.ADL == '000') {
      htmlInput = htmlInput.replaceFirst('□自立', checkIcon + '自立');
    } else if (dtReport.ADL == '001') {
      htmlInput = htmlInput.replaceFirst('□全介助', checkIcon + '全介助');
    } else {
      htmlInput = htmlInput.replaceFirst('□部分介助', checkIcon + '部分介助');
    }

    //      "06時30分",

    //29
    htmlInput = htmlInput.replaceFirst('SenseTime', Utils.formatToOtherFormat(dtReport.SenseTime ?? '', hh_mm_, 'hh: mm' ) );
    //30
    htmlInput = htmlInput.replaceFirst('CommandTime', Utils.formatToOtherFormat(dtReport.CommandTime ?? '', hh_mm_, 'hh: mm' ) );
    //31
    htmlInput = htmlInput.replaceFirst('AttendanceTime', Utils.formatToOtherFormat(dtReport.AttendanceTime ?? '', hh_mm_, 'hh: mm' ) );
    //32
    htmlInput = htmlInput.replaceFirst('On-siteArrivalTime', Utils.formatToOtherFormat(dtReport.OnsiteArrivalTime ?? '', hh_mm_, 'hh: mm' ) );
    //33
    htmlInput = htmlInput.replaceFirst('ContactTime', Utils.formatToOtherFormat(dtReport.ContactTime ?? '', hh_mm_, 'hh: mm' ) );
    //34
    htmlInput = htmlInput.replaceFirst('In-vehicleTime', Utils.formatToOtherFormat(dtReport.InvehicleTime ?? '', hh_mm_, 'hh: mm' ) );
    //35
    htmlInput = htmlInput.replaceFirst('StartOfTransportTime', Utils.formatToOtherFormat(dtReport.StartOfTransportTime ?? '', hh_mm_, 'hh: mm' ) );
    //36
    htmlInput = htmlInput.replaceFirst('HospitalArrivalTime', Utils.formatToOtherFormat(dtReport.HospitalArrivalTime ?? '', hh_mm_, 'hh: mm' ) );
    //37
    htmlInput = htmlInput.replaceFirst('FamilyContactTime', Utils.formatToOtherFormat(dtReport.FamilyContactTime ?? '', hh_mm_, 'hh: mm' ) );
    //38
    htmlInput = htmlInput.replaceFirst('PoliceContactTime', Utils.formatToOtherFormat(dtReport.PoliceContactTime ?? '', hh_mm_, 'hh: mm' ) );


    //39
    if (dtReport.TypeOfAccident == '000') {
      htmlInput = htmlInput.replaceFirst('□シートベルト', checkIcon + 'シートベルト');
    } else if (dtReport.TypeOfAccident == '001') {
      htmlInput = htmlInput.replaceFirst('□エアバック', checkIcon + 'エアバック');
    } else if (dtReport.TypeOfAccident == '002') {
      htmlInput = htmlInput.replaceFirst('□不明', checkIcon + '不明');
    } else if (dtReport.TypeOfAccident == '003') {
      htmlInput = htmlInput.replaceFirst('□チャイルドシート', checkIcon + 'チャイルドシート');
    }  else {
      htmlInput = htmlInput.replaceFirst('□ヘルメット', checkIcon + 'ヘルメット');
    }

    //40
    if (dtReport.Witnesses == 0) {
      htmlInput = Utils.customReplace(htmlInput, '□無', 4, checkIcon + '無');
    } else {
      htmlInput = Utils.customReplace(htmlInput, '□有', 4, checkIcon + '有');
    }

    //41
    htmlInput = htmlInput.replaceFirst('BystanderCPR', Utils.formatToOtherFormat(dtReport.BystanderCPR ?? '', hh_mm_, 'hh: mm' ));


    //42
    htmlInput = htmlInput.replaceFirst('VerbalGuidance', dtReport.VerbalGuidance ?? '');

    //layout 5
    //43
    htmlInput = htmlInput.replaceFirst('ObservationTime1', Utils.formatToOtherFormat(dtReport.ObservationTime ?? '', hh_mm_, 'hh: mm' ) );
    htmlInput = htmlInput.replaceFirst('ObservationTime2', Utils.formatToOtherFormat(dtReport.ObservationTime ?? '', hh_mm_, 'hh: mm' ) );
    htmlInput = htmlInput.replaceFirst('ObservationTime3', Utils.formatToOtherFormat(dtReport.ObservationTime ?? '', hh_mm_, 'hh: mm' ) );

    //44
    htmlInput = htmlInput.replaceFirst('JCS1', dtReport.JCS ?? '');
    htmlInput = htmlInput.replaceFirst('JCS2', dtReport.JCS ?? '');
    htmlInput = htmlInput.replaceFirst('JCS3', dtReport.JCS ?? '');

    //45
    htmlInput = htmlInput.replaceFirst('GCS_E1', dtReport.GCSE ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_E2', dtReport.GCSE ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_E2', dtReport.GCSE ?? '');

    htmlInput = htmlInput.replaceFirst('GCS_V1', dtReport.GCSV ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_V2', dtReport.GCSV ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_V2', dtReport.GCSV ?? '');

    htmlInput = htmlInput.replaceFirst('GCS_M1', dtReport.GCSM ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_M2', dtReport.GCSM ?? '');
    htmlInput = htmlInput.replaceFirst('GCS_M2', dtReport.GCSM ?? '');

    //46
    htmlInput = htmlInput.replaceFirst('Respiration1', dtReport.Respiration ?? '');
    htmlInput = htmlInput.replaceFirst('Respiration2', dtReport.Respiration ?? '');
    htmlInput = htmlInput.replaceFirst('Respiration3', dtReport.Respiration ?? '');

    //47
    htmlInput = htmlInput.replaceFirst('Pulse1', dtReport.Pulse.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('Pulse2', dtReport.Pulse.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('Pulse3', dtReport.Pulse.toString() ?? '');

    //48
    htmlInput = htmlInput.replaceFirst('BloodPressure_High1', dtReport.BloodPressureHigh.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BloodPressure_High2', dtReport.BloodPressureHigh.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BloodPressure_High3', dtReport.BloodPressureHigh.toString() ?? '');

    //49
    htmlInput = htmlInput.replaceFirst('BloodPressure_Low1', dtReport.BloodPressureLow.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BloodPressure_Low2', dtReport.BloodPressureLow.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BloodPressure_Low3', dtReport.BloodPressureLow.toString() ?? '');

    //50
    htmlInput = htmlInput.replaceFirst('SpO2Percent1', dtReport.SpO2Percent.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SpO2Percent2', dtReport.SpO2Percent.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SpO2Percent3', dtReport.SpO2Percent.toString() ?? '');

    //51
    htmlInput = htmlInput.replaceFirst('SpO2Liter1', dtReport.SpO2Liter.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SpO2Liter2', dtReport.SpO2Liter.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('SpO2Liter3', dtReport.SpO2Liter.toString() ?? '');

    //52
    htmlInput = htmlInput.replaceFirst('PupilRight1', dtReport.PupilRight.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('PupilRight2', dtReport.PupilRight.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('PupilRight3', dtReport.PupilRight.toString() ?? '');


    //53
    htmlInput = htmlInput.replaceFirst('PupilLeft1', dtReport.PupilLeft.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('PupilLeft2', dtReport.PupilLeft.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('PupilLeft3', dtReport.PupilLeft.toString() ?? '');

    //
    // //54
    // if (dtReport.Witnesses == 0) {
    //   htmlInput = Utils.customReplace(htmlInput, '□無', 7, checkIcon + '無');
    // } else {
    //   htmlInput = Utils.customReplace(htmlInput, '□有', 7, checkIcon + '有');
    // }

    //
    // //55
    // if (dtReport.Witnesses == 0) {
    //   htmlInput = Utils.customReplace(htmlInput, '□無', 7, checkIcon + '無');
    // } else {
    //   htmlInput = Utils.customReplace(htmlInput, '□有', 7, checkIcon + '有');
    // }



    //56
    htmlInput = htmlInput.replaceFirst('BodyTemperature1', dtReport.BodyTemperature.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BodyTemperature2', dtReport.BodyTemperature.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('BodyTemperature3', dtReport.BodyTemperature.toString() ?? '');

    //
    // //57
    // if (dtReport.Witnesses == 0) {
    //   htmlInput = Utils.customReplace(htmlInput, '□無', 7, checkIcon + '無');
    // } else {
    //   htmlInput = Utils.customReplace(htmlInput, '□有', 7, checkIcon + '有');
    // }



    //58
    htmlInput = htmlInput.replaceFirst('Hemorrhage1', dtReport.Hemorrhage.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('Hemorrhage2', dtReport.Hemorrhage.toString() ?? '');
    htmlInput = htmlInput.replaceFirst('Hemorrhage3', dtReport.Hemorrhage.toString() ?? '');

    //
    // //59
    // if (dtReport.Witnesses == 0) {
    //   htmlInput = Utils.customReplace(htmlInput, '□無', 7, checkIcon + '無');
    // } else {
    //   htmlInput = Utils.customReplace(htmlInput, '□有', 7, checkIcon + '有');
    // }

    //
    // //60
    // if (dtReport.Witnesses == 0) {
    //   htmlInput = Utils.customReplace(htmlInput, '□無', 7, checkIcon + '無');
    // } else {
    //   htmlInput = Utils.customReplace(htmlInput, '□有', 7, checkIcon + '有');
    // }

    //61
    htmlInput = htmlInput.replaceFirst('Extremities1', dtReport.Extremities ?? '');
    htmlInput = htmlInput.replaceFirst('Extremities2', dtReport.Extremities ?? '');
    htmlInput = htmlInput.replaceFirst('Extremities3', dtReport.Extremities ?? '');


    return htmlInput;
  }

  bool get validate =>
      (server.isNotEmpty &&
          (Utils.isURL(server) ||
              Utils.isIPv4(server) ||
              Utils.isIPv6(server))) &&
      (port.isNotEmpty && Utils.isNum(port) && port.length <= 10);

  onChangeServer(String value) {
    this.server = value.trim();
    notifyListeners();
  }

  onChangePort(String value) {
    this.port = value.trim();
    validate;
    notifyListeners();
  }

  onSelectQualification(String? itemSelected) {
    this.emt_qualification = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectRide(String? itemSelected) {
    this.emt_ride = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  String? invalidServer(String? value) {
    return value == null ||
            !(Utils.isURL(server.trim()) ||
                Utils.isIPv4(server.trim()) ||
                Utils.isIPv6(server.trim()))
        ? LocaleKeys.invalid_server.tr()
        : null;
  }

  String? invalidPort(String? value) {
    return value == null || !Utils.isNum(port) || !(port.length <= 10)
        ? LocaleKeys.invalid_port.tr()
        : null;
  }

  void submit() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
  }

  //check is server = call api get database
  void getDatabasesApi() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
    final subscript = _dataRepo.getDatabases().doOnListen(() {
      EasyLoading.show();
    }).doOnDone(() {
      EasyLoading.dismiss();
    }).listen((r) {
      try {
        databasesResponse = DatabasesResponse.fromJson(r);
        if (databasesResponse?.result != null &&
            databasesResponse!.result is List) {
          databaseList = databasesResponse!.result ?? [];
          notifyListeners();
          /*_navigationService.pushScreenNoAnim(SignInPage(
            databaseList: databaseList,
          ));*/
        }
      } catch (e) {
        SnackBarUtil.showSnack(
            title: LocaleKeys.something_is_not_right.tr(),
            message: LocaleKeys.please_check_your_url.tr(),
            snackType: SnackType.ERROR);
      } finally {
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }

  void openSignIn() {
    getDatabasesApi();
  }

  bool doubleBackToExit = false;

  Future<bool> onDoubleBackToExit() async {
    if (doubleBackToExit) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    }
    doubleBackToExit = true;
    ToastUtil.showToast(LocaleKeys.press_the_back_button_to_exit.tr());
    Future.delayed(Duration(seconds: 2), () {
      doubleBackToExit = false;
    });
    return false;
  }
}
