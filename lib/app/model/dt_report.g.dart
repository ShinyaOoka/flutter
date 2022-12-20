// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DTReport _$DTReportFromJson(Map<String, dynamic> json) => DTReport(
      ID: json['ID'],
      TeamName: json['TeamName'],
      TeamTEL: json['TeamTEL'],
      TeamCaptainName: json['TeamCaptainName'],
      LifesaverQualification: json['LifesaverQualification'],
      WithLifeSavers: json['WithLifeSavers'],
      TeamMemberName: json['TeamMemberName'],
      InstitutionalMemberName: json['InstitutionalMemberName'],
      Total: json['Total'],
      Team: json['Team'],
      SickInjuredPersonName: json['SickInjuredPersonName'],
      SickInjuredPersonKANA: json['SickInjuredPersonKANA'],
      SickInjuredPersonAddress: json['SickInjuredPersonAddress'],
      SickInjuredPersonGender: json['SickInjuredPersonGender'],
      SickInjuredPersonBirthDate: json['SickInjuredPersonBirthDate'],
      SickInjuredPersonTEL: json['SickInjuredPersonTEL'],
      SickInjuredPersonFamilyTEL: json['SickInjuredPersonFamilyTEL'],
      SickInjuredPersonMedicalHistroy: json['SickInjuredPersonMedicalHistroy'],
      SickInjuredPersonHistoryHospital:
          json['SickInjuredPersonHistoryHospital'],
      SickInjuredPersonKakaritsuke: json['SickInjuredPersonKakaritsuke'],
      SickInjuredPersonMedication: json['SickInjuredPersonMedication'],
      SickInjuredPersonMedicationDetail:
          json['SickInjuredPersonMedicationDetail'],
      SickInjuredPersonAllergy: json['SickInjuredPersonAllergy'],
      SickInjuredPersonNameOfInjuaryOrSickness:
          json['SickInjuredPersonNameOfInjuaryOrSickness'],
      SickInjuredPersonDegree: json['SickInjuredPersonDegree'],
      SickInjuredPersonAge: json['SickInjuredPersonAge'],
      SenseTime: json['SenseTime'],
      CommandTime: json['CommandTime'],
      AttendanceTime: json['AttendanceTime'],
      OnsiteArrivalTime: json['OnsiteArrivalTime'],
      ContactTime: json['ContactTime'],
      InvehicleTime: json['InvehicleTime'],
      StartOfTransportTime: json['StartOfTransportTime'],
      HospitalArrivalTime: json['HospitalArrivalTime'],
      FamilyContactTime: json['FamilyContactTime'],
      PoliceContactTime: json['PoliceContactTime'],
      TimeOfArrival: json['TimeOfArrival'],
      ReturnTime: json['ReturnTime'],
      TypeOfAccident: json['TypeOfAccident'],
      DateOfOccurrence: json['DateOfOccurrence'],
      TimeOfOccurrence: json['TimeOfOccurrence'],
      PlaceOfIncident: json['PlaceOfIncident'],
      AccidentSummary: json['AccidentSummary'],
      ADL: json['ADL'],
      TrafficAccidentClassification: json['TrafficAccidentClassification'],
      Witnesses: json['Witnesses'],
      BystanderCPR: json['BystanderCPR'],
      VerbalGuidance: json['VerbalGuidance'],
      ObservationTime: json['ObservationTime'],
      DescriptionOfObservationTime: json['DescriptionOfObservationTime'],
      JCS: json['JCS'],
      GCS: json['GCS'],
      Respiration: json['Respiration'],
      Pulse: json['Pulse'],
      BloodPressureHigh: json['BloodPressureHigh'],
      BloodPressureLow: json['BloodPressureLow'],
      SpO2Percent: json['SpO2Percent'],
      SpO2Liter: json['SpO2Liter'],
      PupilRight: json['PupilRight'],
      PupilLeft: json['PupilLeft'],
      LightReflexRight: json['LightReflexRight'],
      PhotoreflexLeft: json['PhotoreflexLeft'],
      BodyTemperature: json['BodyTemperature'],
      FacialFeatures: json['FacialFeatures'],
      Hemorrhage: json['Hemorrhage'],
      Incontinence: json['Incontinence'],
      Vomiting: json['Vomiting'],
      Extremities: json['Extremities'],
      SecuringAirway: json['SecuringAirway'],
      ForeignBodyRemoval: json['ForeignBodyRemoval'],
      Suction: json['Suction'],
      ArtificialRespiration: json['ArtificialRespiration'],
      ChestCompressions: json['ChestCompressions'],
      ECGMonitor: json['ECGMonitor'],
      O2Administration: json['O2Administration'],
      O2AdministrationTime: json['O2AdministrationTime'],
      SpinalCordMovementLimitation: json['SpinalCordMovementLimitation'],
      HemostaticTreatment: json['HemostaticTreatment'],
      AdductorFixation: json['AdductorFixation'],
      Coating: json['Coating'],
      BurnTreatment: json['BurnTreatment'],
      BSMeasurement1: json['BSMeasurement1'],
      BSMeasurementTime1: json['BSMeasurementTime1'],
      PunctureSite1: json['PunctureSite1'],
      BSMeasurement2: json['BSMeasurement2'],
      BSMeasurementTime2: json['BSMeasurementTime2'],
      PunctureSite2: json['PunctureSite2'],
      Other: json['Other'],
      PerceiverName: json['PerceiverName'],
      TypeOfDetection: json['TypeOfDetection'],
      CallerName: json['CallerName'],
      CallerTEL: json['CallerTEL'],
      MedicalTransportFacility: json['MedicalTransportFacility'],
      TransferringMedicalInstitution: json['TransferringMedicalInstitution'],
      TransferSourceReceivingTime: json['TransferSourceReceivingTime'],
      ReasonForTransfer: json['ReasonForTransfer'],
      ReasonForNotTransferring: json['ReasonForNotTransferring'],
      RecordOfRefusalOfTransfer: json['RecordOfRefusalOfTransfer'],
      Remark: json['Remark'],
      ReporterName: json['ReporterName'],
      ReporterPosition: json['ReporterPosition'],
      EntryName: json['EntryName'],
      EntryMachine: json['EntryMachine'],
      EntryDate: json['EntryDate'],
      UpdateName: json['UpdateName'],
      UpdateMachine: json['UpdateMachine'],
      UpdateDate: json['UpdateDate'],
    );

Map<String, dynamic> _$DTReportToJson(DTReport instance) => <String, dynamic>{
      'ID': instance.ID,
      'TeamName': instance.TeamName,
      'TeamTEL': instance.TeamTEL,
      'TeamCaptainName': instance.TeamCaptainName,
      'LifesaverQualification': instance.LifesaverQualification,
      'WithLifeSavers': instance.WithLifeSavers,
      'TeamMemberName': instance.TeamMemberName,
      'InstitutionalMemberName': instance.InstitutionalMemberName,
      'Total': instance.Total,
      'Team': instance.Team,
      'SickInjuredPersonName': instance.SickInjuredPersonName,
      'SickInjuredPersonKANA': instance.SickInjuredPersonKANA,
      'SickInjuredPersonAddress': instance.SickInjuredPersonAddress,
      'SickInjuredPersonGender': instance.SickInjuredPersonGender,
      'SickInjuredPersonBirthDate': instance.SickInjuredPersonBirthDate,
      'SickInjuredPersonTEL': instance.SickInjuredPersonTEL,
      'SickInjuredPersonFamilyTEL': instance.SickInjuredPersonFamilyTEL,
      'SickInjuredPersonMedicalHistroy':
          instance.SickInjuredPersonMedicalHistroy,
      'SickInjuredPersonHistoryHospital':
          instance.SickInjuredPersonHistoryHospital,
      'SickInjuredPersonKakaritsuke': instance.SickInjuredPersonKakaritsuke,
      'SickInjuredPersonMedication': instance.SickInjuredPersonMedication,
      'SickInjuredPersonMedicationDetail':
          instance.SickInjuredPersonMedicationDetail,
      'SickInjuredPersonAllergy': instance.SickInjuredPersonAllergy,
      'SickInjuredPersonNameOfInjuaryOrSickness':
          instance.SickInjuredPersonNameOfInjuaryOrSickness,
      'SickInjuredPersonDegree': instance.SickInjuredPersonDegree,
      'SickInjuredPersonAge': instance.SickInjuredPersonAge,
      'SenseTime': instance.SenseTime,
      'CommandTime': instance.CommandTime,
      'AttendanceTime': instance.AttendanceTime,
      'OnsiteArrivalTime': instance.OnsiteArrivalTime,
      'ContactTime': instance.ContactTime,
      'InvehicleTime': instance.InvehicleTime,
      'StartOfTransportTime': instance.StartOfTransportTime,
      'HospitalArrivalTime': instance.HospitalArrivalTime,
      'FamilyContactTime': instance.FamilyContactTime,
      'PoliceContactTime': instance.PoliceContactTime,
      'TimeOfArrival': instance.TimeOfArrival,
      'ReturnTime': instance.ReturnTime,
      'TypeOfAccident': instance.TypeOfAccident,
      'DateOfOccurrence': instance.DateOfOccurrence,
      'TimeOfOccurrence': instance.TimeOfOccurrence,
      'PlaceOfIncident': instance.PlaceOfIncident,
      'AccidentSummary': instance.AccidentSummary,
      'ADL': instance.ADL,
      'TrafficAccidentClassification': instance.TrafficAccidentClassification,
      'Witnesses': instance.Witnesses,
      'BystanderCPR': instance.BystanderCPR,
      'VerbalGuidance': instance.VerbalGuidance,
      'ObservationTime': instance.ObservationTime,
      'DescriptionOfObservationTime': instance.DescriptionOfObservationTime,
      'JCS': instance.JCS,
      'GCS': instance.GCS,
      'Respiration': instance.Respiration,
      'Pulse': instance.Pulse,
      'BloodPressureHigh': instance.BloodPressureHigh,
      'BloodPressureLow': instance.BloodPressureLow,
      'SpO2Percent': instance.SpO2Percent,
      'SpO2Liter': instance.SpO2Liter,
      'PupilRight': instance.PupilRight,
      'PupilLeft': instance.PupilLeft,
      'LightReflexRight': instance.LightReflexRight,
      'PhotoreflexLeft': instance.PhotoreflexLeft,
      'BodyTemperature': instance.BodyTemperature,
      'FacialFeatures': instance.FacialFeatures,
      'Hemorrhage': instance.Hemorrhage,
      'Incontinence': instance.Incontinence,
      'Vomiting': instance.Vomiting,
      'Extremities': instance.Extremities,
      'SecuringAirway': instance.SecuringAirway,
      'ForeignBodyRemoval': instance.ForeignBodyRemoval,
      'Suction': instance.Suction,
      'ArtificialRespiration': instance.ArtificialRespiration,
      'ChestCompressions': instance.ChestCompressions,
      'ECGMonitor': instance.ECGMonitor,
      'O2Administration': instance.O2Administration,
      'O2AdministrationTime': instance.O2AdministrationTime,
      'SpinalCordMovementLimitation': instance.SpinalCordMovementLimitation,
      'HemostaticTreatment': instance.HemostaticTreatment,
      'AdductorFixation': instance.AdductorFixation,
      'Coating': instance.Coating,
      'BurnTreatment': instance.BurnTreatment,
      'BSMeasurement1': instance.BSMeasurement1,
      'BSMeasurementTime1': instance.BSMeasurementTime1,
      'PunctureSite1': instance.PunctureSite1,
      'BSMeasurement2': instance.BSMeasurement2,
      'BSMeasurementTime2': instance.BSMeasurementTime2,
      'PunctureSite2': instance.PunctureSite2,
      'Other': instance.Other,
      'PerceiverName': instance.PerceiverName,
      'TypeOfDetection': instance.TypeOfDetection,
      'CallerName': instance.CallerName,
      'CallerTEL': instance.CallerTEL,
      'MedicalTransportFacility': instance.MedicalTransportFacility,
      'TransferringMedicalInstitution': instance.TransferringMedicalInstitution,
      'TransferSourceReceivingTime': instance.TransferSourceReceivingTime,
      'ReasonForTransfer': instance.ReasonForTransfer,
      'ReasonForNotTransferring': instance.ReasonForNotTransferring,
      'RecordOfRefusalOfTransfer': instance.RecordOfRefusalOfTransfer,
      'Remark': instance.Remark,
      'ReporterName': instance.ReporterName,
      'ReporterPosition': instance.ReporterPosition,
      'EntryName': instance.EntryName,
      'EntryMachine': instance.EntryMachine,
      'EntryDate': instance.EntryDate,
      'UpdateName': instance.UpdateName,
      'UpdateMachine': instance.UpdateMachine,
      'UpdateDate': instance.UpdateDate,
    };
