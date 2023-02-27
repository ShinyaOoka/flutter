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
import 'package:ak_azm_flutter/models/team_member/team_member.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/team_member/team_member_store.dart';
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
  @JsonKey(name: "AttendanceTime")
  TimeOfDay? attendanceTime;
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
  @TimeOfDayConverter()
  @JsonKey(name: "FamilyContactTime")
  TimeOfDay? familyContactTime;
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
  @JsonKey(name: "AccidentSummary")
  String? accidentSummary;
  @observable
  @JsonKey(name: "ADL")
  String? adl;
  @observable
  @JsonKey(name: "TrafficAccidentClassification")
  String? trafficAccidentClassification;
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
  String? verbalGuidance;
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
  @ListIntConverter()
  @JsonKey(name: "SpO2Liter")
  ObservableList<int?>? spO2Liter;
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
  int? o2Administration;
  @observable
  @TimeOfDayConverter()
  @JsonKey(name: "O2AdministrationTime")
  TimeOfDay? o2AdministrationTime;
  @observable
  @JsonKey(name: "SpinalCordMovementLimitation")
  String? spinalCordMovementLimitation;
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
  @JsonKey(name: "TransferringMedicalInstitution")
  String? transferringMedicalInstitution;
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
  DateTime? entryDate;
  @observable
  String? updateName;
  @observable
  String? updateMachine;
  @observable
  DateTime? updateDate;

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  TeamStore? teamStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  TeamMemberStore? teamMemberStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  FireStationStore? fireStationStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  ClassificationStore? classificationStore;

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'TeamCD': teamCd,
      'TeamCaptainName': teamCaptainName,
      'TeamMemberName': teamMemberName,
      'InstitutionalMemberName': institutionalMemberName,
      'LifesaverQualification': lifesaverQualification,
      'WithLifeSavers': withLifesavers,
      'Total': totalCount,
      'Team': teamCount,
      "SickInjuredPersonName": sickInjuredPersonName,
      "SickInjuredPersonKANA": sickInjuredPersonKana,
      "SickInjuredPersonAddress": sickInjuredPersonAddress,
      "SickInjuredPersonGender": sickInjuredPersonGender,
      "SickInjuredPersonBirthDate": sickInjuredPersonBirthDate,
      "SickInjuredPersonTEL": sickInjuredPersonTel,
      "SickInjuredPersonFamilyTEL": sickInjuredPersonFamilyTel,
      "SickInjuredPersonMedicalHistroy": sickInjuredPersonMedicalHistory,
      "SickInjuredPersonHistoryHospital": sickInjuredPersonHistoryHospital,
      "SickInjuredPersonKakaritsuke": sickInjuredPersonKakaritsuke,
      "SickInjuredPersonMedication": sickInjuredPersonMedication,
      "SickInjuredPersonMedicationDetail": sickInjuredPersonMedicationDetail,
      "SickInjuredPersonAllergy": sickInjuredPersonAllergy,
      "SickInjuredPersonNameOfInjuryOrSickness":
          sickInjuredPersonNameOfInjuryOrSickness,
      "SickInjuredPersonDegree": sickInjuredPersonDegree,
      "SickInjuredPersonAge": sickInjuredPersonAge,
      "SickInjuredPersonFamily": sickInjuredPersonFamily,
      "SenseTime": senseTime,
      "CommandTime": commandTime,
      "AttendanceTime": attendanceTime,
      "OnSiteArrivalTime": onSiteArrivalTime,
      "ContactTime": contactTime,
      "InVehicleTime": inVehicleTime,
      "StartOfTransportTime": startOfTransportTime,
      "HospitalArrivalTime": hospitalArrivalTime,
      "FamilyContactTime": familyContactTime,
      "PoliceContactTime": policeContactTime,
      "TimeOfArrival": timeOfArrival,
      "ReturnTime": returnTime,
      "TypeOfAccident": typeOfAccident,
      "DateOfOccurrence": dateOfOccurrence,
      "TimeOfOccurrence": timeOfOccurrence,
      "PlaceOfIncident": placeOfIncident,
      "AccidentSummary": accidentSummary,
      "ADL": adl,
      "TrafficAccidentClassification": trafficAccidentClassification,
      "Witnesses": witnesses,
      "BystanderCPR": bystanderCpr,
      "VerbalGuidance": verbalGuidance,
      "ObservationTime": observationTime,
      "JCS": jcs,
      "GCS_E": gcsE,
      "GCS_V": gcsV,
      "GCS_M": gcsM,
      "Respiration": respiration,
      "Pulse": pulse,
      "BloodPressure_High": bloodPressureHigh,
      "BloodPressure_Low": bloodPressureLow,
      "SpO2Percent": spO2Percent,
      "SpO2Liter": spO2Liter,
      "PupilRight": pupilRight,
      "PupilLeft": pupilLeft,
      "LightReflexRight": lightReflexRight,
      "LightReflexLeft": lightReflexLeft,
      "BodyTemperature": bodyTemperature,
      "FacialFeatures": facialFeatures,
      "Hemorrhage": hemorrhage,
      "Incontinence": incontinence,
      "Vomiting": vomiting,
      "Extremities": extremities,
      "DescriptionOfObservationTime": descriptionOfObservationTime,
      "OtherOfObservationTime": otherOfObservationTime,
      "SecuringAirway": securingAirway,
      "ForeignBodyRemoval": foreignBodyRemoval,
      "Suction": suction,
      "ArtificialRespiration": artificialRespiration,
      "ChestCompressions": chestCompressions,
      "ECGMonitor": ecgMonitor,
      "O2Administration": o2Administration,
      "O2AdministrationTime": o2AdministrationTime,
      "SpinalCordMovementLimitation": spinalCordMovementLimitation,
      "HemostaticTreatment": hemostaticTreatment,
      "AdductorFixation": adductorFixation,
      "Coating": coating,
      "BurnTreatment": burnTreatment,
      "BSMeasurement1": bsMeasurement1,
      "BSMeasurementTime1": bsMeasurementTime1,
      "PunctureSite1": punctureSite1,
      "BSMeasurement2": bsMeasurement2,
      "BSMeasurementTime2": bsMeasurementTime2,
      "PunctureSite2": punctureSite2,
      "Other": other,
      "PerceiverName": perceiverName,
      "TypeOfDetection": typeOfDetection,
      "CallerName": callerName,
      "CallerTEL": callerTel,
      "MedicalTransportFacility": medicalTransportFacility,
      "TransferringMedicalInstitution": transferringMedicalInstitution,
      "TransferSourceReceivingTime": transferSourceReceivingTime,
      "ReasonForTransfer": reasonForTransfer,
      "ReasonForNotTransferring": reasonForNotTransferring,
      "RecordOfRefusalOfTransfer": recordOfRefusalOfTransfer,
      "NameOfReporter": nameOfReporter,
      "AffiliationOfReporter": affiliationOfReporter,
      "PositionOfReporter": positionOfReporter,
      "SummaryOfOccurrence": summaryOfOccurrence,
      "Remarks": remarks
    };
  }

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
    assert(value?.classificationCd == AppConstants.genderCode);
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
    assert(value?.classificationCd == AppConstants.medicationCode);
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
    assert(value?.classificationCd == AppConstants.medicationCode);
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
    assert(value?.classificationCd == AppConstants.typeOfDetectionCode);
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
    assert(value?.classificationCd == AppConstants.typeOfAccidentCode);
    typeOfAccident = value?.classificationSubCd;
  }

  set accidentType(Classification? value) {
    setAccidentType(value);
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
    assert(value?.classificationCd == AppConstants.trafficAccidentCode);
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
    assert(value?.classificationCd == AppConstants.adlCode);
    adl = value?.classificationSubCd;
  }

  set adlType(Classification? value) {
    setAdlType(value);
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
    assert(value?.classificationCd == AppConstants.securingAirwayCode);
    securingAirway = value?.classificationSubCd;
  }

  set securingAirwayType(Classification? value) {
    setSecuringAirwayType(value);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  Classification? get spinalCordMovementLimitationType {
    assert(classificationStore != null);
    return spinalCordMovementLimitation != null
        ? classificationStore!.classifications[Tuple2(
            AppConstants.spinalCordMovementLimitationCode,
            spinalCordMovementLimitation!)]
        : null;
  }

  @action
  setSpinalCordMovementLimitationType(Classification? value) {
    assert(value?.classificationCd ==
        AppConstants.spinalCordMovementLimitationCode);
    spinalCordMovementLimitation = value?.classificationSubCd;
  }

  set spinalCordMovementLimitationType(Classification? value) {
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
    for (var element in values) {
      assert(
          element == null || element.classificationCd == AppConstants.jcsCode);
    }
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
    for (var element in values) {
      assert(
          element == null || element.classificationCd == AppConstants.gcsECode);
    }
    gcsE = values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set gcsETypes(List<Classification?> values) {
    setGcsETypes(values);
  }

  @computed
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Classification?> get gcsVTypes {
    assert(classificationStore != null);
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
    for (var element in values) {
      assert(
          element == null || element.classificationCd == AppConstants.gcsVCode);
    }
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
    for (var element in values) {
      assert(
          element == null || element.classificationCd == AppConstants.gcsMCode);
    }
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
    for (var element in values) {
      assert(element == null ||
          element.classificationCd == AppConstants.facialFeaturesCode);
    }
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
    for (var element in values) {
      assert(element == null ||
          element.classificationCd == AppConstants.incontinenceCode);
    }
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
    for (var element in values) {
      assert(element == null ||
          element.classificationCd ==
              AppConstants.descriptionOfObservationTimeCode);
    }
    descriptionOfObservationTime =
        values.map((e) => e?.classificationSubCd).toList().asObservable();
  }

  set observationTimeDescriptionTypes(List<Classification?> values) {
    setObservationTimeDescriptionTypes(values);
  }
}
