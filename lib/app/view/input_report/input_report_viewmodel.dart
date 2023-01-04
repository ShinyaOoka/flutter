import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:ak_azm_flutter/app/model/ms_hospital.dart';
import 'package:ak_azm_flutter/app/model/ms_team.dart';
import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../main.dart';
import '../../di/injection.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class InputReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  final NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  List<MSClassification> msClassifications = [];
  List<MSTeam> msTeams = [];
  List<MSTeamMember> msTeamMembers = [];
  List<MSHospital> msHospitals = [];

  //layout 1
  List<String> yesNothings = [];
  bool isExpandQualification = false;
  bool isExpandRide = false;

  //layout 1
  String? ambulance_name = '';
  String? ambulance_tel = '';
  String? captain_name = '';
  String? emt_qualification = '';
  String? emt_ride = '';
  String? report_member_name = '';
  String? report_name_of_engineer = '';
  String? report_cumulative_total = '';
  String? report_team = '';

  //layout 2
  String? family_name = '';
  String? furigana = '';
  String? address = '';
  String? sex = '';
  String? birthday = '';
  String? age = '';
  String? tel = '';
  String? family_phone = '';
  String? medical_history = '';
  String? medical_history_medical_institution = '';
  String? family = '';
  String? dosage = '';
  String? dosing_details = '';
  String? allergy = '';
  String? report_name_of_injury_or_disease = '';
  String? report_degree = '';

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
  String? observationTime1 = '';
  String? reportObservationTimeExplanation1 = '';
  String? jcs1 = '';
  String? gcs1 = '';
  String? gcsE1 = '';
  String? gcsV1 = '';
  String? gcsM1 = '';
  String? breathing1 = '';
  String? pulse1 = '';
  String? bloodPressureUp1 = '';
  String? bloodPessureLower1 = '';
  String? spo2Percent1 = '';
  String? spo2L1 = '';
  String? rightPupil1 = '';
  String? leftPupil1 = '';
  String? lightReflectionRight1 = '';
  String? lightReflectionLeft1 = '';
  String? bodyTemperature1 = '';
  String? facialFeatures1 = '';
  String? bleeding1 = '';
  String incontinence1 = '';
  String? vomiting1 = '';
  String? limb1 = '';

  //layout 6
  String? airway_management = '';
  String? foreign_matter_removal = '';
  String? suction = '';
  String? artificial_respiration = '';
  String? chest_compression = '';
  String? ecg_monitor = '';
  String? o2_administration = '';
  String? o2_administration_time = '';
  String? spinal_cord_motion_limitation = '';
  String? hemostasis = '';
  String? splint_fixation = '';
  String? coating_treatment = '';
  String? burn_treatment = '';
  String? bs_measurement_1 = '';
  String? bs_measurement_time_1 = '';
  String? puncture_site_1 = '';
  String? bs_measurement_time_2 = '';
  String? bs_measurement_2 = '';
  String? puncture_site_2 = '';
  String? others = '';

  //layout 7
  String? observationTime2 = '';
  String? reportObservationTimeExplanation2 = '';
  String? jcs2 = '';
  String? gcs2 = '';
  String? gcsE2 = '';
  String? gcsV2 = '';
  String? gcsM2 = '';
  String? breathing2 = '';
  String? pulse2 = '';
  String? bloodPressureUp2 = '';
  String? bloodPessureLower2 = '';
  String? spo2Percent2 = '';
  String? spo2L2 = '';
  String? rightPupil2 = '';
  String? leftPupil2 = '';
  String? lightReflectionRight2 = '';
  String? lightReflectionLeft2 = '';
  String? bodyTemperature2 = '';
  String? facialFeatures2 = '';
  String? bleeding2 = '';
  String incontinence2 = '';
  String? vomiting2 = '';
  String? limb2 = '';



  //layout 8
  String? observationTime3 = '';
  String? reportObservationTimeExplanation3 = '';
  String? jcs3 = '';
  String? gcs3 = '';
  String? gcsE3 = '';
  String? gcsV3 = '';
  String? gcsM3 = '';
  String? breathing3 = '';
  String? pulse3 = '';
  String? bloodPressureUp3 = '';
  String? bloodPessureLower3 = '';
  String? spo2Percent3 = '';
  String? spo2L3 = '';
  String? rightPupil3 = '';
  String? leftPupil3 = '';
  String? lightReflectionRight3 = '';
  String? lightReflectionLeft3 = '';
  String? bodyTemperature3 = '';
  String? facialFeatures3 = '';
  String? bleeding3 = '';
  String incontinence3 = '';
  String? vomiting3 = '';
  String? limb3 = '';


  //layout 9
  String? perceiver = '';
  String? awareness_type = '';
  String? whistleblower = '';
  String? reporting_phone = '';

  //layout 10
  String? transportation_medical_institution = '';
  String? forwarding_medical_institution = '';
  String? transfer_source_pick_up_time = '';
  String? transfer_reason = '';
  String? reason_for_non_delivery = '';
  String? transport_refusal_processing_record = '';


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
    getAllMSHospital();
  }

  Future<void> getAllMSClassification() async {
    List<Map<String, Object?>>? datas =
        await dbHelper.getAllData(tableMSClassification) ?? [];
    msClassifications = datas.map((e) => MSClassification.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeam() async {
    List<Map<String, Object?>>? datas =
        await dbHelper.getAllData(tableMSTeam) ?? [];
    msTeams = datas.map((e) => MSTeam.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeamMember() async {
    List<Map<String, Object?>>? datas =
        await dbHelper.getAllData(tableMSTeamMember) ?? [];
    msTeamMembers = datas.map((e) => MSTeamMember.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSHospital() async {
    List<Map<String, Object?>>? datas =
        await dbHelper.getAllData(tableMSHospital) ?? [];
    msHospitals = datas.map((e) => MSHospital.fromJson(e)).toList();
    notifyListeners();
  }

  InputReportViewModel(this._dataRepo);

  onSelectAmbulanceName(String? itemSelected) {
    this.ambulance_name = itemSelected ?? '';
    MSTeam? msTeam = msTeams.firstWhere((e) => e.Name == itemSelected);
    onSelectAmbulanceTel(msTeam.TEL ?? '');
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
    this.report_cash_on_delivery_time =
        Utils.dateTimeToString(date, format: hh_mm_);
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
  onConfirmObservationTime1(DateTime date) {
    this.observationTime1 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation1(String? itemSelected) {
    this.reportObservationTimeExplanation1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs1(String? itemSelected) {
    this.jcs1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE1(String? itemSelected) {
    this.gcsE1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV1(String? itemSelected) {
    this.gcsV1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM1(String? itemSelected) {
    this.gcsM1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing1(String? itemSelected) {
    this.breathing1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse1(String? itemSelected) {
    this.pulse1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp1(String? itemSelected) {
    this.bloodPressureUp1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower1(String? itemSelected) {
    this.bloodPessureLower1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent1(String? itemSelected) {
    this.spo2Percent1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L1(String? itemSelected) {
    this.spo2L1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil1(String? itemSelected) {
    this.rightPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil1(String? itemSelected) {
    this.leftPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight1(String? itemSelected) {
    this.lightReflectionRight1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft1(String? itemSelected) {
    this.lightReflectionLeft1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature1(String? itemSelected) {
    this.bodyTemperature1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures1(String? itemSelected) {
    this.facialFeatures1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding1(String? itemSelected) {
    this.bleeding1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence1(List<String> checkeds) {
    this.incontinence1 = checkeds.join(comma);
    notifyListeners();
  }

  onSelectVomiting1(String? itemSelected) {
    this.vomiting1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb1(String? itemSelected) {
    this.limb1 = itemSelected ?? '';
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

  onSelectSpinalCordMotionLimitation(String? itemSelected) {
    this.spinal_cord_motion_limitation = itemSelected ?? '';
    notifyListeners();
  }

  onSelectHemostasis(String? itemSelected) {
    this.hemostasis = itemSelected ?? '';
    notifyListeners();
  }

  onSelectSplintFixation(String? itemSelected) {
    this.splint_fixation = itemSelected ?? '';
    notifyListeners();
  }

  onSelectCoatingTreatment(String? itemSelected) {
    this.coating_treatment = itemSelected ?? '';
    notifyListeners();
  }

  onSelectBurnTreatment(String? itemSelected) {
    this.burn_treatment = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBsMeasurement1(String? itemSelected) {
    this.bs_measurement_1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectBsMeasurementTime1(DateTime date) {
    this.bs_measurement_time_1 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangePunctureSite1(String? itemSelected) {
    this.puncture_site_1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBsMeasurement2(String? itemSelected) {
    this.bs_measurement_2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectBsMeasurementTime2(DateTime date) {
    this.bs_measurement_time_2 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangePunctureSite2(String? itemSelected) {
    this.puncture_site_2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeOthers(String? itemSelected) {
    this.others = itemSelected ?? '';
    notifyListeners();
  }



  //layout 7
  onConfirmObservationTime2(DateTime date) {
    this.observationTime1 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation2(String? itemSelected) {
    this.reportObservationTimeExplanation1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs2(String? itemSelected) {
    this.jcs1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE2(String? itemSelected) {
    this.gcsE1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV2(String? itemSelected) {
    this.gcsV1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM2(String? itemSelected) {
    this.gcsM1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing2(String? itemSelected) {
    this.breathing1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse2(String? itemSelected) {
    this.pulse1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp2(String? itemSelected) {
    this.bloodPressureUp1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower2(String? itemSelected) {
    this.bloodPessureLower1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent2(String? itemSelected) {
    this.spo2Percent1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L2(String? itemSelected) {
    this.spo2L1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil2(String? itemSelected) {
    this.rightPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil2(String? itemSelected) {
    this.leftPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight2(String? itemSelected) {
    this.lightReflectionRight1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft2(String? itemSelected) {
    this.lightReflectionLeft1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature2(String? itemSelected) {
    this.bodyTemperature1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures2(String? itemSelected) {
    this.facialFeatures1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding2(String? itemSelected) {
    this.bleeding1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence2(List<String> checkeds) {
    this.incontinence1 = checkeds.join(comma);
    notifyListeners();
  }

  onSelectVomiting2(String? itemSelected) {
    this.vomiting1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb2(String? itemSelected) {
    this.limb1 = itemSelected ?? '';
    notifyListeners();
  }



  //layout 8
  onConfirmObservationTime3(DateTime date) {
    this.observationTime1 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation3(String? itemSelected) {
    this.reportObservationTimeExplanation1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs3(String? itemSelected) {
    this.jcs1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE3(String? itemSelected) {
    this.gcsE1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV3(String? itemSelected) {
    this.gcsV1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM3(String? itemSelected) {
    this.gcsM1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing3(String? itemSelected) {
    this.breathing1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse3(String? itemSelected) {
    this.pulse1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp3(String? itemSelected) {
    this.bloodPressureUp1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower3(String? itemSelected) {
    this.bloodPessureLower1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent3(String? itemSelected) {
    this.spo2Percent1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L3(String? itemSelected) {
    this.spo2L1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil3(String? itemSelected) {
    this.rightPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil3(String? itemSelected) {
    this.leftPupil1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight3(String? itemSelected) {
    this.lightReflectionRight1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft3(String? itemSelected) {
    this.lightReflectionLeft1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature3(String? itemSelected) {
    this.bodyTemperature1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures3(String? itemSelected) {
    this.facialFeatures1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding3(String? itemSelected) {
    this.bleeding1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence3(List<String> checkeds) {
    this.incontinence1 = checkeds.join(comma);
    notifyListeners();
  }

  onSelectVomiting3(String? itemSelected) {
    this.vomiting1 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb3(String? itemSelected) {
    this.limb1 = itemSelected ?? '';
    notifyListeners();
  }



  //layout 9
  onChangePerceiver(String? itemSelected) {
    this.perceiver = itemSelected ?? '';
    notifyListeners();
  }

  onSelectAwarenessType(String? itemSelected) {
    this.awareness_type = itemSelected ?? '';
    notifyListeners();
  }

  onChangeWhistleblower(String? itemSelected) {
    this.whistleblower = itemSelected ?? '';
    notifyListeners();
  }
  onChangeReportingPhone(String? itemSelected) {
    this.reporting_phone = itemSelected ?? '';
    notifyListeners();
  }



  //layout 10
  onSelectTransportationMedicalInstitution(String? itemSelected) {
    this.transportation_medical_institution = itemSelected ?? '';
    notifyListeners();
  }

  onSelectForwardingMedicalInstitution(String? itemSelected) {
    this.forwarding_medical_institution = itemSelected ?? '';
    notifyListeners();
  }

  onConfirmTransferSourcePickUpTime(DateTime date) {
    this.transfer_source_pick_up_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }


  onChangeTransferReason(String? itemSelected) {
    this.transfer_reason = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReasonForNonDelivery(String? itemSelected) {
    this.reason_for_non_delivery = itemSelected ?? '';
    notifyListeners();
  }


  onSelectTransportRefusalProcessingRecord(String? itemSelected) {
    this.transport_refusal_processing_record = itemSelected ?? '';
    notifyListeners();
  }



  void onSaveToDb() async {
    DTReport dtReport = DTReport(

    );
    await dbHelper.putDataToDB(tableDTReport, [dtReport]);
  }


}
