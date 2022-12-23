import 'dart:io';

import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:ak_azm_flutter/app/model/ms_team.dart';
import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/snack_bar_util.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';
import '../../di/injection.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/dio_module.dart';
import '../../module/network/response/databases_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class InputReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  final NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  final serverFC = FocusNode();
  final portFC = FocusNode();
  String server = '';
  String port = '';
  var serverController = TextEditingController();
  var portController = TextEditingController();


  List<MSClassification>  msClassifications= [];
  List<MSTeam>  msTeams= [];
  List<MSTeamMember>  msTeamMembers= [];
  //layout 1
  List<String> yesNothings = [];
  bool isExpandQualification = false;
  bool isExpandRide = false;

  //layout 1
  String? ambulance_name = '';
  String? ambulance_tel= '';
  String? captain_name= '';
  String? emt_qualification= '';
  String? emt_ride= '';
  String? report_member_name= '';
  String? report_name_of_engineer= '';
  String? report_cumulative_total= '';
  String? report_team= '';




  //layout 2
  String? family_name= '';
  String? furigana= '';
  String? address= '';
  String? sex= '';
  String? birthday = '';
  String? age = '';
  String? tel = '';
  String? family_phone = '';
  String? medical_history = '';
  String? medical_history_medical_institution = '';
  String? family = '';
  String? dosage= '';
  String? dosing_details= '';
  String? allergy= '';
  String? report_name_of_injury_or_disease= '';
  String? report_degree= '';


  //layout 3
  String? awareness_time = '';
  String? command_time = '';
  String? work_time = '';
  String? arrival_on_site = '';
  String? contact_time = '';
  String? in_car_accommodation = '';
  String? start_transportation = '';
  String? arrival_at_hospital = '';
  String? family_contact = '';
  String? police_contact = '';
  String? report_cash_on_delivery_time = '';
  String? report_return_time = '';

  //layout 4
  String? accident_type_input = '';
  String? accrual_date = '';
  String? occurrence_time = '';
  String? place_of_occurrence = '';
  String? summary_of_accident_and_chief_complaint = '';
  String? adl = '';
  String? traffic_accident_category = '';
  String? witness = '';
  String? bystander_cpr = '';
  String? oral_instruction = '';

  //layout 5
  String? observation_time = '';
  String? report_observation_time_explanation = '';
  String? jcs = '';
  String? gcs = '';
  String? breathing = '';
  String? pulse = '';
  String? blood_pressure_up = '';
  String? blood_pressure_lower = '';
  String? spo2_percent = '';
  String? spo2_l = '';
  String? right_pupil = '';
  String? left_pupil = '';
  String? light_reflection_right = '';
  String? light_reflection_left = '';
  String? body_temperature = '';
  String? facial_features = '';
  String? bleeding = '';
  List<String> incontinence = [];
  String? vomiting = '';
  String? limb = '';


  //layout 6
  String? airway_management = '';
  String? foreign_matter_removal = '';
  String? suction = '';
  String? artificial_respiration = '';
  String? chest_compression = '';
  String? ecg_monitor = '';
  String? o2_administration = '';
  String? o2_administration_time = '';



  List<dynamic> databaseList = [];
  DatabasesResponse? _databasesResponse;

  set databasesResponse(DatabasesResponse? databasesResponse) {
    _databasesResponse = databasesResponse;
    notifyListeners();
  }

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void initData() {
    //fix warning yes_dropdown, nothing not found in EasyLocalization
    yesNothings = [LocaleKeys.yes_dropdown.tr(), LocaleKeys.nothing.tr()];
    //get data from database
    getAllMSClassification();
    getAllMSTeam();
    getAllMSTeamMember();
  }

  Future<void> getAllMSClassification() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSClassification) ?? [];
    msClassifications = datas.map((e) => MSClassification.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeam() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSTeam) ?? [];
    msTeams = datas.map((e) => MSTeam.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeamMember() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSTeamMember) ?? [];
    msTeamMembers = datas.map((e) => MSTeamMember.fromJson(e)).toList();
    notifyListeners();
  }



  DatabasesResponse? get databasesResponse => _databasesResponse;

  InputReportViewModel(this._dataRepo);

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

  onSelectAmbulanceName(String? itemSelected) {
    this.ambulance_name = itemSelected ?? '';
    MSTeam? msTeam = msTeams.firstWhere((e) => e.Name == itemSelected);
    onSelectAmbulanceTel (msTeam.TEL ?? '');
    notifyListeners();
  }
  onSelectAmbulanceTel(String? itemSelected) {
    this.ambulance_tel = itemSelected ?? '';
    notifyListeners();
  }

  onSelectCaptainName(String? itemSelected) {
    this.captain_name = itemSelected ?? '';
    notifyListeners();
  }

  onSelectEmtQualification(String? itemSelected) {
    this.emt_qualification = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectEmtRide(String? itemSelected) {
    this.emt_ride = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectReportMemberName(String? itemSelected) {
    this.report_member_name = itemSelected ?? '';
    notifyListeners();
  }

  onSelectReportNameOfEngineer(String? itemSelected) {
    this.report_name_of_engineer = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportCumulativeTotal(String? itemSelected) {
    this.report_cumulative_total = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportTeam(String? itemSelected) {
    this.report_team = itemSelected ?? '';
    notifyListeners();
  }


  //layout 2
  onChangeFamilyName(String? itemSelected) {
    this.family_name = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFurigana(String? itemSelected) {
    this.furigana = itemSelected ?? '';
    notifyListeners();
  }

  onChangeAddress(String? itemSelected) {
    this.address = itemSelected ?? '';
    notifyListeners();
  }


  onConfirmBirthday(DateTime date) {
    this.birthday = Utils.dateTimeToString(date, format: yyyy_MM_dd_);
    this.age = Utils.calculateAge(date).toString();
    notifyListeners();
  }

  onSelectSex(String? itemSelected) {
    this.sex = itemSelected ?? '';
    notifyListeners();
  }

  onChangeTel(String? itemSelected) {
    this.tel = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFamilyPhone(String? itemSelected) {
    this.family_phone = itemSelected ?? '';
    notifyListeners();
  }

  onChangeMedicalHistory(String? itemSelected) {
    this.medical_history = itemSelected ?? '';
    notifyListeners();
  }

  onChangeMedicalHistoryMedicalInstitution(String? itemSelected) {
    this.medical_history_medical_institution = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFamily(String? itemSelected) {
    this.family = itemSelected ?? '';
    notifyListeners();
  }

  onSelectDosage(String? itemSelected) {
    this.dosage = itemSelected ?? '';
    notifyListeners();
  }

  onChangeDosingDetails(String? itemSelected) {
    this.dosing_details = itemSelected ?? '';
    notifyListeners();
  }

  onChangeAllergy(String? itemSelected) {
    this.allergy = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportNameOfInjuryOrDisease(String? itemSelected) {
    this.report_name_of_injury_or_disease = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportDegree(String? itemSelected) {
    this.report_degree = itemSelected ?? '';
    notifyListeners();
  }

  onConfirmAwarenessTime(DateTime date) {
    this.awareness_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmCommandTime(DateTime date) {
    this.command_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmWorkTime(DateTime date) {
    this.work_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
onConfirmArrivalOnSite(DateTime date) {
    this.arrival_on_site = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmContactTime(DateTime date) {
    this.contact_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmInCarAccommodation(DateTime date) {
    this.in_car_accommodation = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmStartTransportation(DateTime date) {
    this.start_transportation = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmArrivalAtHospital(DateTime date) {
    this.arrival_at_hospital = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmFamilyContact(DateTime date) {
    this.family_contact = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmPoliceContact(DateTime date) {
    this.police_contact = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmReportCashOnDeliveryTime(DateTime date) {
    this.report_cash_on_delivery_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmReportReturnTime(DateTime date) {
    this.report_return_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  //layout 4
  onSelectAccidentTypeInput(String? itemSelected) {
    this.accident_type_input = itemSelected ?? '';
    notifyListeners();
  }

  onConfirmAccrualDate(DateTime date) {
    this.accrual_date = Utils.dateTimeToString(date, format: yyyy_MM_dd_);
    notifyListeners();
  }

  onConfirmOccurrenceTime(DateTime date) {
    this.occurrence_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangePlaceOfOccurrence(String? itemSelected) {
    this.place_of_occurrence = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSummaryOfAccidentAndChiefComplaint(String? itemSelected) {
    this.oral_instruction = itemSelected ?? '';
    notifyListeners();
  }

  onSelectAdl(String? itemSelected) {
    this.adl = itemSelected ?? '';
    notifyListeners();
  }

  onSelectTrafficAccidentCategory(String? itemSelected) {
    this.traffic_accident_category = itemSelected ?? '';
    notifyListeners();
  }

  onSelectWitness(String? itemSelected) {
    this.witness = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onConfirmBystanderCpr(DateTime date) {
    this.bystander_cpr = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeOralInstruction(String? itemSelected) {
    this.oral_instruction = itemSelected ?? '';
    notifyListeners();
  }



  //layout 5
  onConfirmObservationTime(DateTime date) {
    this.observation_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }


  onChangeReportObservationTimeExplanation(String? itemSelected) {
    this.report_observation_time_explanation = itemSelected ?? '';
    notifyListeners();
  }


  onChangeJcs(String? itemSelected) {
    this.jcs = itemSelected ?? '';
    notifyListeners();
  }

  onChangeGcs(String? itemSelected) {
    this.gcs = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing(String? itemSelected) {
    this.breathing = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse(String? itemSelected) {
    this.pulse = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp(String? itemSelected) {
    this.blood_pressure_up = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower(String? itemSelected) {
    this.blood_pressure_lower = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent(String? itemSelected) {
    this.spo2_percent = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L(String? itemSelected) {
    this.spo2_l = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil(String? itemSelected) {
    this.right_pupil = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil(String? itemSelected) {
    this.left_pupil = itemSelected ?? '';
    notifyListeners();
  }


  onSelectLightReflectionRight(String? itemSelected) {
    this.light_reflection_right = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft(String? itemSelected) {
    this.light_reflection_left = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature(String? itemSelected) {
    this.body_temperature = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures(String? itemSelected) {
    this.facial_features = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding(String? itemSelected) {
    this.bleeding = itemSelected ?? '';
    notifyListeners();
  }

  onSelectVomiting(String? itemSelected) {
    this.vomiting = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb(String? itemSelected) {
    this.limb = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence(List<String> checkeds) {
    this.incontinence = checkeds ?? [];
    notifyListeners();
  }


  //layout 6
  onSelectAirwayManagement(String? itemSelected) {
    this.airway_management = itemSelected ?? '';
    notifyListeners();
  }

  onSelectForeignMatterRemoval(String? itemSelected) {
    this.foreign_matter_removal = itemSelected ?? '';
    notifyListeners();
  }


  onSelectSuction(String? itemSelected) {
    this.suction = itemSelected ?? '';
    notifyListeners();
  }

  onSelectArtificialRespiration(String? itemSelected) {
    this.artificial_respiration = itemSelected ?? '';
    notifyListeners();
  }

  onSelectChestCompression(String? itemSelected) {
    this.chest_compression = itemSelected ?? '';
    notifyListeners();
  }

  onSelectEcgMonitor(String? itemSelected) {
    this.ecg_monitor = itemSelected ?? '';
    notifyListeners();
  }

  onChangeO2Administration(String? itemSelected) {
    this.o2_administration = itemSelected ?? '';
    notifyListeners();
  }

  onSelectO2AdministrationTime(DateTime date) {
    this.o2_administration_time = Utils.dateTimeToString(date, format: hh_mm_);
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
          //_navigationService.pushScreenNoAnim(SignInPage(databaseList: databaseList,));
        }
      } catch (e) {
        SnackBarUtil.showSnack(title: LocaleKeys.something_is_not_right.tr(), message: LocaleKeys.please_check_your_url.tr(), snackType: SnackType.ERROR);
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
