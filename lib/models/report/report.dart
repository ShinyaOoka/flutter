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
  @JsonKey(name: "SickInjuredPersonMedicalHistroy")
  String? sickInjuredPersonMedicalHistory;
  @observable
  @JsonKey(name: "SickInjuredPersonHistoryHospital")
  String? sickInjuredPersonHistoryHospital;
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
  @ListTimeOfDayConverter()
  @JsonKey(name: "ObservationTime")
  ObservableList<TimeOfDay?>? observationTime;
  @observable
  @ListStringConverter()
  @JsonKey(name: "JCS")
  ObservableList<String?>? jcs;
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
  @JsonKey(name: "PupilRight")
  ObservableList<double?>? pupilRight;
  @observable
  @ListDoubleConverter()
  @JsonKey(name: "PupilLeft")
  ObservableList<double?>? pupilLeft;
  @observable
  @ListDoubleConverter()
  @JsonKey(name: "BodyTemperature")
  ObservableList<double?>? bodyTemperature;
  @observable
  @ListBoolConverter()
  @JsonKey(name: "FacialFeatures_Anguish")
  ObservableList<bool?>? facialFeaturesAnguish;
  @observable
  @JsonKey(name: "OtherOfObservationTime")
  String? otherOfObservationTime;
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
  ClassificationStore? classificationStore;
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  HospitalStore? hospitalStore;



  @action
  setTeam(Team? team) {
    teamCd = team?.teamCd;
  }

  set team(Team? value) {
    setTeam(value);
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

}
