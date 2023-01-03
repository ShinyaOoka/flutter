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
  String? observation_time = '';
  String? report_observation_time_explanation = '';
  String? jcs = '';
  String? gcs = '';
  String? gcs_e = '';
  String? gcs_v = '';
  String? gcs_m = '';
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
  String? observation_time_7 = '';
  String? report_observation_time_explanation_7 = '';
  String? jcs_7 = '';
  String? gcs_7 = '';
  String? gcs_e_7 = '';
  String? gcs_v_7 = '';
  String? gcs_m_7 = '';
  String? breathing_7 = '';
  String? pulse_7 = '';
  String? blood_pressure_up_7 = '';
  String? blood_pressure_lower_7 = '';
  String? spo2_percent_7 = '';
  String? spo2_l_7 = '';
  String? right_pupil_7 = '';
  String? left_pupil_7 = '';
  String? light_reflection_right_7 = '';
  String? light_reflection_left_7 = '';
  String? body_temperature_7 = '';
  String? facial_features_7 = '';
  String? bleeding_7 = '';
  List<String> incontinence_7 = [];
  String? vomiting_7 = '';
  String? limb_7 = '';



  //layout 8
  String? observation_time_8 = '';
  String? report_observation_time_explanation_8 = '';
  String? jcs_8 = '';
  String? gcs_8 = '';
  String? gcs_e_8 = '';
  String? gcs_v_8 = '';
  String? gcs_m_8 = '';
  String? breathing_8 = '';
  String? pulse_8 = '';
  String? blood_pressure_up_8 = '';
  String? blood_pressure_lower_8 = '';
  String? spo2_percent_8 = '';
  String? spo2_l_8 = '';
  String? right_pupil_8 = '';
  String? left_pupil_8 = '';
  String? light_reflection_right_8 = '';
  String? light_reflection_left_8 = '';
  String? body_temperature_8 = '';
  String? facial_features_8 = '';
  String? bleeding_8 = '';
  List<String> incontinence_8 = [];
  String? vomiting_8 = '';
  String? limb_8 = '';

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
  onConfirmObservationTime(DateTime date) {
    this.observation_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation(String? itemSelected) {
    this.report_observation_time_explanation = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs(String? itemSelected) {
    this.jcs = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE(String? itemSelected) {
    this.gcs_e = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV(String? itemSelected) {
    this.gcs_v = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM(String? itemSelected) {
    this.gcs_m = itemSelected ?? '';
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
  onConfirmObservationTime7(DateTime date) {
    this.observation_time_7 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation7(String? itemSelected) {
    this.report_observation_time_explanation_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs7(String? itemSelected) {
    this.jcs_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE7(String? itemSelected) {
    this.gcs_e_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV7(String? itemSelected) {
    this.gcs_v_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM7(String? itemSelected) {
    this.gcs_m_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing7(String? itemSelected) {
    this.breathing_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse7(String? itemSelected) {
    this.pulse_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp7(String? itemSelected) {
    this.blood_pressure_up_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower7(String? itemSelected) {
    this.blood_pressure_lower_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent7(String? itemSelected) {
    this.spo2_percent_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L7(String? itemSelected) {
    this.spo2_l_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil7(String? itemSelected) {
    this.right_pupil_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil7(String? itemSelected) {
    this.left_pupil_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight7(String? itemSelected) {
    this.light_reflection_right_7 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft7(String? itemSelected) {
    this.light_reflection_left_7 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature7(String? itemSelected) {
    this.body_temperature_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures7(String? itemSelected) {
    this.facial_features_7 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding7(String? itemSelected) {
    this.bleeding_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectVomiting7(String? itemSelected) {
    this.vomiting_7 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb7(String? itemSelected) {
    this.limb_7 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence7(List<String> checkeds) {
    this.incontinence_7 = checkeds ?? [];
    notifyListeners();
  }



  //layout 8
  onConfirmObservationTime8(DateTime date) {
    this.observation_time_8 = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onChangeReportObservationTimeExplanation8(String? itemSelected) {
    this.report_observation_time_explanation_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectJcs8(String? itemSelected) {
    this.jcs_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE8(String? itemSelected) {
    this.gcs_e_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV8(String? itemSelected) {
    this.gcs_v_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM8(String? itemSelected) {
    this.gcs_m_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing8(String? itemSelected) {
    this.breathing_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse8(String? itemSelected) {
    this.pulse_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp8(String? itemSelected) {
    this.blood_pressure_up_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower8(String? itemSelected) {
    this.blood_pressure_lower_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent8(String? itemSelected) {
    this.spo2_percent_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L8(String? itemSelected) {
    this.spo2_l_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil8(String? itemSelected) {
    this.right_pupil_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil8(String? itemSelected) {
    this.left_pupil_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight8(String? itemSelected) {
    this.light_reflection_right_8 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectLightReflectionLeft8(String? itemSelected) {
    this.light_reflection_left_8 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeBodyTemperature8(String? itemSelected) {
    this.body_temperature_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures8(String? itemSelected) {
    this.facial_features_8 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBleeding8(String? itemSelected) {
    this.bleeding_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectVomiting8(String? itemSelected) {
    this.vomiting_8 = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onChangeLimb8(String? itemSelected) {
    this.limb_8 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence8(List<String> checkeds) {
    this.incontinence_8 = checkeds ?? [];
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




}
