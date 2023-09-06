// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report()
  ..id = json['ID'] as int?
  ..teamCd = json['TeamCD'] as String?
  ..teamCaptainName = json['TeamCaptainName'] as String?
  ..sickInjuredPersonName = json['SickInjuredPersonName'] as String?
  ..sickInjuredPersonKana = json['SickInjuredPersonKANA'] as String?
  ..sickInjuredPersonAddress = json['SickInjuredPersonAddress'] as String?
  ..sickInjuredPersonGender = json['SickInjuredPersonGender'] as String?
  ..sickInjuredPersonBirthDate = json['SickInjuredPersonBirthDate'] == null
      ? null
      : DateTime.parse(json['SickInjuredPersonBirthDate'] as String)
  ..sickInjuredPersonTel = json['SickInjuredPersonTEL'] as String?
  ..sickInjuredPersonMedicalHistory =
      json['SickInjuredPersonMedicalHistroy'] as String?
  ..sickInjuredPersonHistoryHospital =
      json['SickInjuredPersonHistoryHospital'] as String?
  ..senseTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['SenseTime'], const TimeOfDayConverter().fromJson)
  ..onSiteArrivalTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['OnSiteArrivalTime'], const TimeOfDayConverter().fromJson)
  ..contactTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['ContactTime'], const TimeOfDayConverter().fromJson)
  ..inVehicleTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['InVehicleTime'], const TimeOfDayConverter().fromJson)
  ..startOfTransportTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['StartOfTransportTime'], const TimeOfDayConverter().fromJson)
  ..hospitalArrivalTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['HospitalArrivalTime'], const TimeOfDayConverter().fromJson)
  ..familyContact = _$JsonConverterFromJson<int, bool>(
      json['FamilyContact'], const IntToBoolConverter().fromJson)
  ..typeOfAccident = json['TypeOfAccident'] as String?
  ..dateOfOccurrence = json['DateOfOccurrence'] == null
      ? null
      : DateTime.parse(json['DateOfOccurrence'] as String)
  ..timeOfOccurrence = _$JsonConverterFromJson<String, TimeOfDay>(
      json['TimeOfOccurrence'], const TimeOfDayConverter().fromJson)
  ..placeOfIncident = json['PlaceOfIncident'] as String?
  ..accidentSummary = json['AccidentSummary'] as String?
  ..observationTime =
      _$JsonConverterFromJson<String, ObservableList<TimeOfDay?>>(
          json['ObservationTime'], const ListTimeOfDayConverter().fromJson)
  ..jcs = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['JCS'], const ListStringConverter().fromJson)
  ..gcsV = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['GCS_V'], const ListStringConverter().fromJson)
  ..gcsM = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['GCS_M'], const ListStringConverter().fromJson)
  ..respiration = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['Respiration'], const ListIntConverter().fromJson)
  ..pulse = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['Pulse'], const ListIntConverter().fromJson)
  ..bloodPressureHigh = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['BloodPressure_High'], const ListIntConverter().fromJson)
  ..bloodPressureLow = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['BloodPressure_Low'], const ListIntConverter().fromJson)
  ..spO2Percent = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['SpO2Percent'], const ListIntConverter().fromJson)
  ..pupilRight = _$JsonConverterFromJson<String, ObservableList<double?>>(
      json['PupilRight'], const ListDoubleConverter().fromJson)
  ..pupilLeft = _$JsonConverterFromJson<String, ObservableList<double?>>(
      json['PupilLeft'], const ListDoubleConverter().fromJson)
  ..bodyTemperature = _$JsonConverterFromJson<String, ObservableList<double?>>(
      json['BodyTemperature'], const ListDoubleConverter().fromJson)
  ..facialFeaturesAnguish =
      _$JsonConverterFromJson<String, ObservableList<bool?>>(
          json['FacialFeatures_Anguish'], const ListBoolConverter().fromJson)
  ..otherOfObservationTime = json['OtherOfObservationTime'] as String?
  ..entryName = json['entryName'] as String?
  ..entryMachine = json['entryMachine'] as String?
  ..entryDate = json['EntryDate'] == null
      ? null
      : DateTime.parse(json['EntryDate'] as String)
  ..updateName = json['updateName'] as String?
  ..updateMachine = json['updateMachine'] as String?
  ..updateDate = json['UpdateDate'] == null
      ? null
      : DateTime.parse(json['UpdateDate'] as String);

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'ID': instance.id,
      'TeamCD': instance.teamCd,
      'TeamCaptainName': instance.teamCaptainName,
      'SickInjuredPersonName': instance.sickInjuredPersonName,
      'SickInjuredPersonKANA': instance.sickInjuredPersonKana,
      'SickInjuredPersonAddress': instance.sickInjuredPersonAddress,
      'SickInjuredPersonGender': instance.sickInjuredPersonGender,
      'SickInjuredPersonBirthDate':
          instance.sickInjuredPersonBirthDate?.toIso8601String(),
      'SickInjuredPersonTEL': instance.sickInjuredPersonTel,
      'SickInjuredPersonMedicalHistroy':
          instance.sickInjuredPersonMedicalHistory,
      'SickInjuredPersonHistoryHospital':
          instance.sickInjuredPersonHistoryHospital,
      'SenseTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.senseTime, const TimeOfDayConverter().toJson),
      'OnSiteArrivalTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.onSiteArrivalTime, const TimeOfDayConverter().toJson),
      'ContactTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.contactTime, const TimeOfDayConverter().toJson),
      'InVehicleTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.inVehicleTime, const TimeOfDayConverter().toJson),
      'StartOfTransportTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.startOfTransportTime, const TimeOfDayConverter().toJson),
      'HospitalArrivalTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.hospitalArrivalTime, const TimeOfDayConverter().toJson),
      'FamilyContact': _$JsonConverterToJson<int, bool>(
          instance.familyContact, const IntToBoolConverter().toJson),
      'TypeOfAccident': instance.typeOfAccident,
      'DateOfOccurrence': instance.dateOfOccurrence?.toIso8601String(),
      'TimeOfOccurrence': _$JsonConverterToJson<String, TimeOfDay>(
          instance.timeOfOccurrence, const TimeOfDayConverter().toJson),
      'PlaceOfIncident': instance.placeOfIncident,
      'AccidentSummary': instance.accidentSummary,
      'ObservationTime':
          _$JsonConverterToJson<String, ObservableList<TimeOfDay?>>(
              instance.observationTime, const ListTimeOfDayConverter().toJson),
      'JCS': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.jcs, const ListStringConverter().toJson),
      'GCS_V': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.gcsV, const ListStringConverter().toJson),
      'GCS_M': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.gcsM, const ListStringConverter().toJson),
      'Respiration': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.respiration, const ListIntConverter().toJson),
      'Pulse': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.pulse, const ListIntConverter().toJson),
      'BloodPressure_High': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.bloodPressureHigh, const ListIntConverter().toJson),
      'BloodPressure_Low': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.bloodPressureLow, const ListIntConverter().toJson),
      'SpO2Percent': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.spO2Percent, const ListIntConverter().toJson),
      'PupilRight': _$JsonConverterToJson<String, ObservableList<double?>>(
          instance.pupilRight, const ListDoubleConverter().toJson),
      'PupilLeft': _$JsonConverterToJson<String, ObservableList<double?>>(
          instance.pupilLeft, const ListDoubleConverter().toJson),
      'BodyTemperature': _$JsonConverterToJson<String, ObservableList<double?>>(
          instance.bodyTemperature, const ListDoubleConverter().toJson),
      'FacialFeatures_Anguish':
          _$JsonConverterToJson<String, ObservableList<bool?>>(
              instance.facialFeaturesAnguish, const ListBoolConverter().toJson),
      'OtherOfObservationTime': instance.otherOfObservationTime,
      'entryName': instance.entryName,
      'entryMachine': instance.entryMachine,
      'EntryDate': instance.entryDate?.toIso8601String(),
      'updateName': instance.updateName,
      'updateMachine': instance.updateMachine,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Report on _Report, Store {
  Computed<int?>? _$sickInjuredPersonAgeComputed;

  @override
  int? get sickInjuredPersonAge => (_$sickInjuredPersonAgeComputed ??=
          Computed<int?>(() => super.sickInjuredPersonAge,
              name: '_Report.sickInjuredPersonAge'))
      .value;
  Computed<Classification?>? _$genderComputed;

  @override
  Classification? get gender => (_$genderComputed ??=
          Computed<Classification?>(() => super.gender, name: '_Report.gender'))
      .value;
  Computed<Classification?>? _$accidentTypeComputed;

  @override
  Classification? get accidentType => (_$accidentTypeComputed ??=
          Computed<Classification?>(() => super.accidentType,
              name: '_Report.accidentType'))
      .value;
  Computed<List<Classification?>>? _$jcsTypesComputed;

  @override
  List<Classification?> get jcsTypes => (_$jcsTypesComputed ??=
          Computed<List<Classification?>>(() => super.jcsTypes,
              name: '_Report.jcsTypes'))
      .value;
  Computed<List<Classification?>>? _$gcsVTypesComputed;

  @override
  List<Classification?> get gcsVTypes => (_$gcsVTypesComputed ??=
          Computed<List<Classification?>>(() => super.gcsVTypes,
              name: '_Report.gcsVTypes'))
      .value;
  Computed<List<Classification?>>? _$gcsMTypesComputed;

  @override
  List<Classification?> get gcsMTypes => (_$gcsMTypesComputed ??=
          Computed<List<Classification?>>(() => super.gcsMTypes,
              name: '_Report.gcsMTypes'))
      .value;

  late final _$idAtom = Atom(name: '_Report.id', context: context);

  @override
  int? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$teamCdAtom = Atom(name: '_Report.teamCd', context: context);

  @override
  String? get teamCd {
    _$teamCdAtom.reportRead();
    return super.teamCd;
  }

  @override
  set teamCd(String? value) {
    _$teamCdAtom.reportWrite(value, super.teamCd, () {
      super.teamCd = value;
    });
  }

  late final _$teamCaptainNameAtom =
      Atom(name: '_Report.teamCaptainName', context: context);

  @override
  String? get teamCaptainName {
    _$teamCaptainNameAtom.reportRead();
    return super.teamCaptainName;
  }

  @override
  set teamCaptainName(String? value) {
    _$teamCaptainNameAtom.reportWrite(value, super.teamCaptainName, () {
      super.teamCaptainName = value;
    });
  }

  late final _$sickInjuredPersonNameAtom =
      Atom(name: '_Report.sickInjuredPersonName', context: context);

  @override
  String? get sickInjuredPersonName {
    _$sickInjuredPersonNameAtom.reportRead();
    return super.sickInjuredPersonName;
  }

  @override
  set sickInjuredPersonName(String? value) {
    _$sickInjuredPersonNameAtom.reportWrite(value, super.sickInjuredPersonName,
        () {
      super.sickInjuredPersonName = value;
    });
  }

  late final _$sickInjuredPersonKanaAtom =
      Atom(name: '_Report.sickInjuredPersonKana', context: context);

  @override
  String? get sickInjuredPersonKana {
    _$sickInjuredPersonKanaAtom.reportRead();
    return super.sickInjuredPersonKana;
  }

  @override
  set sickInjuredPersonKana(String? value) {
    _$sickInjuredPersonKanaAtom.reportWrite(value, super.sickInjuredPersonKana,
        () {
      super.sickInjuredPersonKana = value;
    });
  }

  late final _$sickInjuredPersonAddressAtom =
      Atom(name: '_Report.sickInjuredPersonAddress', context: context);

  @override
  String? get sickInjuredPersonAddress {
    _$sickInjuredPersonAddressAtom.reportRead();
    return super.sickInjuredPersonAddress;
  }

  @override
  set sickInjuredPersonAddress(String? value) {
    _$sickInjuredPersonAddressAtom
        .reportWrite(value, super.sickInjuredPersonAddress, () {
      super.sickInjuredPersonAddress = value;
    });
  }

  late final _$sickInjuredPersonGenderAtom =
      Atom(name: '_Report.sickInjuredPersonGender', context: context);

  @override
  String? get sickInjuredPersonGender {
    _$sickInjuredPersonGenderAtom.reportRead();
    return super.sickInjuredPersonGender;
  }

  @override
  set sickInjuredPersonGender(String? value) {
    _$sickInjuredPersonGenderAtom
        .reportWrite(value, super.sickInjuredPersonGender, () {
      super.sickInjuredPersonGender = value;
    });
  }

  late final _$sickInjuredPersonBirthDateAtom =
      Atom(name: '_Report.sickInjuredPersonBirthDate', context: context);

  @override
  DateTime? get sickInjuredPersonBirthDate {
    _$sickInjuredPersonBirthDateAtom.reportRead();
    return super.sickInjuredPersonBirthDate;
  }

  @override
  set sickInjuredPersonBirthDate(DateTime? value) {
    _$sickInjuredPersonBirthDateAtom
        .reportWrite(value, super.sickInjuredPersonBirthDate, () {
      super.sickInjuredPersonBirthDate = value;
    });
  }

  late final _$sickInjuredPersonTelAtom =
      Atom(name: '_Report.sickInjuredPersonTel', context: context);

  @override
  String? get sickInjuredPersonTel {
    _$sickInjuredPersonTelAtom.reportRead();
    return super.sickInjuredPersonTel;
  }

  @override
  set sickInjuredPersonTel(String? value) {
    _$sickInjuredPersonTelAtom.reportWrite(value, super.sickInjuredPersonTel,
        () {
      super.sickInjuredPersonTel = value;
    });
  }

  late final _$sickInjuredPersonMedicalHistoryAtom =
      Atom(name: '_Report.sickInjuredPersonMedicalHistory', context: context);

  @override
  String? get sickInjuredPersonMedicalHistory {
    _$sickInjuredPersonMedicalHistoryAtom.reportRead();
    return super.sickInjuredPersonMedicalHistory;
  }

  @override
  set sickInjuredPersonMedicalHistory(String? value) {
    _$sickInjuredPersonMedicalHistoryAtom
        .reportWrite(value, super.sickInjuredPersonMedicalHistory, () {
      super.sickInjuredPersonMedicalHistory = value;
    });
  }

  late final _$sickInjuredPersonHistoryHospitalAtom =
      Atom(name: '_Report.sickInjuredPersonHistoryHospital', context: context);

  @override
  String? get sickInjuredPersonHistoryHospital {
    _$sickInjuredPersonHistoryHospitalAtom.reportRead();
    return super.sickInjuredPersonHistoryHospital;
  }

  @override
  set sickInjuredPersonHistoryHospital(String? value) {
    _$sickInjuredPersonHistoryHospitalAtom
        .reportWrite(value, super.sickInjuredPersonHistoryHospital, () {
      super.sickInjuredPersonHistoryHospital = value;
    });
  }

  late final _$senseTimeAtom =
      Atom(name: '_Report.senseTime', context: context);

  @override
  TimeOfDay? get senseTime {
    _$senseTimeAtom.reportRead();
    return super.senseTime;
  }

  @override
  set senseTime(TimeOfDay? value) {
    _$senseTimeAtom.reportWrite(value, super.senseTime, () {
      super.senseTime = value;
    });
  }

  late final _$onSiteArrivalTimeAtom =
      Atom(name: '_Report.onSiteArrivalTime', context: context);

  @override
  TimeOfDay? get onSiteArrivalTime {
    _$onSiteArrivalTimeAtom.reportRead();
    return super.onSiteArrivalTime;
  }

  @override
  set onSiteArrivalTime(TimeOfDay? value) {
    _$onSiteArrivalTimeAtom.reportWrite(value, super.onSiteArrivalTime, () {
      super.onSiteArrivalTime = value;
    });
  }

  late final _$contactTimeAtom =
      Atom(name: '_Report.contactTime', context: context);

  @override
  TimeOfDay? get contactTime {
    _$contactTimeAtom.reportRead();
    return super.contactTime;
  }

  @override
  set contactTime(TimeOfDay? value) {
    _$contactTimeAtom.reportWrite(value, super.contactTime, () {
      super.contactTime = value;
    });
  }

  late final _$inVehicleTimeAtom =
      Atom(name: '_Report.inVehicleTime', context: context);

  @override
  TimeOfDay? get inVehicleTime {
    _$inVehicleTimeAtom.reportRead();
    return super.inVehicleTime;
  }

  @override
  set inVehicleTime(TimeOfDay? value) {
    _$inVehicleTimeAtom.reportWrite(value, super.inVehicleTime, () {
      super.inVehicleTime = value;
    });
  }

  late final _$startOfTransportTimeAtom =
      Atom(name: '_Report.startOfTransportTime', context: context);

  @override
  TimeOfDay? get startOfTransportTime {
    _$startOfTransportTimeAtom.reportRead();
    return super.startOfTransportTime;
  }

  @override
  set startOfTransportTime(TimeOfDay? value) {
    _$startOfTransportTimeAtom.reportWrite(value, super.startOfTransportTime,
        () {
      super.startOfTransportTime = value;
    });
  }

  late final _$hospitalArrivalTimeAtom =
      Atom(name: '_Report.hospitalArrivalTime', context: context);

  @override
  TimeOfDay? get hospitalArrivalTime {
    _$hospitalArrivalTimeAtom.reportRead();
    return super.hospitalArrivalTime;
  }

  @override
  set hospitalArrivalTime(TimeOfDay? value) {
    _$hospitalArrivalTimeAtom.reportWrite(value, super.hospitalArrivalTime, () {
      super.hospitalArrivalTime = value;
    });
  }

  late final _$familyContactAtom =
      Atom(name: '_Report.familyContact', context: context);

  @override
  bool? get familyContact {
    _$familyContactAtom.reportRead();
    return super.familyContact;
  }

  @override
  set familyContact(bool? value) {
    _$familyContactAtom.reportWrite(value, super.familyContact, () {
      super.familyContact = value;
    });
  }

  late final _$typeOfAccidentAtom =
      Atom(name: '_Report.typeOfAccident', context: context);

  @override
  String? get typeOfAccident {
    _$typeOfAccidentAtom.reportRead();
    return super.typeOfAccident;
  }

  @override
  set typeOfAccident(String? value) {
    _$typeOfAccidentAtom.reportWrite(value, super.typeOfAccident, () {
      super.typeOfAccident = value;
    });
  }

  late final _$dateOfOccurrenceAtom =
      Atom(name: '_Report.dateOfOccurrence', context: context);

  @override
  DateTime? get dateOfOccurrence {
    _$dateOfOccurrenceAtom.reportRead();
    return super.dateOfOccurrence;
  }

  @override
  set dateOfOccurrence(DateTime? value) {
    _$dateOfOccurrenceAtom.reportWrite(value, super.dateOfOccurrence, () {
      super.dateOfOccurrence = value;
    });
  }

  late final _$timeOfOccurrenceAtom =
      Atom(name: '_Report.timeOfOccurrence', context: context);

  @override
  TimeOfDay? get timeOfOccurrence {
    _$timeOfOccurrenceAtom.reportRead();
    return super.timeOfOccurrence;
  }

  @override
  set timeOfOccurrence(TimeOfDay? value) {
    _$timeOfOccurrenceAtom.reportWrite(value, super.timeOfOccurrence, () {
      super.timeOfOccurrence = value;
    });
  }

  late final _$placeOfIncidentAtom =
      Atom(name: '_Report.placeOfIncident', context: context);

  @override
  String? get placeOfIncident {
    _$placeOfIncidentAtom.reportRead();
    return super.placeOfIncident;
  }

  @override
  set placeOfIncident(String? value) {
    _$placeOfIncidentAtom.reportWrite(value, super.placeOfIncident, () {
      super.placeOfIncident = value;
    });
  }

  late final _$accidentSummaryAtom =
      Atom(name: '_Report.accidentSummary', context: context);

  @override
  String? get accidentSummary {
    _$accidentSummaryAtom.reportRead();
    return super.accidentSummary;
  }

  @override
  set accidentSummary(String? value) {
    _$accidentSummaryAtom.reportWrite(value, super.accidentSummary, () {
      super.accidentSummary = value;
    });
  }

  late final _$observationTimeAtom =
      Atom(name: '_Report.observationTime', context: context);

  @override
  ObservableList<TimeOfDay?>? get observationTime {
    _$observationTimeAtom.reportRead();
    return super.observationTime;
  }

  @override
  set observationTime(ObservableList<TimeOfDay?>? value) {
    _$observationTimeAtom.reportWrite(value, super.observationTime, () {
      super.observationTime = value;
    });
  }

  late final _$jcsAtom = Atom(name: '_Report.jcs', context: context);

  @override
  ObservableList<String?>? get jcs {
    _$jcsAtom.reportRead();
    return super.jcs;
  }

  @override
  set jcs(ObservableList<String?>? value) {
    _$jcsAtom.reportWrite(value, super.jcs, () {
      super.jcs = value;
    });
  }

  late final _$gcsVAtom = Atom(name: '_Report.gcsV', context: context);

  @override
  ObservableList<String?>? get gcsV {
    _$gcsVAtom.reportRead();
    return super.gcsV;
  }

  @override
  set gcsV(ObservableList<String?>? value) {
    _$gcsVAtom.reportWrite(value, super.gcsV, () {
      super.gcsV = value;
    });
  }

  late final _$gcsMAtom = Atom(name: '_Report.gcsM', context: context);

  @override
  ObservableList<String?>? get gcsM {
    _$gcsMAtom.reportRead();
    return super.gcsM;
  }

  @override
  set gcsM(ObservableList<String?>? value) {
    _$gcsMAtom.reportWrite(value, super.gcsM, () {
      super.gcsM = value;
    });
  }

  late final _$respirationAtom =
      Atom(name: '_Report.respiration', context: context);

  @override
  ObservableList<int?>? get respiration {
    _$respirationAtom.reportRead();
    return super.respiration;
  }

  @override
  set respiration(ObservableList<int?>? value) {
    _$respirationAtom.reportWrite(value, super.respiration, () {
      super.respiration = value;
    });
  }

  late final _$pulseAtom = Atom(name: '_Report.pulse', context: context);

  @override
  ObservableList<int?>? get pulse {
    _$pulseAtom.reportRead();
    return super.pulse;
  }

  @override
  set pulse(ObservableList<int?>? value) {
    _$pulseAtom.reportWrite(value, super.pulse, () {
      super.pulse = value;
    });
  }

  late final _$bloodPressureHighAtom =
      Atom(name: '_Report.bloodPressureHigh', context: context);

  @override
  ObservableList<int?>? get bloodPressureHigh {
    _$bloodPressureHighAtom.reportRead();
    return super.bloodPressureHigh;
  }

  @override
  set bloodPressureHigh(ObservableList<int?>? value) {
    _$bloodPressureHighAtom.reportWrite(value, super.bloodPressureHigh, () {
      super.bloodPressureHigh = value;
    });
  }

  late final _$bloodPressureLowAtom =
      Atom(name: '_Report.bloodPressureLow', context: context);

  @override
  ObservableList<int?>? get bloodPressureLow {
    _$bloodPressureLowAtom.reportRead();
    return super.bloodPressureLow;
  }

  @override
  set bloodPressureLow(ObservableList<int?>? value) {
    _$bloodPressureLowAtom.reportWrite(value, super.bloodPressureLow, () {
      super.bloodPressureLow = value;
    });
  }

  late final _$spO2PercentAtom =
      Atom(name: '_Report.spO2Percent', context: context);

  @override
  ObservableList<int?>? get spO2Percent {
    _$spO2PercentAtom.reportRead();
    return super.spO2Percent;
  }

  @override
  set spO2Percent(ObservableList<int?>? value) {
    _$spO2PercentAtom.reportWrite(value, super.spO2Percent, () {
      super.spO2Percent = value;
    });
  }

  late final _$pupilRightAtom =
      Atom(name: '_Report.pupilRight', context: context);

  @override
  ObservableList<double?>? get pupilRight {
    _$pupilRightAtom.reportRead();
    return super.pupilRight;
  }

  @override
  set pupilRight(ObservableList<double?>? value) {
    _$pupilRightAtom.reportWrite(value, super.pupilRight, () {
      super.pupilRight = value;
    });
  }

  late final _$pupilLeftAtom =
      Atom(name: '_Report.pupilLeft', context: context);

  @override
  ObservableList<double?>? get pupilLeft {
    _$pupilLeftAtom.reportRead();
    return super.pupilLeft;
  }

  @override
  set pupilLeft(ObservableList<double?>? value) {
    _$pupilLeftAtom.reportWrite(value, super.pupilLeft, () {
      super.pupilLeft = value;
    });
  }

  late final _$bodyTemperatureAtom =
      Atom(name: '_Report.bodyTemperature', context: context);

  @override
  ObservableList<double?>? get bodyTemperature {
    _$bodyTemperatureAtom.reportRead();
    return super.bodyTemperature;
  }

  @override
  set bodyTemperature(ObservableList<double?>? value) {
    _$bodyTemperatureAtom.reportWrite(value, super.bodyTemperature, () {
      super.bodyTemperature = value;
    });
  }

  late final _$facialFeaturesAnguishAtom =
      Atom(name: '_Report.facialFeaturesAnguish', context: context);

  @override
  ObservableList<bool?>? get facialFeaturesAnguish {
    _$facialFeaturesAnguishAtom.reportRead();
    return super.facialFeaturesAnguish;
  }

  @override
  set facialFeaturesAnguish(ObservableList<bool?>? value) {
    _$facialFeaturesAnguishAtom.reportWrite(value, super.facialFeaturesAnguish,
        () {
      super.facialFeaturesAnguish = value;
    });
  }

  late final _$otherOfObservationTimeAtom =
      Atom(name: '_Report.otherOfObservationTime', context: context);

  @override
  String? get otherOfObservationTime {
    _$otherOfObservationTimeAtom.reportRead();
    return super.otherOfObservationTime;
  }

  @override
  set otherOfObservationTime(String? value) {
    _$otherOfObservationTimeAtom
        .reportWrite(value, super.otherOfObservationTime, () {
      super.otherOfObservationTime = value;
    });
  }

  late final _$entryNameAtom =
      Atom(name: '_Report.entryName', context: context);

  @override
  String? get entryName {
    _$entryNameAtom.reportRead();
    return super.entryName;
  }

  @override
  set entryName(String? value) {
    _$entryNameAtom.reportWrite(value, super.entryName, () {
      super.entryName = value;
    });
  }

  late final _$entryMachineAtom =
      Atom(name: '_Report.entryMachine', context: context);

  @override
  String? get entryMachine {
    _$entryMachineAtom.reportRead();
    return super.entryMachine;
  }

  @override
  set entryMachine(String? value) {
    _$entryMachineAtom.reportWrite(value, super.entryMachine, () {
      super.entryMachine = value;
    });
  }

  late final _$entryDateAtom =
      Atom(name: '_Report.entryDate', context: context);

  @override
  DateTime? get entryDate {
    _$entryDateAtom.reportRead();
    return super.entryDate;
  }

  @override
  set entryDate(DateTime? value) {
    _$entryDateAtom.reportWrite(value, super.entryDate, () {
      super.entryDate = value;
    });
  }

  late final _$updateNameAtom =
      Atom(name: '_Report.updateName', context: context);

  @override
  String? get updateName {
    _$updateNameAtom.reportRead();
    return super.updateName;
  }

  @override
  set updateName(String? value) {
    _$updateNameAtom.reportWrite(value, super.updateName, () {
      super.updateName = value;
    });
  }

  late final _$updateMachineAtom =
      Atom(name: '_Report.updateMachine', context: context);

  @override
  String? get updateMachine {
    _$updateMachineAtom.reportRead();
    return super.updateMachine;
  }

  @override
  set updateMachine(String? value) {
    _$updateMachineAtom.reportWrite(value, super.updateMachine, () {
      super.updateMachine = value;
    });
  }

  late final _$updateDateAtom =
      Atom(name: '_Report.updateDate', context: context);

  @override
  DateTime? get updateDate {
    _$updateDateAtom.reportRead();
    return super.updateDate;
  }

  @override
  set updateDate(DateTime? value) {
    _$updateDateAtom.reportWrite(value, super.updateDate, () {
      super.updateDate = value;
    });
  }

  late final _$classificationStoreAtom =
      Atom(name: '_Report.classificationStore', context: context);

  @override
  ClassificationStore? get classificationStore {
    _$classificationStoreAtom.reportRead();
    return super.classificationStore;
  }

  @override
  set classificationStore(ClassificationStore? value) {
    _$classificationStoreAtom.reportWrite(value, super.classificationStore, () {
      super.classificationStore = value;
    });
  }

  late final _$hospitalStoreAtom =
      Atom(name: '_Report.hospitalStore', context: context);

  @override
  HospitalStore? get hospitalStore {
    _$hospitalStoreAtom.reportRead();
    return super.hospitalStore;
  }

  @override
  set hospitalStore(HospitalStore? value) {
    _$hospitalStoreAtom.reportWrite(value, super.hospitalStore, () {
      super.hospitalStore = value;
    });
  }

  late final _$_ReportActionController =
      ActionController(name: '_Report', context: context);

  @override
  dynamic setTeam(Team? team) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setTeam');
    try {
      return super.setTeam(team);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setGender(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setGender');
    try {
      return super.setGender(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAccidentType(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setAccidentType');
    try {
      return super.setAccidentType(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setJcsTypes(List<Classification?> values) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setJcsTypes');
    try {
      return super.setJcsTypes(values);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setGcsVTypes(List<Classification?> values) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setGcsVTypes');
    try {
      return super.setGcsVTypes(values);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setGcsMTypes(List<Classification?> values) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setGcsMTypes');
    try {
      return super.setGcsMTypes(values);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
teamCd: ${teamCd},
teamCaptainName: ${teamCaptainName},
sickInjuredPersonName: ${sickInjuredPersonName},
sickInjuredPersonKana: ${sickInjuredPersonKana},
sickInjuredPersonAddress: ${sickInjuredPersonAddress},
sickInjuredPersonGender: ${sickInjuredPersonGender},
sickInjuredPersonBirthDate: ${sickInjuredPersonBirthDate},
sickInjuredPersonTel: ${sickInjuredPersonTel},
sickInjuredPersonMedicalHistory: ${sickInjuredPersonMedicalHistory},
sickInjuredPersonHistoryHospital: ${sickInjuredPersonHistoryHospital},
senseTime: ${senseTime},
onSiteArrivalTime: ${onSiteArrivalTime},
contactTime: ${contactTime},
inVehicleTime: ${inVehicleTime},
startOfTransportTime: ${startOfTransportTime},
hospitalArrivalTime: ${hospitalArrivalTime},
familyContact: ${familyContact},
typeOfAccident: ${typeOfAccident},
dateOfOccurrence: ${dateOfOccurrence},
timeOfOccurrence: ${timeOfOccurrence},
placeOfIncident: ${placeOfIncident},
accidentSummary: ${accidentSummary},
observationTime: ${observationTime},
jcs: ${jcs},
gcsV: ${gcsV},
gcsM: ${gcsM},
respiration: ${respiration},
pulse: ${pulse},
bloodPressureHigh: ${bloodPressureHigh},
bloodPressureLow: ${bloodPressureLow},
spO2Percent: ${spO2Percent},
pupilRight: ${pupilRight},
pupilLeft: ${pupilLeft},
bodyTemperature: ${bodyTemperature},
facialFeaturesAnguish: ${facialFeaturesAnguish},
otherOfObservationTime: ${otherOfObservationTime},
entryName: ${entryName},
entryMachine: ${entryMachine},
entryDate: ${entryDate},
updateName: ${updateName},
updateMachine: ${updateMachine},
updateDate: ${updateDate},
classificationStore: ${classificationStore},
hospitalStore: ${hospitalStore},
sickInjuredPersonAge: ${sickInjuredPersonAge},
gender: ${gender},
accidentType: ${accidentType},
jcsTypes: ${jcsTypes},
gcsVTypes: ${gcsVTypes},
gcsMTypes: ${gcsMTypes}
    ''';
  }
}
