import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:jiffy/jiffy.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/serializers/bool_to_int_converter.dart';
import 'package:ak_azm_flutter/data/serializers/list_converter.dart';
import 'package:ak_azm_flutter/data/serializers/list_time_of_day_converter.dart';
import 'package:ak_azm_flutter/data/serializers/time_of_day_converter.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/fire_station/fire_station.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:tuple/tuple.dart';

part 'report.g.dart';

@JsonSerializable()
class Report extends _Report with _$Report {
  Report();
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

abstract class _Report with Store {
  @observable
  @JsonKey(name: 'ID')
  int? id;
  @observable
  @JsonKey(name: 'TeamCD')
  String? teamCd;
  @observable
  @JsonKey(name: 'TeamCaptainName')
  String? teamCaptainName;
  @observable
  @JsonKey(name: 'TeamMemberName')
  String? teamMemberName;
  @observable
  @JsonKey(name: 'InstitutionalMemberName')
  String? institutionalMemberName;
  @observable
  @JsonKey(name: "LifesaverQualification")
  @IntToBoolConverter()
  bool? lifesaverQualification;
  @observable
  @JsonKey(name: "WithLifeSavers")
  @IntToBoolConverter()
  bool? withLifesavers;
  @observable
  @JsonKey(name: 'Total')
  int? totalCount;
  @observable
  @JsonKey(name: 'Team')
  int? teamCount;
  @observable
  @JsonKey(name: "SickInjuredPersonName")
  String? sickInjuredPersonName;
  @observable
  @JsonKey(name: "SickInjuredPersonKANA")
  String? sickInjuredPersonKana;
  @observable
  @JsonKey(name: "SickInjuredPersonAddress")
  String? sickInjuredPersonAddress;
  @observable
  @JsonKey(name: "SickInjuredPersonGender")
  String? sickInjuredPersonGender;
  @observable
  @JsonKey(name: "SickInjuredPersonBirthDate")
  DateTime? sickInjuredPersonBirthDate;
  @observable
  @JsonKey(name: "SickInjuredPersonTEL")
  String? sickInjuredPersonTel;
  @observable
  @JsonKey(name: "SickInjuredPersonFamily")
  String? sickInjuredPersonFamily;
  @observable
  @JsonKey(name: "SickInjuredPersonFamilyTEL")
  String? sickInjuredPersonFamilyTel;
  @observable
  @JsonKey(name: "SickInjuredPersonMedicalHistroy")
  String? sickInjuredPersonMedicalHistory;
  @observable
  @JsonKey(name: "SickInjuredPersonHistoryHospital")
  String? sickInjuredPersonHistoryHospital;
  @observable
  @JsonKey(name: "SickInjuredPersonKakaritsuke")
  String? sickInjuredPersonKakaritsuke;
  @observable
  @JsonKey(name: "SickInjuredPersonMedication")
  String? sickInjuredPersonMedication;
  @observable
  @JsonKey(name: "SickInjuredPersonMedicationDetail")
  String? sickInjuredPersonMedicationDetail;
  @observable
  @JsonKey(name: "SickInjuredPersonAllergy")
  String? sickInjuredPersonAllergy;
  @observable
  @JsonKey(name: "SickInjuredPersonNameOfInjuryOrSickness")
  String? sickInjuredPersonNameOfInjuryOrSickness;
  @observable
  @JsonKey(name: "SickInjuredPersonDegree")
  String? sickInjuredPersonDegree;
  @computed
  @JsonKey(name: "SickInjuredPersonAge")
  int? get sickInjuredPersonAge {
    if (dateOfOccurrence != null && sickInjuredPersonBirthDate != null) {
      return Jiffy(dateOfOccurrence)
          .add(days: 1)
          .diff(sickInjuredPersonBirthDate, Units.YEAR)
          .toInt();
    }
    return null;
  }

  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "SenseTime")
  TimeOfDay? senseTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "CommandTime")
  TimeOfDay? commandTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "DispatchTime")
  TimeOfDay? dispatchTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "OnSiteArrivalTime")
  TimeOfDay? onSiteArrivalTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "ContactTime")
  TimeOfDay? contactTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "InVehicleTime")
  TimeOfDay? inVehicleTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "StartOfTransportTime")
  TimeOfDay? startOfTransportTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "HospitalArrivalTime")
  TimeOfDay? hospitalArrivalTime;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "FamilyContact")
  bool? familyContact;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "FamilyContactTime")
  TimeOfDay? familyContactTime;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "PoliceContact")
  bool? policeContact;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "PoliceContactTime")
  TimeOfDay? policeContactTime;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "TimeOfArrival")
  TimeOfDay? timeOfArrival;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "ReturnTime")
  TimeOfDay? returnTime;
  @observable
  @JsonKey(name: "TypeOfAccident")
  String? typeOfAccident;
  @observable
  @JsonKey(name: "DateOfOccurrence")
  DateTime? dateOfOccurrence;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "TimeOfOccurrence")
  TimeOfDay? timeOfOccurrence;
  @observable
  @JsonKey(name: "PlaceOfIncident")
  String? placeOfIncident;
  @observable
  @JsonKey(name: "PlaceOfDispatch")
  String? placeOfDispatch;
  @observable
  @JsonKey(name: "AccidentSummary")
  String? accidentSummary;
  @observable
  @JsonKey(name: "ADL")
  String? adl;
  @observable
  @JsonKey(name: "TrafficAccidentClassification")
  String? trafficAccidentClassification;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "TrafficAccident_Unknown")
  bool? trafficAccidentUnknown;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "TrafficAccident_Seatbelt")
  bool? trafficAccidentSeatbelt;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "TrafficAccident_Childseat")
  bool? trafficAccidentChildseat;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "TrafficAccident_Airbag")
  bool? trafficAccidentAirbag;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "TrafficAccident_Helmet")
  bool? trafficAccidentHelmet;
  @observable
  @JsonKey(name: "Witnesses")
  @IntToBoolConverter()
  bool? witnesses;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "BystanderCPR")
  TimeOfDay? bystanderCpr;
  @observable
  @JsonKey(name: "VerbalGuidance")
  bool? verbalGuidance;
  @observable
  @JsonKey(name: "VerbalGuidanceText")
  String? verbalGuidanceText;
  @observable
  @ListTimeOfDayConverter()
  @JsonKey(name: "ObservationTime")
  ObservableList<TimeOfDay?>? observationTime;
  @observable
  @ListStringConverter()
  @JsonKey(name: "JCS")
  ObservableList<String?>? jcs;
  @observable
  @ListStringConverter()
  @JsonKey(name: "GCS_E")
  ObservableList<String?>? gcsE;
  @observable
  @ListStringConverter()
  @JsonKey(name: "GCS_V")
  ObservableList<String?>? gcsV;
  @observable
  @ListStringConverter()
  @JsonKey(name: "GCS_M")
  ObservableList<String?>? gcsM;
  @observable
  @ListIntConverter()
  @JsonKey(name: "Respiration")
  ObservableList<int?>? respiration;
  @observable
  @ListIntConverter()
  @JsonKey(name: "Pulse")
  ObservableList<int?>? pulse;
  @observable
  @ListIntConverter()
  @JsonKey(name: "BloodPressure_High")
  ObservableList<int?>? bloodPressureHigh;
  @observable
  @ListIntConverter()
  @JsonKey(name: "BloodPressure_Low")
  ObservableList<int?>? bloodPressureLow;
  @observable
  @ListIntConverter()
  @JsonKey(name: "SpO2Percent")
  ObservableList<int?>? spO2Percent;
  @observable
  @ListDoubleConverter()
  @JsonKey(name: "SpO2Liter")
  ObservableList<double?>? spO2Liter;
  @observable
  @ListIntConverter()
  @JsonKey(name: "PupilRight")
  ObservableList<int?>? pupilRight;
  @observable
  @ListIntConverter()
  @JsonKey(name: "PupilLeft")
  ObservableList<int?>? pupilLeft;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "LightReflexRight")
  ObservableList<bool?>? lightReflexRight;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "LightReflexLeft")
  ObservableList<bool?>? lightReflexLeft;
  @observable
  @ListDoubleConverter()
  @JsonKey(name: "BodyTemperature")
  ObservableList<double?>? bodyTemperature;
  @observable
  @ListStringConverter()
  @JsonKey(name: "FacialFeatures")
  ObservableList<String?>? facialFeatures;
  @observable
  @ListStringConverter()
  @JsonKey(name: "Hemorrhage")
  ObservableList<String?>? hemorrhage;
  @observable
  @ListStringConverter()
  @JsonKey(name: "Incontinence")
  ObservableList<String?>? incontinence;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "Vomiting")
  ObservableList<bool?>? vomiting;
  @observable
  @ListStringConverter()
  @JsonKey(name: "Extremities")
  ObservableList<String?>? extremities;
  @observable
  @ListStringConverter()
  @JsonKey(name: "DescriptionOfObservationTime")
  ObservableList<String?>? descriptionOfObservationTime;
  @observable
  @ListStringConverter()
  @JsonKey(name: "EachECG")
  ObservableList<String?>? eachEcg;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "EachHemostasis")
  ObservableList<bool?>? eachHemostasis;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "EachSuction")
  ObservableList<bool?>? eachSuction;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess1")
  ObservableList<String?>? otherProcess1;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess2")
  ObservableList<String?>? otherProcess2;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess3")
  ObservableList<String?>? otherProcess3;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess4")
  ObservableList<String?>? otherProcess4;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess5")
  ObservableList<String?>? otherProcess5;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess6")
  ObservableList<String?>? otherProcess6;
  @observable
  @ListStringConverter()
  @JsonKey(name: "OtherProcess7")
  ObservableList<String?>? otherProcess7;
  @observable
  @JsonKey(name: "OtherOfObservationTime")
  String? otherOfObservationTime;
  @observable
  @JsonKey(name: "SecuringAirway")
  String? securingAirway;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "ForeignBodyRemoval")
  bool? foreignBodyRemoval;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "Suction")
  bool? suction;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "ArtificialRespiration")
  bool? artificialRespiration;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "ChestCompressions")
  bool? chestCompressions;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "ECGMonitor")
  bool? ecgMonitor;
  @observable
  @JsonKey(name: "O2Administration")
  double? o2Administration;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "O2AdministrationTime")
  TimeOfDay? o2AdministrationTime;
  @observable
  @JsonKey(name: "LimitationOfSpinalMotion")
  String? limitationOfSpinalMotion;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "HemostaticTreatment")
  bool? hemostaticTreatment;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "AdductorFixation")
  bool? adductorFixation;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "Coating")
  bool? coating;
  @observable
  @IntToBoolConverter()
  @JsonKey(name: "BurnTreatment")
  bool? burnTreatment;
  @observable
  @JsonKey(name: "BSMeasurement1")
  int? bsMeasurement1;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "BSMeasurementTime1")
  TimeOfDay? bsMeasurementTime1;
  @observable
  @JsonKey(name: "PunctureSite1")
  String? punctureSite1;
  @observable
  @JsonKey(name: "BSMeasurement2")
  int? bsMeasurement2;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "BSMeasurementTime2")
  TimeOfDay? bsMeasurementTime2;
  @observable
  @JsonKey(name: "PunctureSite2")
  String? punctureSite2;
  @observable
  @JsonKey(name: "Other")
  String? other;
  @observable
  @JsonKey(name: "PerceiverName")
  String? perceiverName;
  @observable
  @JsonKey(name: "TypeOfDetection")
  String? typeOfDetection;
  @observable
  @JsonKey(name: "CallerName")
  String? callerName;
  @observable
  @JsonKey(name: "CallerTEL")
  String? callerTel;
  @observable
  @JsonKey(name: "MedicalTransportFacility")
  String? medicalTransportFacility;
  @observable
  @JsonKey(name: "OtherMedicalTransportFacility")
  String? otherMedicalTransportFacility;
  @observable
  @JsonKey(name: "TransferringMedicalInstitution")
  String? transferringMedicalInstitution;
  @observable
  @JsonKey(name: "OtherTransferringMedicalInstitution")
  String? otherTransferringMedicalInstitution;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "TransferSourceReceivingTime")
  TimeOfDay? transferSourceReceivingTime;
  @observable
  @JsonKey(name: "ReasonForTransfer")
  String? reasonForTransfer;
  @observable
  @JsonKey(name: "ReasonForNotTransferring")
  String? reasonForNotTransferring;
  @observable
  @JsonKey(name: "RecordOfRefusalOfTransfer")
  @IntToBoolConverter()
  bool? recordOfRefusalOfTransfer;
  @observable
  @JsonKey(name: "NameOfReporter")
  String? nameOfReporter;
  @observable
  @JsonKey(name: "AffiliationOfReporter")
  String? affiliationOfReporter;
  @observable
  @JsonKey(name: "PositionOfReporter")
  String? positionOfReporter;
  @observable
  @JsonKey(name: "SummaryOfOccurrence")
  String? summaryOfOccurrence;
  @observable
  @JsonKey(name: "Remarks")
  String? remarks;
  @observable
  String? entryName;
  @observable
  String? entryMachine;
  @observable
  @JsonKey(name: "EntryDate")
  DateTime? entryDate;
  @observable
  String? updateName;
  @observable
  String? updateMachine;
  @observable
  @JsonKey(name: "UpdateDate")
  DateTime? updateDate;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  TeamStore? teamStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  FireStationStore? fireStationStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  ClassificationStore? classificationStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  HospitalStore? hospitalStore;

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Team? get team {
    assert(teamStore != null);
    return teamStore!.teams[teamCd];
  }

  @action
  setTeam(Team? team) {
    teamCd = team?.teamCd;
  }

  set team(Team? value) {
    setTeam(value);
  }

  FireStation? get fireStation {
    assert(fireStationStore != null);
    return fireStationStore!.fireStations[team?.fireStationCd];
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get gender {
    assert(classificationStore != null);
    return sickInjuredPersonGender != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.genderCode, sickInjuredPersonGender!)]
        : null;
  }

  @action
  setGender(Classification? value) {
    sickInjuredPersonGender = value?.classificationSubCd;
  }

  set gender(Classification? value) {
    setGender(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get medication {
    assert(classificationStore != null);
    return sickInjuredPersonMedication != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.medicationCode, sickInjuredPersonMedication!)]
        : null;
  }

  @action
  setMedication(Classification? value) {
    sickInjuredPersonMedication = value?.classificationSubCd;
  }

  set medication(Classification? value) {
    setMedication(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get degree {
    assert(classificationStore != null);
    return sickInjuredPersonDegree != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.degreeCode, sickInjuredPersonDegree!)]
        : null;
  }

  @action
  setDegree(Classification? value) {
    sickInjuredPersonDegree = value?.classificationSubCd;
  }

  set degree(Classification? value) {
    setDegree(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get detectionType {
    assert(classificationStore != null);
    return typeOfDetection != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.typeOfDetectionCode, typeOfDetection!)]
        : null;
  }

  @action
  setDetectionType(Classification? value) {
    typeOfDetection = value?.classificationSubCd;
  }

  set detectionType(Classification? value) {
    setDetectionType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get accidentType {
    assert(classificationStore != null);
    return typeOfAccident != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.typeOfAccidentCode, typeOfAccident!)]
        : null;
  }

  @action
  setAccidentType(Classification? value) {
    typeOfAccident = value?.classificationSubCd;
  }

  set accidentType(Classification? value) {
    setAccidentType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Hospital? get medicalTransportFacilityType {
    assert(hospitalStore != null);
    return hospitalStore!.hospitals[medicalTransportFacility];
  }

  @action
  setMedicalTransportFacilityType(Hospital? hospital) {
    medicalTransportFacility = hospital?.hospitalCd;
  }

  set medicalTransportFacilityType(Hospital? value) {
    setMedicalTransportFacilityType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Hospital? get transferringMedicalInstitutionType {
    assert(hospitalStore != null);
    return hospitalStore!.hospitals[transferringMedicalInstitution];
  }

  @action
  setTransferringMedicalInstitutionType(Hospital? hospital) {
    transferringMedicalInstitution = hospital?.hospitalCd;
  }

  set transferringMedicalInstitutionType(Hospital? value) {
    setTransferringMedicalInstitutionType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get trafficAccidentType {
    assert(classificationStore != null);
    return trafficAccidentClassification != null
        ? classificationStore!.classifications[Tuple2(
            AppConstants.trafficAccidentCode, trafficAccidentClassification!)]
        : null;
  }

  @action
  setTrafficAccidentType(Classification? value) {
    trafficAccidentClassification = value?.classificationSubCd;
  }

  set trafficAccidentType(Classification? value) {
    setTrafficAccidentType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get adlType {
    assert(classificationStore != null);
    return adl != null
        ? classificationStore!
            .classifications[Tuple2(AppConstants.adlCode, adl!)]
        : null;
  }

  @action
  setAdlType(Classification? value) {
    adl = value?.classificationSubCd;
  }

  set adlType(Classification? value) {
    setAdlType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get positionOfReporterType {
    assert(classificationStore != null);
    return positionOfReporter != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.positionOfReporterCode, positionOfReporter!)]
        : null;
  }

  @action
  setPositionOfReporterType(Classification? value) {
    positionOfReporter = value?.classificationSubCd;
  }

  set positionOfReporterType(Classification? value) {
    setPositionOfReporterType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get securingAirwayType {
    assert(classificationStore != null);
    return securingAirway != null
        ? classificationStore!.classifications[
            Tuple2(AppConstants.securingAirwayCode, securingAirway!)]
        : null;
  }

  @action
  setSecuringAirwayType(Classification? value) {
    securingAirway = value?.classificationSubCd;
  }

  set securingAirwayType(Classification? value) {
    setSecuringAirwayType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get limitationOfSpinalMotionType {
    assert(classificationStore != null);
    return limitationOfSpinalMotion != null
        ? classificationStore!.classifications[Tuple2(
            AppConstants.limitationOfSpinalMotionCode,
            limitationOfSpinalMotion!)]
        : null;
  }

  @action
  setSpinalCordMovementLimitationType(Classification? value) {
    limitationOfSpinalMotion = value?.classificationSubCd;
  }

  set limitationOfSpinalMotionType(Classification? value) {
    setSpinalCordMovementLimitationType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get jcsTypes {
    assert(classificationStore != null);
    return jcs
            ?.map((element) => element != null
                ? classificationStore!
                    .classifications[Tuple2(AppConstants.jcsCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setJcsTypes(List<Classification?> values) {
    jcs = values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set jcsTypes(List<Classification?> values) {
    setJcsTypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get gcsETypes {
    assert(classificationStore != null);
    return gcsE
            ?.map((element) => element != null
                ? classificationStore!
                    .classifications[Tuple2(AppConstants.gcsECode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setGcsETypes(List<Classification?> values) {
    gcsE = values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set gcsETypes(List<Classification?> values) {
    setGcsETypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get gcsVTypes {
    return gcsV
            ?.map((element) => element != null
                ? classificationStore!
                    .classifications[Tuple2(AppConstants.gcsVCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setGcsVTypes(List<Classification?> values) {
    gcsV = values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set gcsVTypes(List<Classification?> values) {
    setGcsVTypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get gcsMTypes {
    assert(classificationStore != null);
    return gcsM
            ?.map((element) => element != null
                ? classificationStore!
                    .classifications[Tuple2(AppConstants.gcsMCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setGcsMTypes(List<Classification?> values) {
    gcsM = values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set gcsMTypes(List<Classification?> values) {
    setGcsMTypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get facialFeatureTypes {
    assert(classificationStore != null);
    return facialFeatures
            ?.map((element) => element != null
                ? classificationStore!.classifications[
                    Tuple2(AppConstants.facialFeaturesCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setFacialFeatureTypes(List<Classification?> values) {
    facialFeatures =
        values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set facialFeatureTypes(List<Classification?> values) {
    setFacialFeatureTypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get incontinenceTypes {
    assert(classificationStore != null);
    return incontinence
            ?.map((element) => element != null
                ? classificationStore!.classifications[
                    Tuple2(AppConstants.incontinenceCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setIncontinenceTypes(List<Classification?> values) {
    incontinence =
        values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set incontinenceTypes(List<Classification?> values) {
    setIncontinenceTypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get observationTimeDescriptionTypes {
    assert(classificationStore != null);
    return descriptionOfObservationTime
            ?.map((element) => element != null
                ? classificationStore!.classifications[Tuple2(
                    AppConstants.descriptionOfObservationTimeCode, element)]
                : null)
            .toList() ??
        [];
  }

  @action
  setObservationTimeDescriptionTypes(List<Classification?> values) {
    descriptionOfObservationTime =
        values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set observationTimeDescriptionTypes(List<Classification?> values) {
    setObservationTimeDescriptionTypes(values);
  }
}
