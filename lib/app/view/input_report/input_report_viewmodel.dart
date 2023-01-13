import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:ak_azm_flutter/app/model/ms_fire_station.dart';
import 'package:ak_azm_flutter/app/model/ms_hospital.dart';
import 'package:ak_azm_flutter/app/model/ms_message.dart';
import 'package:ak_azm_flutter/app/model/ms_team.dart';
import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/app/module/event_bus/event_bus.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/dialog/general_dialog.dart';
import 'package:get/utils.dart';

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

  DTReport dtReport = DTReport();

  List<MSClassification> msClassifications = [];
  List<MSTeam> msTeams = [];
  List<MSTeamMember> msTeamMembers = [];
  List<MSHospital> msHospitals = [];
  List<MSMessage> msMessages = [];
  List<MSFireStation> msFireStations = [];

  List<String> yesNothings = [];
  bool isExpandQualification = false;
  bool isExpandRide = false;

  List<MSClassification> msClassification006s = [];
  //layout 1
  String? ambulanceName;
  String? captainName;
  String? memberName;
  String? nameOfEngineer;
  String? emtQualification;
  int? lifesaverQualificationNo8;
  int? lifesaverQualificationNo9;
  int? indexEmtRide;
  String? emtRide;

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

  //layout 11
  String? transportationMedicalInstitution = "";
  String? forwardingMedicalInstitution = "";

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  void initData() {
    //get data from database
    getAllMSClassification();
    getAllMSTeam();
    getAllMSTeamMember();
    getAllMSHospital();
    getAllMSMessage();
    getAllMSFireStation();
  }

  Future<void> getAllMSClassification() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSClassification) ?? [];
    msClassifications = datas.map((e) => MSClassification.fromJson(e)).toList();
    msClassification006s = msClassifications.where((element) => element.ClassificationCD == '006').toList();
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

  Future<void> getAllMSHospital() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSHospital) ?? [];
    msHospitals = datas.map((e) => MSHospital.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSMessage() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSMessage) ?? [];
    msMessages = datas.map((e) => MSMessage.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSFireStation() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSFireStation) ?? [];
    msFireStations = datas.map((e) => MSFireStation.fromJson(e)).toList();
    notifyListeners();
  }

  InputReportViewModel(this._dataRepo);

  onSelectAmbulanceName(String? itemSelected) {
    ambulanceName = itemSelected ?? '';
    MSTeam? msTeam = msTeams.firstWhereOrNull((e) => e.Name == itemSelected);
    dtReport.TeamName = msTeam?.Name ?? '';
    onSelectAmbulanceTel(msTeam?.TEL ?? '');
    if (itemSelected != null) dtReport.FireStationName = msFireStations.firstWhereOrNull((element) => element.FireStationCD == msTeam?.TeamCD)?.Name;
    notifyListeners();
  }

  onSelectAmbulanceTel(String? itemSelected) {
    dtReport.TeamTEL = itemSelected ?? '';
    notifyListeners();
  }

  onSelectCaptainName(String? itemSelected) {
    captainName = itemSelected ?? '';
    MSTeamMember? msTeamMember = msTeamMembers.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true);
    dtReport.TeamCaptainName = msTeamMember?.Name;
    dtReport.LifesaverQualification = msTeamMember?.LifesaverQualification;
    if (msTeamMember?.LifesaverQualification != null) {
      dtReport.LifesaverQualification = msTeamMember?.LifesaverQualification;
    }
    notifyListeners();
  }

  onSelectEmtRide(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.WithLifeSavers = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  int? getIndexEmtRide() {
    if (lifesaverQualificationNo8 == null || lifesaverQualificationNo9 == null) {
      if (lifesaverQualificationNo8 != null)
        return lifesaverQualificationNo8;
      else if (lifesaverQualificationNo9 == null)
        return lifesaverQualificationNo9;
      else
        return null;
    } else
      return lifesaverQualificationNo8! | lifesaverQualificationNo9!;
  }

  onSelectReportMemberName(String? itemSelected) {
    memberName = itemSelected ?? '';
    MSTeamMember? msTeamMember = msTeamMembers.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true);
    dtReport.TeamMemberName = msTeamMember?.Name;
    lifesaverQualificationNo8 = msTeamMember?.LifesaverQualification;
    indexEmtRide = getIndexEmtRide();
    dtReport.WithLifeSavers = indexEmtRide;
    if (indexEmtRide != null) emtRide = yesNothings[indexEmtRide!];
    notifyListeners();
  }

  onSelectReportNameOfEngineer(String? itemSelected) {
    nameOfEngineer = itemSelected ?? '';
    MSTeamMember? msTeamMember = msTeamMembers.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true);
    dtReport.InstitutionalMemberName = msTeamMember?.Name;
    lifesaverQualificationNo9 = msTeamMember?.LifesaverQualification;
    indexEmtRide = getIndexEmtRide();
    dtReport.WithLifeSavers = indexEmtRide;
    if (indexEmtRide != null) emtRide = yesNothings[indexEmtRide!];
    notifyListeners();
  }

  onChangeReportCumulativeTotal(String? itemSelected) {
    dtReport.Total = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  onChangeReportTeam(String? itemSelected) {
    dtReport.Team = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  //layout 2
  onChangeFamilyName(String? itemSelected) {
    dtReport.SickInjuredPersonName = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFurigana(String? itemSelected) {
    dtReport.SickInjuredPersonKANA = itemSelected ?? '';
    notifyListeners();
  }

  onChangeAddress(String? itemSelected) {
    dtReport.SickInjuredPersonAddress = itemSelected ?? '';
    notifyListeners();
  }

  onSelectSex(String? itemSelected) {
    if (itemSelected != null) dtReport.SickInjuredPersonGender = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onConfirmBirthday(DateTime date) {
    dtReport.SickInjuredPersonBirthDate = Utils.dateTimeToString(date, format: yyyy_MM_dd_);
    int? age = Utils.calculateAge(date, Utils.stringToDateTime(dtReport.DateOfOccurrence, format: yyyy_MM_dd_));
    dtReport.SickInjuredPersonAge = age == null || age == 0 ? null : age;
    notifyListeners();
  }

  onChangeTel(String? itemSelected) {
    dtReport.SickInjuredPersonTEL = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFamilyPhone(String? itemSelected) {
    dtReport.SickInjuredPersonFamilyTEL = itemSelected ?? '';
    notifyListeners();
  }

  onChangeMedicalHistory(String? itemSelected) {
    dtReport.SickInjuredPersonMedicalHistroy = itemSelected ?? '';
    notifyListeners();
  }

  onChangeMedicalHistoryMedicalInstitution(String? itemSelected) {
    dtReport.SickInjuredPersonHistoryHospital = itemSelected ?? '';
    notifyListeners();
  }

  onChangeFamily(String? itemSelected) {
    dtReport.SickInjuredPersonKakaritsuke = itemSelected ?? '';
    notifyListeners();
  }

  String? dosage;

  onSelectDosage(String? itemSelected) {
    this.dosage = itemSelected ?? '';
    if (itemSelected != null) dtReport.SickInjuredPersonMedication = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onChangeDosingDetails(String? itemSelected) {
    dtReport.SickInjuredPersonMedicationDetail = itemSelected ?? '';
    notifyListeners();
  }

  onChangeAllergy(String? itemSelected) {
    dtReport.SickInjuredPersonAllergy = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportNameOfInjuryOrDisease(String? itemSelected) {
    dtReport.SickInjuredPersonNameOfInjuaryOrSickness = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportDegree(String? itemSelected) {
    dtReport.SickInjuredPersonDegree = itemSelected ?? '';
    notifyListeners();
  }

  onConfirmAwarenessTime(DateTime date) {
    dtReport.SenseTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmCommandTime(DateTime date) {
    dtReport.CommandTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmWorkTime(DateTime date) {
    dtReport.AttendanceTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmArrivalOnSite(DateTime date) {
    dtReport.OnsiteArrivalTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmContactTime(DateTime date) {
    dtReport.ContactTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmInCarAccommodation(DateTime date) {
    dtReport.InvehicleTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmStartTransportation(DateTime date) {
    dtReport.StartOfTransportTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmArrivalAtHospital(DateTime date) {
    dtReport.HospitalArrivalTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmFamilyContact(DateTime date) {
    dtReport.FamilyContactTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmPoliceContact(DateTime date) {
    dtReport.PoliceContactTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmReportCashOnDeliveryTime(DateTime date) {
    dtReport.TimeOfArrival = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onConfirmReportReturnTime(DateTime date) {
    dtReport.ReturnTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  //layout 4
  onSelectAccidentTypeInput(String? itemSelected) {
    if (itemSelected != null) dtReport.TypeOfAccident = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onConfirmAccrualDate(DateTime date) {
    dtReport.DateOfOccurrence = Utils.dateTimeToString(date, format: yyyy_MM_dd_);
    notifyListeners();
  }

  onConfirmOccurrenceTime(DateTime date) {
    dtReport.TimeOfOccurrence = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onChangePlaceOfOccurrence(String? itemSelected) {
    dtReport.PlaceOfIncident = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSummaryOfAccidentAndChiefComplaint(String? itemSelected) {
    dtReport.AccidentSummary = itemSelected ?? '';
    notifyListeners();
  }

  onSelectAdl(String? itemSelected) {
    if (itemSelected != null) dtReport.ADL = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onSelectTrafficAccidentCategory(String? itemSelected) {
    if (itemSelected != null) dtReport.TrafficAccidentClassification = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onSelectWitness(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.Witnesses = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onConfirmBystanderCpr(DateTime date) {
    dtReport.BystanderCPR = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onChangeOralInstruction(String? itemSelected) {
    dtReport.VerbalGuidance = itemSelected ?? '';
    notifyListeners();
  }

  //layout 5
  onConfirmObservationTime1(DateTime date) {
    this.observationTime1 = Utils.dateTimeToString(date, format: HH_mm_);
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
    if (itemSelected != null) this.lightReflectionRight1 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onSelectLightReflectionLeft1(String? itemSelected) {
    if (itemSelected != null) this.lightReflectionLeft1 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeBodyTemperature1(String? itemSelected) {
    this.bodyTemperature1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures1(String? itemSelected) {
    if (itemSelected != null) facialFeatures1 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onChangeBleeding1(String? itemSelected) {
    this.bleeding1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence1(List<String> checkeds) {
    if(checkeds.isNotEmpty) this.incontinence1 = checkeds.map((stringChecked) => msClassification006s.firstWhere((msClassification) => msClassification.Value == stringChecked).ClassificationSubCD.toString()).toList().join(comma);
    notifyListeners();
  }

  onSelectVomiting1(String? itemSelected) {
    if (itemSelected != null) this.vomiting1 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeLimb1(String? itemSelected) {
    this.limb1 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectObservationTimeExplanation1(String? itemSelected) {
    if (itemSelected != null) reportObservationTimeExplanation1 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  //layout 6
  onSelectAirwayManagement(String? itemSelected) {
    if (itemSelected != null) dtReport.SecuringAirway = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onSelectForeignMatterRemoval(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.ForeignBodyRemoval = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectSuction(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.Suction = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectArtificialRespiration(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.ArtificialRespiration = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectChestCompression(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.ChestCompressions = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectEcgMonitor(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.ECGMonitor = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onChangeO2Administration(String? itemSelected) {
    dtReport.O2Administration = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  onSelectO2AdministrationTime(DateTime date) {
    dtReport.O2AdministrationTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onSelectSpinalCordMotionLimitation(String? itemSelected) {
    if (itemSelected != null) dtReport.SpinalCordMovementLimitation = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onSelectHemostasis(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.HemostaticTreatment = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectSplintFixation(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.AdductorFixation = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectCoatingTreatment(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.Coating = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onSelectBurnTreatment(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.BurnTreatment = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }

  onChangeBsMeasurement1(String? itemSelected) {
    dtReport.BSMeasurement1 = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  onSelectBsMeasurementTime1(DateTime date) {
    dtReport.BSMeasurementTime1 = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onChangePunctureSite1(String? itemSelected) {
    dtReport.PunctureSite1 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBsMeasurement2(String? itemSelected) {
    dtReport.BSMeasurement2 = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  onSelectBsMeasurementTime2(DateTime date) {
    dtReport.BSMeasurementTime2 = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onChangePunctureSite2(String? itemSelected) {
    dtReport.PunctureSite2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeOthers(String? itemSelected) {
    dtReport.Other = itemSelected ?? '';
    notifyListeners();
  }

  //layout 7
  onConfirmObservationTime2(DateTime date) {
    this.observationTime2 = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onSelectJcs2(String? itemSelected) {
    this.jcs2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE2(String? itemSelected) {
    this.gcsE2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV2(String? itemSelected) {
    this.gcsV2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM2(String? itemSelected) {
    this.gcsM2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing2(String? itemSelected) {
    this.breathing2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse2(String? itemSelected) {
    this.pulse2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp2(String? itemSelected) {
    this.bloodPressureUp2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower2(String? itemSelected) {
    this.bloodPessureLower2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent2(String? itemSelected) {
    this.spo2Percent2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L2(String? itemSelected) {
    this.spo2L2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil2(String? itemSelected) {
    this.rightPupil2 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil2(String? itemSelected) {
    this.leftPupil2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight2(String? itemSelected) {
    if (itemSelected != null) this.lightReflectionRight2 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onSelectLightReflectionLeft2(String? itemSelected) {
    if (itemSelected != null) this.lightReflectionLeft2 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeBodyTemperature2(String? itemSelected) {
    this.bodyTemperature2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures2(String? itemSelected) {
    if (itemSelected != null) facialFeatures2 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onChangeBleeding2(String? itemSelected) {
    this.bleeding2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence2(List<String> checkeds) {
    if(checkeds.isNotEmpty) this.incontinence2 = checkeds.map((stringChecked) => msClassification006s.firstWhere((msClassification) => msClassification.Value == stringChecked).ClassificationSubCD.toString()).toList().join(comma);
    notifyListeners();
  }

  onSelectVomiting2(String? itemSelected) {
    if (itemSelected != null) this.vomiting2 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeLimb2(String? itemSelected) {
    this.limb2 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectObservationTimeExplanation2(String? itemSelected) {
    if (itemSelected != null) reportObservationTimeExplanation2 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  //layout 8
  onConfirmObservationTime3(DateTime date) {
    this.observationTime3 = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onSelectJcs3(String? itemSelected) {
    this.jcs3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsE3(String? itemSelected) {
    this.gcsE3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsV3(String? itemSelected) {
    this.gcsV3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectGcsM3(String? itemSelected) {
    this.gcsM3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBreathing3(String? itemSelected) {
    this.breathing3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangePulse3(String? itemSelected) {
    this.pulse3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureUp3(String? itemSelected) {
    this.bloodPressureUp3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeBloodPressureLower3(String? itemSelected) {
    this.bloodPessureLower3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2Percent3(String? itemSelected) {
    this.spo2Percent3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeSpo2L3(String? itemSelected) {
    this.spo2L3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeRightPupil3(String? itemSelected) {
    this.rightPupil3 = itemSelected ?? '';
    notifyListeners();
  }

  onChangeLeftPupil3(String? itemSelected) {
    this.leftPupil3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectLightReflectionRight3(String? itemSelected) {
    if (itemSelected != null) this.lightReflectionRight3 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onSelectLightReflectionLeft3(String? itemSelected) {
    if (itemSelected != null) this.lightReflectionLeft3 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeBodyTemperature3(String? itemSelected) {
    this.bodyTemperature3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectFacialFeatures3(String? itemSelected) {
    if (itemSelected != null) facialFeatures3 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onChangeBleeding3(String? itemSelected) {
    this.bleeding3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectIncontinence3(List<String> checkeds) {
    if(checkeds.isNotEmpty) this.incontinence3 = checkeds.map((stringChecked) => msClassification006s.firstWhere((msClassification) => msClassification.Value == stringChecked).ClassificationSubCD.toString()).toList().join(comma);
    notifyListeners();
  }

  onSelectVomiting3(String? itemSelected) {
    if (itemSelected != null) this.vomiting3 = yesNothings.indexOf(itemSelected).toString();
    notifyListeners();
  }

  onChangeLimb3(String? itemSelected) {
    this.limb3 = itemSelected ?? '';
    notifyListeners();
  }

  onSelectObservationTimeExplanation3(String? itemSelected) {
    if (itemSelected != null) reportObservationTimeExplanation3 = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  //layout 9
  onChangeGrandTotal(String? itemSelected) {
    dtReport.NumberOfDispatches = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  onChangeCorps(String? itemSelected) {
    dtReport.NumberOfDispatchesPerTeam = int.tryParse(itemSelected ?? '', radix: null);
    notifyListeners();
  }

  //layout 10
  onChangePerceiver(String? itemSelected) {
    dtReport.PerceiverName = itemSelected ?? '';
    notifyListeners();
  }

  onSelectAwarenessType(String? itemSelected) {
    if (itemSelected != null) dtReport.TypeOfDetection = msClassifications.firstWhereOrNull((element) => element.Value == itemSelected)?.ClassificationSubCD;
    notifyListeners();
  }

  onChangeWhistleblower(String? itemSelected) {
    dtReport.CallerName = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReportingPhone(String? itemSelected) {
    dtReport.CallerTEL = itemSelected ?? '';
    notifyListeners();
  }

  //layout 11
  onSelectTransportationMedicalInstitution(String? itemSelected) {
    transportationMedicalInstitution = itemSelected ?? '';
    dtReport.MedicalTransportFacility = msHospitals.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true)?.Name;
    notifyListeners();
  }

  onSelectForwardingMedicalInstitution(String? itemSelected) {
    forwardingMedicalInstitution = itemSelected ?? '';
    dtReport.TransferringMedicalInstitution = msHospitals.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true)?.Name;
    notifyListeners();
  }

  onConfirmTransferSourcePickUpTime(DateTime date) {
    dtReport.TransferSourceReceivingTime = Utils.dateTimeToString(date, format: HH_mm_);
    notifyListeners();
  }

  onChangeTransferReason(String? itemSelected) {
    dtReport.ReasonForTransfer = itemSelected ?? '';
    notifyListeners();
  }

  onChangeReasonForNonDelivery(String? itemSelected) {
    dtReport.ReasonForNotTransferring = itemSelected ?? '';
    notifyListeners();
  }

  onSelectTransportRefusalProcessingRecord(String? itemSelected) {
    if (itemSelected != null) {
      dtReport.RecordOfRefusalOfTransfer = yesNothings.indexOf(itemSelected);
      notifyListeners();
    }
  }


  String? reportersName = "";
  String? dtReportReportersName = "";
  String? reportersAffiliation = "";
  String? reportingClass = "";

  //layout 12
  onSelectReportersName(String? itemSelected) {
    reportersName = itemSelected ?? '';
    MSTeamMember? msTeamMember = msTeamMembers.firstWhereOrNull((e) => itemSelected?.contains(e.Name) == true);
    dtReportReportersName = msTeamMember?.Name;
    reportersAffiliation = msTeamMember?.Name;
    reportersAffiliation = msTeams.firstWhereOrNull((element) => element.TeamCD == msTeamMember?.TeamMemberCD)?.Name ?? '';
    notifyListeners();
  }


  //layout 13
  onChangeOverviewOfTheOutbreak(String? itemSelected) {
    dtReport.SummaryOfOccurrence = itemSelected ?? '';
    notifyListeners();
  }
  onChangeRemars(String? itemSelected) {
    dtReport.Remark = itemSelected ?? '';
    notifyListeners();
  }

  void onSaveToDb() async {
    MSMessage? msMessageAdd = msMessages.firstWhereOrNull((element) => element.CD == '003');
    //join data layout 5, 7 & 8
    dtReport.ObservationTime = Utils.importStringToDb(observationTime1, observationTime2, observationTime3);
    dtReport.JCS = Utils.importStringToDb(jcs1, jcs2, jcs3);
    dtReport.GCSE = Utils.importStringToDb(gcsE1, gcsE2, gcsE3);
    dtReport.GCSV = Utils.importStringToDb(gcsV1, gcsV2, gcsV3);
    dtReport.GCSM = Utils.importStringToDb(gcsM1, gcsM2, gcsM3);
    dtReport.Respiration = Utils.importStringToDb(breathing1, breathing2, breathing3);
    dtReport.Pulse = Utils.importStringToDb(pulse1, pulse2, pulse3);
    dtReport.BloodPressureHigh = Utils.importStringToDb(bloodPressureUp1, bloodPressureUp2, bloodPressureUp3);
    dtReport.BloodPressureLow = Utils.importStringToDb(bloodPessureLower1, bloodPessureLower2, bloodPessureLower3);
    dtReport.SpO2Percent = Utils.importStringToDb(spo2Percent1, spo2Percent2, spo2Percent3);
    dtReport.SpO2Liter = Utils.importStringToDb(spo2L1, spo2L2, spo2L3);
    dtReport.PupilRight = Utils.importStringToDb(rightPupil1, rightPupil2, rightPupil3);
    dtReport.PupilLeft = Utils.importStringToDb(leftPupil1, leftPupil2, leftPupil3);
    dtReport.LightReflexRight = Utils.importStringToDb(lightReflectionRight1, lightReflectionRight2, lightReflectionRight3);
    dtReport.PhotoreflexLeft = Utils.importStringToDb(lightReflectionLeft1, lightReflectionLeft2, lightReflectionLeft3);
    dtReport.BodyTemperature = Utils.importStringToDb(bodyTemperature1, bodyTemperature2, bodyTemperature3);
    dtReport.FacialFeatures = Utils.importStringToDb(facialFeatures1, facialFeatures2, facialFeatures3);
    dtReport.Hemorrhage = Utils.importStringToDb(bleeding1, bleeding2, bleeding3);
    dtReport.Incontinence = Utils.importStringToDb(incontinence1, incontinence2, incontinence3);
    dtReport.Vomiting = Utils.importStringToDb(vomiting1, vomiting2, vomiting3);
    dtReport.Extremities = Utils.importStringToDb(limb1, limb2, limb3);
    dtReport.DescriptionOfObservationTime = Utils.importStringToDb(reportObservationTimeExplanation1, reportObservationTimeExplanation2, reportObservationTimeExplanation3);

    //extra
    dtReport.Remark = null;
    MSTeamMember? msTeamMemberReporterAffiliation = msTeamMembers.firstWhereOrNull((element) => element.Name == dtReport.TeamCaptainName);
    dtReport.ReporterAffiliation = msTeams.firstWhereOrNull((element) => element.TeamCD == msTeamMemberReporterAffiliation?.TeamMemberCD)?.Name;
    dtReport.ReportingClass = msTeamMembers.firstWhereOrNull((element) => element.Name == dtReport.TeamCaptainName)?.Position;

    await dbHelper.putDataToDTReportDb(tableDTReport, [dtReport]);
    //show alert add success

    showDialogGeneral(
      message: msMessageAdd?.MessageContent,
      actionString: msMessageAdd?.Button,
      actionCallback: () {
        _navigationService.back();
        //refresh list report
        eventBus.fire(AddReport());
      },
    );
  }
}
