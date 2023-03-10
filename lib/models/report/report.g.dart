// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report()
  ..id = json['ID'] as int?
  ..teamCd = json['TeamCD'] as String?
  ..teamCaptainName = json['TeamCaptainName'] as String?
  ..teamMemberName = json['TeamMemberName'] as String?
  ..institutionalMemberName = json['InstitutionalMemberName'] as String?
  ..lifesaverQualification = _$JsonConverterFromJson<int, bool>(
      json['LifesaverQualification'], const IntToBoolConverter().fromJson)
  ..withLifesavers = _$JsonConverterFromJson<int, bool>(
      json['WithLifeSavers'], const IntToBoolConverter().fromJson)
  ..totalCount = json['Total'] as int?
  ..teamCount = json['Team'] as int?
  ..sickInjuredPersonName = json['SickInjuredPersonName'] as String?
  ..sickInjuredPersonKana = json['SickInjuredPersonKANA'] as String?
  ..sickInjuredPersonAddress = json['SickInjuredPersonAddress'] as String?
  ..sickInjuredPersonGender = json['SickInjuredPersonGender'] as String?
  ..sickInjuredPersonBirthDate = json['SickInjuredPersonBirthDate'] == null
      ? null
      : DateTime.parse(json['SickInjuredPersonBirthDate'] as String)
  ..sickInjuredPersonTel = json['SickInjuredPersonTEL'] as String?
  ..sickInjuredPersonFamily = json['SickInjuredPersonFamily'] as String?
  ..sickInjuredPersonFamilyTel = json['SickInjuredPersonFamilyTEL'] as String?
  ..sickInjuredPersonMedicalHistory =
      json['SickInjuredPersonMedicalHistroy'] as String?
  ..sickInjuredPersonHistoryHospital =
      json['SickInjuredPersonHistoryHospital'] as String?
  ..sickInjuredPersonKakaritsuke =
      json['SickInjuredPersonKakaritsuke'] as String?
  ..sickInjuredPersonMedication = json['SickInjuredPersonMedication'] as String?
  ..sickInjuredPersonMedicationDetail =
      json['SickInjuredPersonMedicationDetail'] as String?
  ..sickInjuredPersonAllergy = json['SickInjuredPersonAllergy'] as String?
  ..sickInjuredPersonNameOfInjuryOrSickness =
      json['SickInjuredPersonNameOfInjuryOrSickness'] as String?
  ..sickInjuredPersonDegree = json['SickInjuredPersonDegree'] as String?
  ..senseTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['SenseTime'], const TimeOfDayConverter().fromJson)
  ..commandTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['CommandTime'], const TimeOfDayConverter().fromJson)
  ..dispatchTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['DispatchTime'], const TimeOfDayConverter().fromJson)
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
  ..familyContactTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['FamilyContactTime'], const TimeOfDayConverter().fromJson)
  ..policeContactTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['PoliceContactTime'], const TimeOfDayConverter().fromJson)
  ..timeOfArrival = _$JsonConverterFromJson<String, TimeOfDay>(
      json['TimeOfArrival'], const TimeOfDayConverter().fromJson)
  ..returnTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['ReturnTime'], const TimeOfDayConverter().fromJson)
  ..typeOfAccident = json['TypeOfAccident'] as String?
  ..dateOfOccurrence = json['DateOfOccurrence'] == null
      ? null
      : DateTime.parse(json['DateOfOccurrence'] as String)
  ..timeOfOccurrence = _$JsonConverterFromJson<String, TimeOfDay>(
      json['TimeOfOccurrence'], const TimeOfDayConverter().fromJson)
  ..placeOfIncident = json['PlaceOfIncident'] as String?
  ..placeOfDispatch = json['PlaceOfDispatch'] as String?
  ..accidentSummary = json['AccidentSummary'] as String?
  ..adl = json['ADL'] as String?
  ..trafficAccidentClassification =
      json['TrafficAccidentClassification'] as String?
  ..witnesses = _$JsonConverterFromJson<int, bool>(
      json['Witnesses'], const IntToBoolConverter().fromJson)
  ..bystanderCpr = _$JsonConverterFromJson<String, TimeOfDay>(
      json['BystanderCPR'], const TimeOfDayConverter().fromJson)
  ..verbalGuidance = json['VerbalGuidance'] as String?
  ..observationTime =
      _$JsonConverterFromJson<String, ObservableList<TimeOfDay?>>(
          json['ObservationTime'], const ListTimeOfDayConverter().fromJson)
  ..jcs = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['JCS'], const ListStringConverter().fromJson)
  ..gcsE = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['GCS_E'], const ListStringConverter().fromJson)
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
  ..spO2Liter = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['SpO2Liter'], const ListIntConverter().fromJson)
  ..pupilRight = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['PupilRight'], const ListIntConverter().fromJson)
  ..pupilLeft = _$JsonConverterFromJson<String, ObservableList<int?>>(
      json['PupilLeft'], const ListIntConverter().fromJson)
  ..lightReflexRight = _$JsonConverterFromJson<String, ObservableList<bool?>>(
      json['LightReflexRight'], const ListBoolConverter().fromJson)
  ..lightReflexLeft = _$JsonConverterFromJson<String, ObservableList<bool?>>(
      json['LightReflexLeft'], const ListBoolConverter().fromJson)
  ..bodyTemperature = _$JsonConverterFromJson<String, ObservableList<double?>>(
      json['BodyTemperature'], const ListDoubleConverter().fromJson)
  ..facialFeatures = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['FacialFeatures'], const ListStringConverter().fromJson)
  ..hemorrhage = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['Hemorrhage'], const ListStringConverter().fromJson)
  ..incontinence = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['Incontinence'], const ListStringConverter().fromJson)
  ..vomiting = _$JsonConverterFromJson<String, ObservableList<bool?>>(
      json['Vomiting'], const ListBoolConverter().fromJson)
  ..extremities = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['Extremities'], const ListStringConverter().fromJson)
  ..descriptionOfObservationTime =
      _$JsonConverterFromJson<String, ObservableList<String?>>(
          json['DescriptionOfObservationTime'],
          const ListStringConverter().fromJson)
  ..eachEcg = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['EachECG'], const ListStringConverter().fromJson)
  ..eachOxygenInhalation =
      _$JsonConverterFromJson<String, ObservableList<double?>>(
          json['EachOxygenInhalation'], const ListDoubleConverter().fromJson)
  ..eachHemostasis = _$JsonConverterFromJson<String, ObservableList<bool?>>(
      json['EachHemostasis'], const ListBoolConverter().fromJson)
  ..eachSuction = _$JsonConverterFromJson<String, ObservableList<bool?>>(
      json['EachSuction'], const ListBoolConverter().fromJson)
  ..otherProcess1 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess1'], const ListStringConverter().fromJson)
  ..otherProcess2 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess2'], const ListStringConverter().fromJson)
  ..otherProcess3 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess3'], const ListStringConverter().fromJson)
  ..otherProcess4 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess4'], const ListStringConverter().fromJson)
  ..otherProcess5 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess5'], const ListStringConverter().fromJson)
  ..otherProcess6 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess6'], const ListStringConverter().fromJson)
  ..otherProcess7 = _$JsonConverterFromJson<String, ObservableList<String?>>(
      json['OtherProcess7'], const ListStringConverter().fromJson)
  ..otherOfObservationTime = json['OtherOfObservationTime'] as String?
  ..securingAirway = json['SecuringAirway'] as String?
  ..foreignBodyRemoval = _$JsonConverterFromJson<int, bool>(
      json['ForeignBodyRemoval'], const IntToBoolConverter().fromJson)
  ..suction = _$JsonConverterFromJson<int, bool>(
      json['Suction'], const IntToBoolConverter().fromJson)
  ..artificialRespiration = _$JsonConverterFromJson<int, bool>(
      json['ArtificialRespiration'], const IntToBoolConverter().fromJson)
  ..chestCompressions = _$JsonConverterFromJson<int, bool>(
      json['ChestCompressions'], const IntToBoolConverter().fromJson)
  ..ecgMonitor = _$JsonConverterFromJson<int, bool>(
      json['ECGMonitor'], const IntToBoolConverter().fromJson)
  ..o2Administration = (json['O2Administration'] as num?)?.toDouble()
  ..o2AdministrationTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['O2AdministrationTime'], const TimeOfDayConverter().fromJson)
  ..limitationOfSpinalMotion = json['LimitationOfSpinalMotion'] as String?
  ..hemostaticTreatment = _$JsonConverterFromJson<int, bool>(
      json['HemostaticTreatment'], const IntToBoolConverter().fromJson)
  ..adductorFixation = _$JsonConverterFromJson<int, bool>(
      json['AdductorFixation'], const IntToBoolConverter().fromJson)
  ..coating = _$JsonConverterFromJson<int, bool>(
      json['Coating'], const IntToBoolConverter().fromJson)
  ..burnTreatment = _$JsonConverterFromJson<int, bool>(
      json['BurnTreatment'], const IntToBoolConverter().fromJson)
  ..bsMeasurement1 = json['BSMeasurement1'] as int?
  ..bsMeasurementTime1 = _$JsonConverterFromJson<String, TimeOfDay>(
      json['BSMeasurementTime1'], const TimeOfDayConverter().fromJson)
  ..punctureSite1 = json['PunctureSite1'] as String?
  ..bsMeasurement2 = json['BSMeasurement2'] as int?
  ..bsMeasurementTime2 = _$JsonConverterFromJson<String, TimeOfDay>(
      json['BSMeasurementTime2'], const TimeOfDayConverter().fromJson)
  ..punctureSite2 = json['PunctureSite2'] as String?
  ..other = json['Other'] as String?
  ..perceiverName = json['PerceiverName'] as String?
  ..typeOfDetection = json['TypeOfDetection'] as String?
  ..callerName = json['CallerName'] as String?
  ..callerTel = json['CallerTEL'] as String?
  ..medicalTransportFacility = json['MedicalTransportFacility'] as String?
  ..otherMedicalTransportFacility =
      json['OtherMedicalTransportFacility'] as String?
  ..transferringMedicalInstitution =
      json['TransferringMedicalInstitution'] as String?
  ..otherTransferringMedicalInstitution =
      json['OtherTransferringMedicalInstitution'] as String?
  ..transferSourceReceivingTime = _$JsonConverterFromJson<String, TimeOfDay>(
      json['TransferSourceReceivingTime'], const TimeOfDayConverter().fromJson)
  ..reasonForTransfer = json['ReasonForTransfer'] as String?
  ..reasonForNotTransferring = json['ReasonForNotTransferring'] as String?
  ..recordOfRefusalOfTransfer = _$JsonConverterFromJson<int, bool>(
      json['RecordOfRefusalOfTransfer'], const IntToBoolConverter().fromJson)
  ..nameOfReporter = json['NameOfReporter'] as String?
  ..affiliationOfReporter = json['AffiliationOfReporter'] as String?
  ..positionOfReporter = json['PositionOfReporter'] as String?
  ..summaryOfOccurrence = json['SummaryOfOccurrence'] as String?
  ..remarks = json['Remarks'] as String?
  ..entryName = json['entryName'] as String?
  ..entryMachine = json['entryMachine'] as String?
  ..entryDate = json['entryDate'] == null
      ? null
      : DateTime.parse(json['entryDate'] as String)
  ..updateName = json['updateName'] as String?
  ..updateMachine = json['updateMachine'] as String?
  ..updateDate = json['updateDate'] == null
      ? null
      : DateTime.parse(json['updateDate'] as String);

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'ID': instance.id,
      'TeamCD': instance.teamCd,
      'TeamCaptainName': instance.teamCaptainName,
      'TeamMemberName': instance.teamMemberName,
      'InstitutionalMemberName': instance.institutionalMemberName,
      'LifesaverQualification': _$JsonConverterToJson<int, bool>(
          instance.lifesaverQualification, const IntToBoolConverter().toJson),
      'WithLifeSavers': _$JsonConverterToJson<int, bool>(
          instance.withLifesavers, const IntToBoolConverter().toJson),
      'Total': instance.totalCount,
      'Team': instance.teamCount,
      'SickInjuredPersonName': instance.sickInjuredPersonName,
      'SickInjuredPersonKANA': instance.sickInjuredPersonKana,
      'SickInjuredPersonAddress': instance.sickInjuredPersonAddress,
      'SickInjuredPersonGender': instance.sickInjuredPersonGender,
      'SickInjuredPersonBirthDate':
          instance.sickInjuredPersonBirthDate?.toIso8601String(),
      'SickInjuredPersonTEL': instance.sickInjuredPersonTel,
      'SickInjuredPersonFamily': instance.sickInjuredPersonFamily,
      'SickInjuredPersonFamilyTEL': instance.sickInjuredPersonFamilyTel,
      'SickInjuredPersonMedicalHistroy':
          instance.sickInjuredPersonMedicalHistory,
      'SickInjuredPersonHistoryHospital':
          instance.sickInjuredPersonHistoryHospital,
      'SickInjuredPersonKakaritsuke': instance.sickInjuredPersonKakaritsuke,
      'SickInjuredPersonMedication': instance.sickInjuredPersonMedication,
      'SickInjuredPersonMedicationDetail':
          instance.sickInjuredPersonMedicationDetail,
      'SickInjuredPersonAllergy': instance.sickInjuredPersonAllergy,
      'SickInjuredPersonNameOfInjuryOrSickness':
          instance.sickInjuredPersonNameOfInjuryOrSickness,
      'SickInjuredPersonDegree': instance.sickInjuredPersonDegree,
      'SenseTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.senseTime, const TimeOfDayConverter().toJson),
      'CommandTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.commandTime, const TimeOfDayConverter().toJson),
      'DispatchTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.dispatchTime, const TimeOfDayConverter().toJson),
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
      'FamilyContactTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.familyContactTime, const TimeOfDayConverter().toJson),
      'PoliceContactTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.policeContactTime, const TimeOfDayConverter().toJson),
      'TimeOfArrival': _$JsonConverterToJson<String, TimeOfDay>(
          instance.timeOfArrival, const TimeOfDayConverter().toJson),
      'ReturnTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.returnTime, const TimeOfDayConverter().toJson),
      'TypeOfAccident': instance.typeOfAccident,
      'DateOfOccurrence': instance.dateOfOccurrence?.toIso8601String(),
      'TimeOfOccurrence': _$JsonConverterToJson<String, TimeOfDay>(
          instance.timeOfOccurrence, const TimeOfDayConverter().toJson),
      'PlaceOfIncident': instance.placeOfIncident,
      'PlaceOfDispatch': instance.placeOfDispatch,
      'AccidentSummary': instance.accidentSummary,
      'ADL': instance.adl,
      'TrafficAccidentClassification': instance.trafficAccidentClassification,
      'Witnesses': _$JsonConverterToJson<int, bool>(
          instance.witnesses, const IntToBoolConverter().toJson),
      'BystanderCPR': _$JsonConverterToJson<String, TimeOfDay>(
          instance.bystanderCpr, const TimeOfDayConverter().toJson),
      'VerbalGuidance': instance.verbalGuidance,
      'ObservationTime':
          _$JsonConverterToJson<String, ObservableList<TimeOfDay?>>(
              instance.observationTime, const ListTimeOfDayConverter().toJson),
      'JCS': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.jcs, const ListStringConverter().toJson),
      'GCS_E': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.gcsE, const ListStringConverter().toJson),
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
      'SpO2Liter': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.spO2Liter, const ListIntConverter().toJson),
      'PupilRight': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.pupilRight, const ListIntConverter().toJson),
      'PupilLeft': _$JsonConverterToJson<String, ObservableList<int?>>(
          instance.pupilLeft, const ListIntConverter().toJson),
      'LightReflexRight': _$JsonConverterToJson<String, ObservableList<bool?>>(
          instance.lightReflexRight, const ListBoolConverter().toJson),
      'LightReflexLeft': _$JsonConverterToJson<String, ObservableList<bool?>>(
          instance.lightReflexLeft, const ListBoolConverter().toJson),
      'BodyTemperature': _$JsonConverterToJson<String, ObservableList<double?>>(
          instance.bodyTemperature, const ListDoubleConverter().toJson),
      'FacialFeatures': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.facialFeatures, const ListStringConverter().toJson),
      'Hemorrhage': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.hemorrhage, const ListStringConverter().toJson),
      'Incontinence': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.incontinence, const ListStringConverter().toJson),
      'Vomiting': _$JsonConverterToJson<String, ObservableList<bool?>>(
          instance.vomiting, const ListBoolConverter().toJson),
      'Extremities': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.extremities, const ListStringConverter().toJson),
      'DescriptionOfObservationTime':
          _$JsonConverterToJson<String, ObservableList<String?>>(
              instance.descriptionOfObservationTime,
              const ListStringConverter().toJson),
      'EachECG': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.eachEcg, const ListStringConverter().toJson),
      'EachOxygenInhalation':
          _$JsonConverterToJson<String, ObservableList<double?>>(
              instance.eachOxygenInhalation,
              const ListDoubleConverter().toJson),
      'EachHemostasis': _$JsonConverterToJson<String, ObservableList<bool?>>(
          instance.eachHemostasis, const ListBoolConverter().toJson),
      'EachSuction': _$JsonConverterToJson<String, ObservableList<bool?>>(
          instance.eachSuction, const ListBoolConverter().toJson),
      'OtherProcess1': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess1, const ListStringConverter().toJson),
      'OtherProcess2': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess2, const ListStringConverter().toJson),
      'OtherProcess3': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess3, const ListStringConverter().toJson),
      'OtherProcess4': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess4, const ListStringConverter().toJson),
      'OtherProcess5': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess5, const ListStringConverter().toJson),
      'OtherProcess6': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess6, const ListStringConverter().toJson),
      'OtherProcess7': _$JsonConverterToJson<String, ObservableList<String?>>(
          instance.otherProcess7, const ListStringConverter().toJson),
      'OtherOfObservationTime': instance.otherOfObservationTime,
      'SecuringAirway': instance.securingAirway,
      'ForeignBodyRemoval': _$JsonConverterToJson<int, bool>(
          instance.foreignBodyRemoval, const IntToBoolConverter().toJson),
      'Suction': _$JsonConverterToJson<int, bool>(
          instance.suction, const IntToBoolConverter().toJson),
      'ArtificialRespiration': _$JsonConverterToJson<int, bool>(
          instance.artificialRespiration, const IntToBoolConverter().toJson),
      'ChestCompressions': _$JsonConverterToJson<int, bool>(
          instance.chestCompressions, const IntToBoolConverter().toJson),
      'ECGMonitor': _$JsonConverterToJson<int, bool>(
          instance.ecgMonitor, const IntToBoolConverter().toJson),
      'O2Administration': instance.o2Administration,
      'O2AdministrationTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.o2AdministrationTime, const TimeOfDayConverter().toJson),
      'LimitationOfSpinalMotion': instance.limitationOfSpinalMotion,
      'HemostaticTreatment': _$JsonConverterToJson<int, bool>(
          instance.hemostaticTreatment, const IntToBoolConverter().toJson),
      'AdductorFixation': _$JsonConverterToJson<int, bool>(
          instance.adductorFixation, const IntToBoolConverter().toJson),
      'Coating': _$JsonConverterToJson<int, bool>(
          instance.coating, const IntToBoolConverter().toJson),
      'BurnTreatment': _$JsonConverterToJson<int, bool>(
          instance.burnTreatment, const IntToBoolConverter().toJson),
      'BSMeasurement1': instance.bsMeasurement1,
      'BSMeasurementTime1': _$JsonConverterToJson<String, TimeOfDay>(
          instance.bsMeasurementTime1, const TimeOfDayConverter().toJson),
      'PunctureSite1': instance.punctureSite1,
      'BSMeasurement2': instance.bsMeasurement2,
      'BSMeasurementTime2': _$JsonConverterToJson<String, TimeOfDay>(
          instance.bsMeasurementTime2, const TimeOfDayConverter().toJson),
      'PunctureSite2': instance.punctureSite2,
      'Other': instance.other,
      'PerceiverName': instance.perceiverName,
      'TypeOfDetection': instance.typeOfDetection,
      'CallerName': instance.callerName,
      'CallerTEL': instance.callerTel,
      'MedicalTransportFacility': instance.medicalTransportFacility,
      'OtherMedicalTransportFacility': instance.otherMedicalTransportFacility,
      'TransferringMedicalInstitution': instance.transferringMedicalInstitution,
      'OtherTransferringMedicalInstitution':
          instance.otherTransferringMedicalInstitution,
      'TransferSourceReceivingTime': _$JsonConverterToJson<String, TimeOfDay>(
          instance.transferSourceReceivingTime,
          const TimeOfDayConverter().toJson),
      'ReasonForTransfer': instance.reasonForTransfer,
      'ReasonForNotTransferring': instance.reasonForNotTransferring,
      'RecordOfRefusalOfTransfer': _$JsonConverterToJson<int, bool>(
          instance.recordOfRefusalOfTransfer,
          const IntToBoolConverter().toJson),
      'NameOfReporter': instance.nameOfReporter,
      'AffiliationOfReporter': instance.affiliationOfReporter,
      'PositionOfReporter': instance.positionOfReporter,
      'SummaryOfOccurrence': instance.summaryOfOccurrence,
      'Remarks': instance.remarks,
      'entryName': instance.entryName,
      'entryMachine': instance.entryMachine,
      'entryDate': instance.entryDate?.toIso8601String(),
      'updateName': instance.updateName,
      'updateMachine': instance.updateMachine,
      'updateDate': instance.updateDate?.toIso8601String(),
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
  Computed<Team?>? _$teamComputed;

  @override
  Team? get team => (_$teamComputed ??=
          Computed<Team?>(() => super.team, name: '_Report.team'))
      .value;
  Computed<Classification?>? _$genderComputed;

  @override
  Classification? get gender => (_$genderComputed ??=
          Computed<Classification?>(() => super.gender, name: '_Report.gender'))
      .value;
  Computed<Classification?>? _$medicationComputed;

  @override
  Classification? get medication => (_$medicationComputed ??=
          Computed<Classification?>(() => super.medication,
              name: '_Report.medication'))
      .value;
  Computed<Classification?>? _$degreeComputed;

  @override
  Classification? get degree => (_$degreeComputed ??=
          Computed<Classification?>(() => super.degree, name: '_Report.degree'))
      .value;
  Computed<Classification?>? _$detectionTypeComputed;

  @override
  Classification? get detectionType => (_$detectionTypeComputed ??=
          Computed<Classification?>(() => super.detectionType,
              name: '_Report.detectionType'))
      .value;
  Computed<Classification?>? _$accidentTypeComputed;

  @override
  Classification? get accidentType => (_$accidentTypeComputed ??=
          Computed<Classification?>(() => super.accidentType,
              name: '_Report.accidentType'))
      .value;
  Computed<Hospital?>? _$medicalTransportFacilityTypeComputed;

  @override
  Hospital? get medicalTransportFacilityType =>
      (_$medicalTransportFacilityTypeComputed ??= Computed<Hospital?>(
              () => super.medicalTransportFacilityType,
              name: '_Report.medicalTransportFacilityType'))
          .value;
  Computed<Hospital?>? _$transferringMedicalInstitutionTypeComputed;

  @override
  Hospital? get transferringMedicalInstitutionType =>
      (_$transferringMedicalInstitutionTypeComputed ??= Computed<Hospital?>(
              () => super.transferringMedicalInstitutionType,
              name: '_Report.transferringMedicalInstitutionType'))
          .value;
  Computed<Classification?>? _$trafficAccidentTypeComputed;

  @override
  Classification? get trafficAccidentType => (_$trafficAccidentTypeComputed ??=
          Computed<Classification?>(() => super.trafficAccidentType,
              name: '_Report.trafficAccidentType'))
      .value;
  Computed<Classification?>? _$adlTypeComputed;

  @override
  Classification? get adlType =>
      (_$adlTypeComputed ??= Computed<Classification?>(() => super.adlType,
              name: '_Report.adlType'))
          .value;
  Computed<Classification?>? _$securingAirwayTypeComputed;

  @override
  Classification? get securingAirwayType => (_$securingAirwayTypeComputed ??=
          Computed<Classification?>(() => super.securingAirwayType,
              name: '_Report.securingAirwayType'))
      .value;
  Computed<Classification?>? _$limitationOfSpinalMotionTypeComputed;

  @override
  Classification? get limitationOfSpinalMotionType =>
      (_$limitationOfSpinalMotionTypeComputed ??= Computed<Classification?>(
              () => super.limitationOfSpinalMotionType,
              name: '_Report.limitationOfSpinalMotionType'))
          .value;
  Computed<List<Classification?>>? _$jcsTypesComputed;

  @override
  List<Classification?> get jcsTypes => (_$jcsTypesComputed ??=
          Computed<List<Classification?>>(() => super.jcsTypes,
              name: '_Report.jcsTypes'))
      .value;
  Computed<List<Classification?>>? _$gcsETypesComputed;

  @override
  List<Classification?> get gcsETypes => (_$gcsETypesComputed ??=
          Computed<List<Classification?>>(() => super.gcsETypes,
              name: '_Report.gcsETypes'))
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
  Computed<List<Classification?>>? _$facialFeatureTypesComputed;

  @override
  List<Classification?> get facialFeatureTypes =>
      (_$facialFeatureTypesComputed ??= Computed<List<Classification?>>(
              () => super.facialFeatureTypes,
              name: '_Report.facialFeatureTypes'))
          .value;
  Computed<List<Classification?>>? _$incontinenceTypesComputed;

  @override
  List<Classification?> get incontinenceTypes =>
      (_$incontinenceTypesComputed ??= Computed<List<Classification?>>(
              () => super.incontinenceTypes,
              name: '_Report.incontinenceTypes'))
          .value;
  Computed<List<Classification?>>? _$observationTimeDescriptionTypesComputed;

  @override
  List<Classification?> get observationTimeDescriptionTypes =>
      (_$observationTimeDescriptionTypesComputed ??=
              Computed<List<Classification?>>(
                  () => super.observationTimeDescriptionTypes,
                  name: '_Report.observationTimeDescriptionTypes'))
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

  late final _$teamMemberNameAtom =
      Atom(name: '_Report.teamMemberName', context: context);

  @override
  String? get teamMemberName {
    _$teamMemberNameAtom.reportRead();
    return super.teamMemberName;
  }

  @override
  set teamMemberName(String? value) {
    _$teamMemberNameAtom.reportWrite(value, super.teamMemberName, () {
      super.teamMemberName = value;
    });
  }

  late final _$institutionalMemberNameAtom =
      Atom(name: '_Report.institutionalMemberName', context: context);

  @override
  String? get institutionalMemberName {
    _$institutionalMemberNameAtom.reportRead();
    return super.institutionalMemberName;
  }

  @override
  set institutionalMemberName(String? value) {
    _$institutionalMemberNameAtom
        .reportWrite(value, super.institutionalMemberName, () {
      super.institutionalMemberName = value;
    });
  }

  late final _$lifesaverQualificationAtom =
      Atom(name: '_Report.lifesaverQualification', context: context);

  @override
  bool? get lifesaverQualification {
    _$lifesaverQualificationAtom.reportRead();
    return super.lifesaverQualification;
  }

  @override
  set lifesaverQualification(bool? value) {
    _$lifesaverQualificationAtom
        .reportWrite(value, super.lifesaverQualification, () {
      super.lifesaverQualification = value;
    });
  }

  late final _$withLifesaversAtom =
      Atom(name: '_Report.withLifesavers', context: context);

  @override
  bool? get withLifesavers {
    _$withLifesaversAtom.reportRead();
    return super.withLifesavers;
  }

  @override
  set withLifesavers(bool? value) {
    _$withLifesaversAtom.reportWrite(value, super.withLifesavers, () {
      super.withLifesavers = value;
    });
  }

  late final _$totalCountAtom =
      Atom(name: '_Report.totalCount', context: context);

  @override
  int? get totalCount {
    _$totalCountAtom.reportRead();
    return super.totalCount;
  }

  @override
  set totalCount(int? value) {
    _$totalCountAtom.reportWrite(value, super.totalCount, () {
      super.totalCount = value;
    });
  }

  late final _$teamCountAtom =
      Atom(name: '_Report.teamCount', context: context);

  @override
  int? get teamCount {
    _$teamCountAtom.reportRead();
    return super.teamCount;
  }

  @override
  set teamCount(int? value) {
    _$teamCountAtom.reportWrite(value, super.teamCount, () {
      super.teamCount = value;
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

  late final _$sickInjuredPersonFamilyAtom =
      Atom(name: '_Report.sickInjuredPersonFamily', context: context);

  @override
  String? get sickInjuredPersonFamily {
    _$sickInjuredPersonFamilyAtom.reportRead();
    return super.sickInjuredPersonFamily;
  }

  @override
  set sickInjuredPersonFamily(String? value) {
    _$sickInjuredPersonFamilyAtom
        .reportWrite(value, super.sickInjuredPersonFamily, () {
      super.sickInjuredPersonFamily = value;
    });
  }

  late final _$sickInjuredPersonFamilyTelAtom =
      Atom(name: '_Report.sickInjuredPersonFamilyTel', context: context);

  @override
  String? get sickInjuredPersonFamilyTel {
    _$sickInjuredPersonFamilyTelAtom.reportRead();
    return super.sickInjuredPersonFamilyTel;
  }

  @override
  set sickInjuredPersonFamilyTel(String? value) {
    _$sickInjuredPersonFamilyTelAtom
        .reportWrite(value, super.sickInjuredPersonFamilyTel, () {
      super.sickInjuredPersonFamilyTel = value;
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

  late final _$sickInjuredPersonKakaritsukeAtom =
      Atom(name: '_Report.sickInjuredPersonKakaritsuke', context: context);

  @override
  String? get sickInjuredPersonKakaritsuke {
    _$sickInjuredPersonKakaritsukeAtom.reportRead();
    return super.sickInjuredPersonKakaritsuke;
  }

  @override
  set sickInjuredPersonKakaritsuke(String? value) {
    _$sickInjuredPersonKakaritsukeAtom
        .reportWrite(value, super.sickInjuredPersonKakaritsuke, () {
      super.sickInjuredPersonKakaritsuke = value;
    });
  }

  late final _$sickInjuredPersonMedicationAtom =
      Atom(name: '_Report.sickInjuredPersonMedication', context: context);

  @override
  String? get sickInjuredPersonMedication {
    _$sickInjuredPersonMedicationAtom.reportRead();
    return super.sickInjuredPersonMedication;
  }

  @override
  set sickInjuredPersonMedication(String? value) {
    _$sickInjuredPersonMedicationAtom
        .reportWrite(value, super.sickInjuredPersonMedication, () {
      super.sickInjuredPersonMedication = value;
    });
  }

  late final _$sickInjuredPersonMedicationDetailAtom =
      Atom(name: '_Report.sickInjuredPersonMedicationDetail', context: context);

  @override
  String? get sickInjuredPersonMedicationDetail {
    _$sickInjuredPersonMedicationDetailAtom.reportRead();
    return super.sickInjuredPersonMedicationDetail;
  }

  @override
  set sickInjuredPersonMedicationDetail(String? value) {
    _$sickInjuredPersonMedicationDetailAtom
        .reportWrite(value, super.sickInjuredPersonMedicationDetail, () {
      super.sickInjuredPersonMedicationDetail = value;
    });
  }

  late final _$sickInjuredPersonAllergyAtom =
      Atom(name: '_Report.sickInjuredPersonAllergy', context: context);

  @override
  String? get sickInjuredPersonAllergy {
    _$sickInjuredPersonAllergyAtom.reportRead();
    return super.sickInjuredPersonAllergy;
  }

  @override
  set sickInjuredPersonAllergy(String? value) {
    _$sickInjuredPersonAllergyAtom
        .reportWrite(value, super.sickInjuredPersonAllergy, () {
      super.sickInjuredPersonAllergy = value;
    });
  }

  late final _$sickInjuredPersonNameOfInjuryOrSicknessAtom = Atom(
      name: '_Report.sickInjuredPersonNameOfInjuryOrSickness',
      context: context);

  @override
  String? get sickInjuredPersonNameOfInjuryOrSickness {
    _$sickInjuredPersonNameOfInjuryOrSicknessAtom.reportRead();
    return super.sickInjuredPersonNameOfInjuryOrSickness;
  }

  @override
  set sickInjuredPersonNameOfInjuryOrSickness(String? value) {
    _$sickInjuredPersonNameOfInjuryOrSicknessAtom
        .reportWrite(value, super.sickInjuredPersonNameOfInjuryOrSickness, () {
      super.sickInjuredPersonNameOfInjuryOrSickness = value;
    });
  }

  late final _$sickInjuredPersonDegreeAtom =
      Atom(name: '_Report.sickInjuredPersonDegree', context: context);

  @override
  String? get sickInjuredPersonDegree {
    _$sickInjuredPersonDegreeAtom.reportRead();
    return super.sickInjuredPersonDegree;
  }

  @override
  set sickInjuredPersonDegree(String? value) {
    _$sickInjuredPersonDegreeAtom
        .reportWrite(value, super.sickInjuredPersonDegree, () {
      super.sickInjuredPersonDegree = value;
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

  late final _$commandTimeAtom =
      Atom(name: '_Report.commandTime', context: context);

  @override
  TimeOfDay? get commandTime {
    _$commandTimeAtom.reportRead();
    return super.commandTime;
  }

  @override
  set commandTime(TimeOfDay? value) {
    _$commandTimeAtom.reportWrite(value, super.commandTime, () {
      super.commandTime = value;
    });
  }

  late final _$dispatchTimeAtom =
      Atom(name: '_Report.dispatchTime', context: context);

  @override
  TimeOfDay? get dispatchTime {
    _$dispatchTimeAtom.reportRead();
    return super.dispatchTime;
  }

  @override
  set dispatchTime(TimeOfDay? value) {
    _$dispatchTimeAtom.reportWrite(value, super.dispatchTime, () {
      super.dispatchTime = value;
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

  late final _$familyContactTimeAtom =
      Atom(name: '_Report.familyContactTime', context: context);

  @override
  TimeOfDay? get familyContactTime {
    _$familyContactTimeAtom.reportRead();
    return super.familyContactTime;
  }

  @override
  set familyContactTime(TimeOfDay? value) {
    _$familyContactTimeAtom.reportWrite(value, super.familyContactTime, () {
      super.familyContactTime = value;
    });
  }

  late final _$policeContactTimeAtom =
      Atom(name: '_Report.policeContactTime', context: context);

  @override
  TimeOfDay? get policeContactTime {
    _$policeContactTimeAtom.reportRead();
    return super.policeContactTime;
  }

  @override
  set policeContactTime(TimeOfDay? value) {
    _$policeContactTimeAtom.reportWrite(value, super.policeContactTime, () {
      super.policeContactTime = value;
    });
  }

  late final _$timeOfArrivalAtom =
      Atom(name: '_Report.timeOfArrival', context: context);

  @override
  TimeOfDay? get timeOfArrival {
    _$timeOfArrivalAtom.reportRead();
    return super.timeOfArrival;
  }

  @override
  set timeOfArrival(TimeOfDay? value) {
    _$timeOfArrivalAtom.reportWrite(value, super.timeOfArrival, () {
      super.timeOfArrival = value;
    });
  }

  late final _$returnTimeAtom =
      Atom(name: '_Report.returnTime', context: context);

  @override
  TimeOfDay? get returnTime {
    _$returnTimeAtom.reportRead();
    return super.returnTime;
  }

  @override
  set returnTime(TimeOfDay? value) {
    _$returnTimeAtom.reportWrite(value, super.returnTime, () {
      super.returnTime = value;
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

  late final _$placeOfDispatchAtom =
      Atom(name: '_Report.placeOfDispatch', context: context);

  @override
  String? get placeOfDispatch {
    _$placeOfDispatchAtom.reportRead();
    return super.placeOfDispatch;
  }

  @override
  set placeOfDispatch(String? value) {
    _$placeOfDispatchAtom.reportWrite(value, super.placeOfDispatch, () {
      super.placeOfDispatch = value;
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

  late final _$adlAtom = Atom(name: '_Report.adl', context: context);

  @override
  String? get adl {
    _$adlAtom.reportRead();
    return super.adl;
  }

  @override
  set adl(String? value) {
    _$adlAtom.reportWrite(value, super.adl, () {
      super.adl = value;
    });
  }

  late final _$trafficAccidentClassificationAtom =
      Atom(name: '_Report.trafficAccidentClassification', context: context);

  @override
  String? get trafficAccidentClassification {
    _$trafficAccidentClassificationAtom.reportRead();
    return super.trafficAccidentClassification;
  }

  @override
  set trafficAccidentClassification(String? value) {
    _$trafficAccidentClassificationAtom
        .reportWrite(value, super.trafficAccidentClassification, () {
      super.trafficAccidentClassification = value;
    });
  }

  late final _$witnessesAtom =
      Atom(name: '_Report.witnesses', context: context);

  @override
  bool? get witnesses {
    _$witnessesAtom.reportRead();
    return super.witnesses;
  }

  @override
  set witnesses(bool? value) {
    _$witnessesAtom.reportWrite(value, super.witnesses, () {
      super.witnesses = value;
    });
  }

  late final _$bystanderCprAtom =
      Atom(name: '_Report.bystanderCpr', context: context);

  @override
  TimeOfDay? get bystanderCpr {
    _$bystanderCprAtom.reportRead();
    return super.bystanderCpr;
  }

  @override
  set bystanderCpr(TimeOfDay? value) {
    _$bystanderCprAtom.reportWrite(value, super.bystanderCpr, () {
      super.bystanderCpr = value;
    });
  }

  late final _$verbalGuidanceAtom =
      Atom(name: '_Report.verbalGuidance', context: context);

  @override
  String? get verbalGuidance {
    _$verbalGuidanceAtom.reportRead();
    return super.verbalGuidance;
  }

  @override
  set verbalGuidance(String? value) {
    _$verbalGuidanceAtom.reportWrite(value, super.verbalGuidance, () {
      super.verbalGuidance = value;
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

  late final _$gcsEAtom = Atom(name: '_Report.gcsE', context: context);

  @override
  ObservableList<String?>? get gcsE {
    _$gcsEAtom.reportRead();
    return super.gcsE;
  }

  @override
  set gcsE(ObservableList<String?>? value) {
    _$gcsEAtom.reportWrite(value, super.gcsE, () {
      super.gcsE = value;
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

  late final _$spO2LiterAtom =
      Atom(name: '_Report.spO2Liter', context: context);

  @override
  ObservableList<int?>? get spO2Liter {
    _$spO2LiterAtom.reportRead();
    return super.spO2Liter;
  }

  @override
  set spO2Liter(ObservableList<int?>? value) {
    _$spO2LiterAtom.reportWrite(value, super.spO2Liter, () {
      super.spO2Liter = value;
    });
  }

  late final _$pupilRightAtom =
      Atom(name: '_Report.pupilRight', context: context);

  @override
  ObservableList<int?>? get pupilRight {
    _$pupilRightAtom.reportRead();
    return super.pupilRight;
  }

  @override
  set pupilRight(ObservableList<int?>? value) {
    _$pupilRightAtom.reportWrite(value, super.pupilRight, () {
      super.pupilRight = value;
    });
  }

  late final _$pupilLeftAtom =
      Atom(name: '_Report.pupilLeft', context: context);

  @override
  ObservableList<int?>? get pupilLeft {
    _$pupilLeftAtom.reportRead();
    return super.pupilLeft;
  }

  @override
  set pupilLeft(ObservableList<int?>? value) {
    _$pupilLeftAtom.reportWrite(value, super.pupilLeft, () {
      super.pupilLeft = value;
    });
  }

  late final _$lightReflexRightAtom =
      Atom(name: '_Report.lightReflexRight', context: context);

  @override
  ObservableList<bool?>? get lightReflexRight {
    _$lightReflexRightAtom.reportRead();
    return super.lightReflexRight;
  }

  @override
  set lightReflexRight(ObservableList<bool?>? value) {
    _$lightReflexRightAtom.reportWrite(value, super.lightReflexRight, () {
      super.lightReflexRight = value;
    });
  }

  late final _$lightReflexLeftAtom =
      Atom(name: '_Report.lightReflexLeft', context: context);

  @override
  ObservableList<bool?>? get lightReflexLeft {
    _$lightReflexLeftAtom.reportRead();
    return super.lightReflexLeft;
  }

  @override
  set lightReflexLeft(ObservableList<bool?>? value) {
    _$lightReflexLeftAtom.reportWrite(value, super.lightReflexLeft, () {
      super.lightReflexLeft = value;
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

  late final _$facialFeaturesAtom =
      Atom(name: '_Report.facialFeatures', context: context);

  @override
  ObservableList<String?>? get facialFeatures {
    _$facialFeaturesAtom.reportRead();
    return super.facialFeatures;
  }

  @override
  set facialFeatures(ObservableList<String?>? value) {
    _$facialFeaturesAtom.reportWrite(value, super.facialFeatures, () {
      super.facialFeatures = value;
    });
  }

  late final _$hemorrhageAtom =
      Atom(name: '_Report.hemorrhage', context: context);

  @override
  ObservableList<String?>? get hemorrhage {
    _$hemorrhageAtom.reportRead();
    return super.hemorrhage;
  }

  @override
  set hemorrhage(ObservableList<String?>? value) {
    _$hemorrhageAtom.reportWrite(value, super.hemorrhage, () {
      super.hemorrhage = value;
    });
  }

  late final _$incontinenceAtom =
      Atom(name: '_Report.incontinence', context: context);

  @override
  ObservableList<String?>? get incontinence {
    _$incontinenceAtom.reportRead();
    return super.incontinence;
  }

  @override
  set incontinence(ObservableList<String?>? value) {
    _$incontinenceAtom.reportWrite(value, super.incontinence, () {
      super.incontinence = value;
    });
  }

  late final _$vomitingAtom = Atom(name: '_Report.vomiting', context: context);

  @override
  ObservableList<bool?>? get vomiting {
    _$vomitingAtom.reportRead();
    return super.vomiting;
  }

  @override
  set vomiting(ObservableList<bool?>? value) {
    _$vomitingAtom.reportWrite(value, super.vomiting, () {
      super.vomiting = value;
    });
  }

  late final _$extremitiesAtom =
      Atom(name: '_Report.extremities', context: context);

  @override
  ObservableList<String?>? get extremities {
    _$extremitiesAtom.reportRead();
    return super.extremities;
  }

  @override
  set extremities(ObservableList<String?>? value) {
    _$extremitiesAtom.reportWrite(value, super.extremities, () {
      super.extremities = value;
    });
  }

  late final _$descriptionOfObservationTimeAtom =
      Atom(name: '_Report.descriptionOfObservationTime', context: context);

  @override
  ObservableList<String?>? get descriptionOfObservationTime {
    _$descriptionOfObservationTimeAtom.reportRead();
    return super.descriptionOfObservationTime;
  }

  @override
  set descriptionOfObservationTime(ObservableList<String?>? value) {
    _$descriptionOfObservationTimeAtom
        .reportWrite(value, super.descriptionOfObservationTime, () {
      super.descriptionOfObservationTime = value;
    });
  }

  late final _$eachEcgAtom = Atom(name: '_Report.eachEcg', context: context);

  @override
  ObservableList<String?>? get eachEcg {
    _$eachEcgAtom.reportRead();
    return super.eachEcg;
  }

  @override
  set eachEcg(ObservableList<String?>? value) {
    _$eachEcgAtom.reportWrite(value, super.eachEcg, () {
      super.eachEcg = value;
    });
  }

  late final _$eachOxygenInhalationAtom =
      Atom(name: '_Report.eachOxygenInhalation', context: context);

  @override
  ObservableList<double?>? get eachOxygenInhalation {
    _$eachOxygenInhalationAtom.reportRead();
    return super.eachOxygenInhalation;
  }

  @override
  set eachOxygenInhalation(ObservableList<double?>? value) {
    _$eachOxygenInhalationAtom.reportWrite(value, super.eachOxygenInhalation,
        () {
      super.eachOxygenInhalation = value;
    });
  }

  late final _$eachHemostasisAtom =
      Atom(name: '_Report.eachHemostasis', context: context);

  @override
  ObservableList<bool?>? get eachHemostasis {
    _$eachHemostasisAtom.reportRead();
    return super.eachHemostasis;
  }

  @override
  set eachHemostasis(ObservableList<bool?>? value) {
    _$eachHemostasisAtom.reportWrite(value, super.eachHemostasis, () {
      super.eachHemostasis = value;
    });
  }

  late final _$eachSuctionAtom =
      Atom(name: '_Report.eachSuction', context: context);

  @override
  ObservableList<bool?>? get eachSuction {
    _$eachSuctionAtom.reportRead();
    return super.eachSuction;
  }

  @override
  set eachSuction(ObservableList<bool?>? value) {
    _$eachSuctionAtom.reportWrite(value, super.eachSuction, () {
      super.eachSuction = value;
    });
  }

  late final _$otherProcess1Atom =
      Atom(name: '_Report.otherProcess1', context: context);

  @override
  ObservableList<String?>? get otherProcess1 {
    _$otherProcess1Atom.reportRead();
    return super.otherProcess1;
  }

  @override
  set otherProcess1(ObservableList<String?>? value) {
    _$otherProcess1Atom.reportWrite(value, super.otherProcess1, () {
      super.otherProcess1 = value;
    });
  }

  late final _$otherProcess2Atom =
      Atom(name: '_Report.otherProcess2', context: context);

  @override
  ObservableList<String?>? get otherProcess2 {
    _$otherProcess2Atom.reportRead();
    return super.otherProcess2;
  }

  @override
  set otherProcess2(ObservableList<String?>? value) {
    _$otherProcess2Atom.reportWrite(value, super.otherProcess2, () {
      super.otherProcess2 = value;
    });
  }

  late final _$otherProcess3Atom =
      Atom(name: '_Report.otherProcess3', context: context);

  @override
  ObservableList<String?>? get otherProcess3 {
    _$otherProcess3Atom.reportRead();
    return super.otherProcess3;
  }

  @override
  set otherProcess3(ObservableList<String?>? value) {
    _$otherProcess3Atom.reportWrite(value, super.otherProcess3, () {
      super.otherProcess3 = value;
    });
  }

  late final _$otherProcess4Atom =
      Atom(name: '_Report.otherProcess4', context: context);

  @override
  ObservableList<String?>? get otherProcess4 {
    _$otherProcess4Atom.reportRead();
    return super.otherProcess4;
  }

  @override
  set otherProcess4(ObservableList<String?>? value) {
    _$otherProcess4Atom.reportWrite(value, super.otherProcess4, () {
      super.otherProcess4 = value;
    });
  }

  late final _$otherProcess5Atom =
      Atom(name: '_Report.otherProcess5', context: context);

  @override
  ObservableList<String?>? get otherProcess5 {
    _$otherProcess5Atom.reportRead();
    return super.otherProcess5;
  }

  @override
  set otherProcess5(ObservableList<String?>? value) {
    _$otherProcess5Atom.reportWrite(value, super.otherProcess5, () {
      super.otherProcess5 = value;
    });
  }

  late final _$otherProcess6Atom =
      Atom(name: '_Report.otherProcess6', context: context);

  @override
  ObservableList<String?>? get otherProcess6 {
    _$otherProcess6Atom.reportRead();
    return super.otherProcess6;
  }

  @override
  set otherProcess6(ObservableList<String?>? value) {
    _$otherProcess6Atom.reportWrite(value, super.otherProcess6, () {
      super.otherProcess6 = value;
    });
  }

  late final _$otherProcess7Atom =
      Atom(name: '_Report.otherProcess7', context: context);

  @override
  ObservableList<String?>? get otherProcess7 {
    _$otherProcess7Atom.reportRead();
    return super.otherProcess7;
  }

  @override
  set otherProcess7(ObservableList<String?>? value) {
    _$otherProcess7Atom.reportWrite(value, super.otherProcess7, () {
      super.otherProcess7 = value;
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

  late final _$securingAirwayAtom =
      Atom(name: '_Report.securingAirway', context: context);

  @override
  String? get securingAirway {
    _$securingAirwayAtom.reportRead();
    return super.securingAirway;
  }

  @override
  set securingAirway(String? value) {
    _$securingAirwayAtom.reportWrite(value, super.securingAirway, () {
      super.securingAirway = value;
    });
  }

  late final _$foreignBodyRemovalAtom =
      Atom(name: '_Report.foreignBodyRemoval', context: context);

  @override
  bool? get foreignBodyRemoval {
    _$foreignBodyRemovalAtom.reportRead();
    return super.foreignBodyRemoval;
  }

  @override
  set foreignBodyRemoval(bool? value) {
    _$foreignBodyRemovalAtom.reportWrite(value, super.foreignBodyRemoval, () {
      super.foreignBodyRemoval = value;
    });
  }

  late final _$suctionAtom = Atom(name: '_Report.suction', context: context);

  @override
  bool? get suction {
    _$suctionAtom.reportRead();
    return super.suction;
  }

  @override
  set suction(bool? value) {
    _$suctionAtom.reportWrite(value, super.suction, () {
      super.suction = value;
    });
  }

  late final _$artificialRespirationAtom =
      Atom(name: '_Report.artificialRespiration', context: context);

  @override
  bool? get artificialRespiration {
    _$artificialRespirationAtom.reportRead();
    return super.artificialRespiration;
  }

  @override
  set artificialRespiration(bool? value) {
    _$artificialRespirationAtom.reportWrite(value, super.artificialRespiration,
        () {
      super.artificialRespiration = value;
    });
  }

  late final _$chestCompressionsAtom =
      Atom(name: '_Report.chestCompressions', context: context);

  @override
  bool? get chestCompressions {
    _$chestCompressionsAtom.reportRead();
    return super.chestCompressions;
  }

  @override
  set chestCompressions(bool? value) {
    _$chestCompressionsAtom.reportWrite(value, super.chestCompressions, () {
      super.chestCompressions = value;
    });
  }

  late final _$ecgMonitorAtom =
      Atom(name: '_Report.ecgMonitor', context: context);

  @override
  bool? get ecgMonitor {
    _$ecgMonitorAtom.reportRead();
    return super.ecgMonitor;
  }

  @override
  set ecgMonitor(bool? value) {
    _$ecgMonitorAtom.reportWrite(value, super.ecgMonitor, () {
      super.ecgMonitor = value;
    });
  }

  late final _$o2AdministrationAtom =
      Atom(name: '_Report.o2Administration', context: context);

  @override
  double? get o2Administration {
    _$o2AdministrationAtom.reportRead();
    return super.o2Administration;
  }

  @override
  set o2Administration(double? value) {
    _$o2AdministrationAtom.reportWrite(value, super.o2Administration, () {
      super.o2Administration = value;
    });
  }

  late final _$o2AdministrationTimeAtom =
      Atom(name: '_Report.o2AdministrationTime', context: context);

  @override
  TimeOfDay? get o2AdministrationTime {
    _$o2AdministrationTimeAtom.reportRead();
    return super.o2AdministrationTime;
  }

  @override
  set o2AdministrationTime(TimeOfDay? value) {
    _$o2AdministrationTimeAtom.reportWrite(value, super.o2AdministrationTime,
        () {
      super.o2AdministrationTime = value;
    });
  }

  late final _$limitationOfSpinalMotionAtom =
      Atom(name: '_Report.limitationOfSpinalMotion', context: context);

  @override
  String? get limitationOfSpinalMotion {
    _$limitationOfSpinalMotionAtom.reportRead();
    return super.limitationOfSpinalMotion;
  }

  @override
  set limitationOfSpinalMotion(String? value) {
    _$limitationOfSpinalMotionAtom
        .reportWrite(value, super.limitationOfSpinalMotion, () {
      super.limitationOfSpinalMotion = value;
    });
  }

  late final _$hemostaticTreatmentAtom =
      Atom(name: '_Report.hemostaticTreatment', context: context);

  @override
  bool? get hemostaticTreatment {
    _$hemostaticTreatmentAtom.reportRead();
    return super.hemostaticTreatment;
  }

  @override
  set hemostaticTreatment(bool? value) {
    _$hemostaticTreatmentAtom.reportWrite(value, super.hemostaticTreatment, () {
      super.hemostaticTreatment = value;
    });
  }

  late final _$adductorFixationAtom =
      Atom(name: '_Report.adductorFixation', context: context);

  @override
  bool? get adductorFixation {
    _$adductorFixationAtom.reportRead();
    return super.adductorFixation;
  }

  @override
  set adductorFixation(bool? value) {
    _$adductorFixationAtom.reportWrite(value, super.adductorFixation, () {
      super.adductorFixation = value;
    });
  }

  late final _$coatingAtom = Atom(name: '_Report.coating', context: context);

  @override
  bool? get coating {
    _$coatingAtom.reportRead();
    return super.coating;
  }

  @override
  set coating(bool? value) {
    _$coatingAtom.reportWrite(value, super.coating, () {
      super.coating = value;
    });
  }

  late final _$burnTreatmentAtom =
      Atom(name: '_Report.burnTreatment', context: context);

  @override
  bool? get burnTreatment {
    _$burnTreatmentAtom.reportRead();
    return super.burnTreatment;
  }

  @override
  set burnTreatment(bool? value) {
    _$burnTreatmentAtom.reportWrite(value, super.burnTreatment, () {
      super.burnTreatment = value;
    });
  }

  late final _$bsMeasurement1Atom =
      Atom(name: '_Report.bsMeasurement1', context: context);

  @override
  int? get bsMeasurement1 {
    _$bsMeasurement1Atom.reportRead();
    return super.bsMeasurement1;
  }

  @override
  set bsMeasurement1(int? value) {
    _$bsMeasurement1Atom.reportWrite(value, super.bsMeasurement1, () {
      super.bsMeasurement1 = value;
    });
  }

  late final _$bsMeasurementTime1Atom =
      Atom(name: '_Report.bsMeasurementTime1', context: context);

  @override
  TimeOfDay? get bsMeasurementTime1 {
    _$bsMeasurementTime1Atom.reportRead();
    return super.bsMeasurementTime1;
  }

  @override
  set bsMeasurementTime1(TimeOfDay? value) {
    _$bsMeasurementTime1Atom.reportWrite(value, super.bsMeasurementTime1, () {
      super.bsMeasurementTime1 = value;
    });
  }

  late final _$punctureSite1Atom =
      Atom(name: '_Report.punctureSite1', context: context);

  @override
  String? get punctureSite1 {
    _$punctureSite1Atom.reportRead();
    return super.punctureSite1;
  }

  @override
  set punctureSite1(String? value) {
    _$punctureSite1Atom.reportWrite(value, super.punctureSite1, () {
      super.punctureSite1 = value;
    });
  }

  late final _$bsMeasurement2Atom =
      Atom(name: '_Report.bsMeasurement2', context: context);

  @override
  int? get bsMeasurement2 {
    _$bsMeasurement2Atom.reportRead();
    return super.bsMeasurement2;
  }

  @override
  set bsMeasurement2(int? value) {
    _$bsMeasurement2Atom.reportWrite(value, super.bsMeasurement2, () {
      super.bsMeasurement2 = value;
    });
  }

  late final _$bsMeasurementTime2Atom =
      Atom(name: '_Report.bsMeasurementTime2', context: context);

  @override
  TimeOfDay? get bsMeasurementTime2 {
    _$bsMeasurementTime2Atom.reportRead();
    return super.bsMeasurementTime2;
  }

  @override
  set bsMeasurementTime2(TimeOfDay? value) {
    _$bsMeasurementTime2Atom.reportWrite(value, super.bsMeasurementTime2, () {
      super.bsMeasurementTime2 = value;
    });
  }

  late final _$punctureSite2Atom =
      Atom(name: '_Report.punctureSite2', context: context);

  @override
  String? get punctureSite2 {
    _$punctureSite2Atom.reportRead();
    return super.punctureSite2;
  }

  @override
  set punctureSite2(String? value) {
    _$punctureSite2Atom.reportWrite(value, super.punctureSite2, () {
      super.punctureSite2 = value;
    });
  }

  late final _$otherAtom = Atom(name: '_Report.other', context: context);

  @override
  String? get other {
    _$otherAtom.reportRead();
    return super.other;
  }

  @override
  set other(String? value) {
    _$otherAtom.reportWrite(value, super.other, () {
      super.other = value;
    });
  }

  late final _$perceiverNameAtom =
      Atom(name: '_Report.perceiverName', context: context);

  @override
  String? get perceiverName {
    _$perceiverNameAtom.reportRead();
    return super.perceiverName;
  }

  @override
  set perceiverName(String? value) {
    _$perceiverNameAtom.reportWrite(value, super.perceiverName, () {
      super.perceiverName = value;
    });
  }

  late final _$typeOfDetectionAtom =
      Atom(name: '_Report.typeOfDetection', context: context);

  @override
  String? get typeOfDetection {
    _$typeOfDetectionAtom.reportRead();
    return super.typeOfDetection;
  }

  @override
  set typeOfDetection(String? value) {
    _$typeOfDetectionAtom.reportWrite(value, super.typeOfDetection, () {
      super.typeOfDetection = value;
    });
  }

  late final _$callerNameAtom =
      Atom(name: '_Report.callerName', context: context);

  @override
  String? get callerName {
    _$callerNameAtom.reportRead();
    return super.callerName;
  }

  @override
  set callerName(String? value) {
    _$callerNameAtom.reportWrite(value, super.callerName, () {
      super.callerName = value;
    });
  }

  late final _$callerTelAtom =
      Atom(name: '_Report.callerTel', context: context);

  @override
  String? get callerTel {
    _$callerTelAtom.reportRead();
    return super.callerTel;
  }

  @override
  set callerTel(String? value) {
    _$callerTelAtom.reportWrite(value, super.callerTel, () {
      super.callerTel = value;
    });
  }

  late final _$medicalTransportFacilityAtom =
      Atom(name: '_Report.medicalTransportFacility', context: context);

  @override
  String? get medicalTransportFacility {
    _$medicalTransportFacilityAtom.reportRead();
    return super.medicalTransportFacility;
  }

  @override
  set medicalTransportFacility(String? value) {
    _$medicalTransportFacilityAtom
        .reportWrite(value, super.medicalTransportFacility, () {
      super.medicalTransportFacility = value;
    });
  }

  late final _$otherMedicalTransportFacilityAtom =
      Atom(name: '_Report.otherMedicalTransportFacility', context: context);

  @override
  String? get otherMedicalTransportFacility {
    _$otherMedicalTransportFacilityAtom.reportRead();
    return super.otherMedicalTransportFacility;
  }

  @override
  set otherMedicalTransportFacility(String? value) {
    _$otherMedicalTransportFacilityAtom
        .reportWrite(value, super.otherMedicalTransportFacility, () {
      super.otherMedicalTransportFacility = value;
    });
  }

  late final _$transferringMedicalInstitutionAtom =
      Atom(name: '_Report.transferringMedicalInstitution', context: context);

  @override
  String? get transferringMedicalInstitution {
    _$transferringMedicalInstitutionAtom.reportRead();
    return super.transferringMedicalInstitution;
  }

  @override
  set transferringMedicalInstitution(String? value) {
    _$transferringMedicalInstitutionAtom
        .reportWrite(value, super.transferringMedicalInstitution, () {
      super.transferringMedicalInstitution = value;
    });
  }

  late final _$otherTransferringMedicalInstitutionAtom = Atom(
      name: '_Report.otherTransferringMedicalInstitution', context: context);

  @override
  String? get otherTransferringMedicalInstitution {
    _$otherTransferringMedicalInstitutionAtom.reportRead();
    return super.otherTransferringMedicalInstitution;
  }

  @override
  set otherTransferringMedicalInstitution(String? value) {
    _$otherTransferringMedicalInstitutionAtom
        .reportWrite(value, super.otherTransferringMedicalInstitution, () {
      super.otherTransferringMedicalInstitution = value;
    });
  }

  late final _$transferSourceReceivingTimeAtom =
      Atom(name: '_Report.transferSourceReceivingTime', context: context);

  @override
  TimeOfDay? get transferSourceReceivingTime {
    _$transferSourceReceivingTimeAtom.reportRead();
    return super.transferSourceReceivingTime;
  }

  @override
  set transferSourceReceivingTime(TimeOfDay? value) {
    _$transferSourceReceivingTimeAtom
        .reportWrite(value, super.transferSourceReceivingTime, () {
      super.transferSourceReceivingTime = value;
    });
  }

  late final _$reasonForTransferAtom =
      Atom(name: '_Report.reasonForTransfer', context: context);

  @override
  String? get reasonForTransfer {
    _$reasonForTransferAtom.reportRead();
    return super.reasonForTransfer;
  }

  @override
  set reasonForTransfer(String? value) {
    _$reasonForTransferAtom.reportWrite(value, super.reasonForTransfer, () {
      super.reasonForTransfer = value;
    });
  }

  late final _$reasonForNotTransferringAtom =
      Atom(name: '_Report.reasonForNotTransferring', context: context);

  @override
  String? get reasonForNotTransferring {
    _$reasonForNotTransferringAtom.reportRead();
    return super.reasonForNotTransferring;
  }

  @override
  set reasonForNotTransferring(String? value) {
    _$reasonForNotTransferringAtom
        .reportWrite(value, super.reasonForNotTransferring, () {
      super.reasonForNotTransferring = value;
    });
  }

  late final _$recordOfRefusalOfTransferAtom =
      Atom(name: '_Report.recordOfRefusalOfTransfer', context: context);

  @override
  bool? get recordOfRefusalOfTransfer {
    _$recordOfRefusalOfTransferAtom.reportRead();
    return super.recordOfRefusalOfTransfer;
  }

  @override
  set recordOfRefusalOfTransfer(bool? value) {
    _$recordOfRefusalOfTransferAtom
        .reportWrite(value, super.recordOfRefusalOfTransfer, () {
      super.recordOfRefusalOfTransfer = value;
    });
  }

  late final _$nameOfReporterAtom =
      Atom(name: '_Report.nameOfReporter', context: context);

  @override
  String? get nameOfReporter {
    _$nameOfReporterAtom.reportRead();
    return super.nameOfReporter;
  }

  @override
  set nameOfReporter(String? value) {
    _$nameOfReporterAtom.reportWrite(value, super.nameOfReporter, () {
      super.nameOfReporter = value;
    });
  }

  late final _$affiliationOfReporterAtom =
      Atom(name: '_Report.affiliationOfReporter', context: context);

  @override
  String? get affiliationOfReporter {
    _$affiliationOfReporterAtom.reportRead();
    return super.affiliationOfReporter;
  }

  @override
  set affiliationOfReporter(String? value) {
    _$affiliationOfReporterAtom.reportWrite(value, super.affiliationOfReporter,
        () {
      super.affiliationOfReporter = value;
    });
  }

  late final _$positionOfReporterAtom =
      Atom(name: '_Report.positionOfReporter', context: context);

  @override
  String? get positionOfReporter {
    _$positionOfReporterAtom.reportRead();
    return super.positionOfReporter;
  }

  @override
  set positionOfReporter(String? value) {
    _$positionOfReporterAtom.reportWrite(value, super.positionOfReporter, () {
      super.positionOfReporter = value;
    });
  }

  late final _$summaryOfOccurrenceAtom =
      Atom(name: '_Report.summaryOfOccurrence', context: context);

  @override
  String? get summaryOfOccurrence {
    _$summaryOfOccurrenceAtom.reportRead();
    return super.summaryOfOccurrence;
  }

  @override
  set summaryOfOccurrence(String? value) {
    _$summaryOfOccurrenceAtom.reportWrite(value, super.summaryOfOccurrence, () {
      super.summaryOfOccurrence = value;
    });
  }

  late final _$remarksAtom = Atom(name: '_Report.remarks', context: context);

  @override
  String? get remarks {
    _$remarksAtom.reportRead();
    return super.remarks;
  }

  @override
  set remarks(String? value) {
    _$remarksAtom.reportWrite(value, super.remarks, () {
      super.remarks = value;
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

  late final _$teamStoreAtom =
      Atom(name: '_Report.teamStore', context: context);

  @override
  TeamStore? get teamStore {
    _$teamStoreAtom.reportRead();
    return super.teamStore;
  }

  @override
  set teamStore(TeamStore? value) {
    _$teamStoreAtom.reportWrite(value, super.teamStore, () {
      super.teamStore = value;
    });
  }

  late final _$fireStationStoreAtom =
      Atom(name: '_Report.fireStationStore', context: context);

  @override
  FireStationStore? get fireStationStore {
    _$fireStationStoreAtom.reportRead();
    return super.fireStationStore;
  }

  @override
  set fireStationStore(FireStationStore? value) {
    _$fireStationStoreAtom.reportWrite(value, super.fireStationStore, () {
      super.fireStationStore = value;
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
  dynamic setMedication(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setMedication');
    try {
      return super.setMedication(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDegree(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setDegree');
    try {
      return super.setDegree(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDetectionType(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setDetectionType');
    try {
      return super.setDetectionType(value);
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
  dynamic setMedicalTransportFacilityType(Hospital? hospital) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setMedicalTransportFacilityType');
    try {
      return super.setMedicalTransportFacilityType(hospital);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTransferringMedicalInstitutionType(Hospital? hospital) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setTransferringMedicalInstitutionType');
    try {
      return super.setTransferringMedicalInstitutionType(hospital);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTrafficAccidentType(Classification? value) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setTrafficAccidentType');
    try {
      return super.setTrafficAccidentType(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAdlType(Classification? value) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setAdlType');
    try {
      return super.setAdlType(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSecuringAirwayType(Classification? value) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setSecuringAirwayType');
    try {
      return super.setSecuringAirwayType(value);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSpinalCordMovementLimitationType(Classification? value) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setSpinalCordMovementLimitationType');
    try {
      return super.setSpinalCordMovementLimitationType(value);
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
  dynamic setGcsETypes(List<Classification?> values) {
    final _$actionInfo =
        _$_ReportActionController.startAction(name: '_Report.setGcsETypes');
    try {
      return super.setGcsETypes(values);
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
  dynamic setFacialFeatureTypes(List<Classification?> values) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setFacialFeatureTypes');
    try {
      return super.setFacialFeatureTypes(values);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIncontinenceTypes(List<Classification?> values) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setIncontinenceTypes');
    try {
      return super.setIncontinenceTypes(values);
    } finally {
      _$_ReportActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setObservationTimeDescriptionTypes(List<Classification?> values) {
    final _$actionInfo = _$_ReportActionController.startAction(
        name: '_Report.setObservationTimeDescriptionTypes');
    try {
      return super.setObservationTimeDescriptionTypes(values);
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
teamMemberName: ${teamMemberName},
institutionalMemberName: ${institutionalMemberName},
lifesaverQualification: ${lifesaverQualification},
withLifesavers: ${withLifesavers},
totalCount: ${totalCount},
teamCount: ${teamCount},
sickInjuredPersonName: ${sickInjuredPersonName},
sickInjuredPersonKana: ${sickInjuredPersonKana},
sickInjuredPersonAddress: ${sickInjuredPersonAddress},
sickInjuredPersonGender: ${sickInjuredPersonGender},
sickInjuredPersonBirthDate: ${sickInjuredPersonBirthDate},
sickInjuredPersonTel: ${sickInjuredPersonTel},
sickInjuredPersonFamily: ${sickInjuredPersonFamily},
sickInjuredPersonFamilyTel: ${sickInjuredPersonFamilyTel},
sickInjuredPersonMedicalHistory: ${sickInjuredPersonMedicalHistory},
sickInjuredPersonHistoryHospital: ${sickInjuredPersonHistoryHospital},
sickInjuredPersonKakaritsuke: ${sickInjuredPersonKakaritsuke},
sickInjuredPersonMedication: ${sickInjuredPersonMedication},
sickInjuredPersonMedicationDetail: ${sickInjuredPersonMedicationDetail},
sickInjuredPersonAllergy: ${sickInjuredPersonAllergy},
sickInjuredPersonNameOfInjuryOrSickness: ${sickInjuredPersonNameOfInjuryOrSickness},
sickInjuredPersonDegree: ${sickInjuredPersonDegree},
senseTime: ${senseTime},
commandTime: ${commandTime},
dispatchTime: ${dispatchTime},
onSiteArrivalTime: ${onSiteArrivalTime},
contactTime: ${contactTime},
inVehicleTime: ${inVehicleTime},
startOfTransportTime: ${startOfTransportTime},
hospitalArrivalTime: ${hospitalArrivalTime},
familyContactTime: ${familyContactTime},
policeContactTime: ${policeContactTime},
timeOfArrival: ${timeOfArrival},
returnTime: ${returnTime},
typeOfAccident: ${typeOfAccident},
dateOfOccurrence: ${dateOfOccurrence},
timeOfOccurrence: ${timeOfOccurrence},
placeOfIncident: ${placeOfIncident},
placeOfDispatch: ${placeOfDispatch},
accidentSummary: ${accidentSummary},
adl: ${adl},
trafficAccidentClassification: ${trafficAccidentClassification},
witnesses: ${witnesses},
bystanderCpr: ${bystanderCpr},
verbalGuidance: ${verbalGuidance},
observationTime: ${observationTime},
jcs: ${jcs},
gcsE: ${gcsE},
gcsV: ${gcsV},
gcsM: ${gcsM},
respiration: ${respiration},
pulse: ${pulse},
bloodPressureHigh: ${bloodPressureHigh},
bloodPressureLow: ${bloodPressureLow},
spO2Percent: ${spO2Percent},
spO2Liter: ${spO2Liter},
pupilRight: ${pupilRight},
pupilLeft: ${pupilLeft},
lightReflexRight: ${lightReflexRight},
lightReflexLeft: ${lightReflexLeft},
bodyTemperature: ${bodyTemperature},
facialFeatures: ${facialFeatures},
hemorrhage: ${hemorrhage},
incontinence: ${incontinence},
vomiting: ${vomiting},
extremities: ${extremities},
descriptionOfObservationTime: ${descriptionOfObservationTime},
eachEcg: ${eachEcg},
eachOxygenInhalation: ${eachOxygenInhalation},
eachHemostasis: ${eachHemostasis},
eachSuction: ${eachSuction},
otherProcess1: ${otherProcess1},
otherProcess2: ${otherProcess2},
otherProcess3: ${otherProcess3},
otherProcess4: ${otherProcess4},
otherProcess5: ${otherProcess5},
otherProcess6: ${otherProcess6},
otherProcess7: ${otherProcess7},
otherOfObservationTime: ${otherOfObservationTime},
securingAirway: ${securingAirway},
foreignBodyRemoval: ${foreignBodyRemoval},
suction: ${suction},
artificialRespiration: ${artificialRespiration},
chestCompressions: ${chestCompressions},
ecgMonitor: ${ecgMonitor},
o2Administration: ${o2Administration},
o2AdministrationTime: ${o2AdministrationTime},
limitationOfSpinalMotion: ${limitationOfSpinalMotion},
hemostaticTreatment: ${hemostaticTreatment},
adductorFixation: ${adductorFixation},
coating: ${coating},
burnTreatment: ${burnTreatment},
bsMeasurement1: ${bsMeasurement1},
bsMeasurementTime1: ${bsMeasurementTime1},
punctureSite1: ${punctureSite1},
bsMeasurement2: ${bsMeasurement2},
bsMeasurementTime2: ${bsMeasurementTime2},
punctureSite2: ${punctureSite2},
other: ${other},
perceiverName: ${perceiverName},
typeOfDetection: ${typeOfDetection},
callerName: ${callerName},
callerTel: ${callerTel},
medicalTransportFacility: ${medicalTransportFacility},
otherMedicalTransportFacility: ${otherMedicalTransportFacility},
transferringMedicalInstitution: ${transferringMedicalInstitution},
otherTransferringMedicalInstitution: ${otherTransferringMedicalInstitution},
transferSourceReceivingTime: ${transferSourceReceivingTime},
reasonForTransfer: ${reasonForTransfer},
reasonForNotTransferring: ${reasonForNotTransferring},
recordOfRefusalOfTransfer: ${recordOfRefusalOfTransfer},
nameOfReporter: ${nameOfReporter},
affiliationOfReporter: ${affiliationOfReporter},
positionOfReporter: ${positionOfReporter},
summaryOfOccurrence: ${summaryOfOccurrence},
remarks: ${remarks},
entryName: ${entryName},
entryMachine: ${entryMachine},
entryDate: ${entryDate},
updateName: ${updateName},
updateMachine: ${updateMachine},
updateDate: ${updateDate},
teamStore: ${teamStore},
fireStationStore: ${fireStationStore},
classificationStore: ${classificationStore},
hospitalStore: ${hospitalStore},
sickInjuredPersonAge: ${sickInjuredPersonAge},
team: ${team},
gender: ${gender},
medication: ${medication},
degree: ${degree},
detectionType: ${detectionType},
accidentType: ${accidentType},
medicalTransportFacilityType: ${medicalTransportFacilityType},
transferringMedicalInstitutionType: ${transferringMedicalInstitutionType},
trafficAccidentType: ${trafficAccidentType},
adlType: ${adlType},
securingAirwayType: ${securingAirwayType},
limitationOfSpinalMotionType: ${limitationOfSpinalMotionType},
jcsTypes: ${jcsTypes},
gcsETypes: ${gcsETypes},
gcsVTypes: ${gcsVTypes},
gcsMTypes: ${gcsMTypes},
facialFeatureTypes: ${facialFeatureTypes},
incontinenceTypes: ${incontinenceTypes},
observationTimeDescriptionTypes: ${observationTimeDescriptionTypes}
    ''';
  }
}
