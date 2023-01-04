import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dt_report.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DTReport {
  dynamic? ID;
  dynamic? TeamName;
  dynamic? TeamTEL;
  dynamic? TeamCaptainName;
  dynamic? LifesaverQualification;
  dynamic? WithLifeSavers;
  dynamic? TeamMemberName;
  dynamic? InstitutionalMemberName;
  dynamic? Total;
  dynamic? Team;
  dynamic? SickInjuredPersonName;
  dynamic? SickInjuredPersonKANA;
  dynamic? SickInjuredPersonAddress;
  dynamic? SickInjuredPersonGender;
  dynamic? SickInjuredPersonBirthDate;
  dynamic? SickInjuredPersonTEL;
  dynamic? SickInjuredPersonFamilyTEL;
  dynamic? SickInjuredPersonMedicalHistroy;
  dynamic? SickInjuredPersonHistoryHospital;
  dynamic? SickInjuredPersonKakaritsuke;
  dynamic? SickInjuredPersonMedication;
  dynamic? SickInjuredPersonMedicationDetail;
  dynamic? SickInjuredPersonAllergy;
  dynamic? SickInjuredPersonNameOfInjuaryOrSickness;
  dynamic? SickInjuredPersonDegree;
  dynamic? SickInjuredPersonAge;
  dynamic? SenseTime;
  dynamic? CommandTime;
  dynamic? AttendanceTime;
  dynamic? OnsiteArrivalTime;
  dynamic? ContactTime;
  dynamic? InvehicleTime;
  dynamic? StartOfTransportTime;
  dynamic? HospitalArrivalTime;
  dynamic? FamilyContactTime;
  dynamic? PoliceContactTime;
  dynamic? TimeOfArrival;
  dynamic? ReturnTime;
  dynamic? TypeOfAccident;
  dynamic? DateOfOccurrence;
  dynamic? TimeOfOccurrence;
  dynamic? PlaceOfIncident;
  dynamic? AccidentSummary;
  dynamic? ADL;
  dynamic? TrafficAccidentClassification;
  dynamic? Witnesses;
  dynamic? BystanderCPR;
  dynamic? VerbalGuidance;
  @JsonKey(defaultValue: [])
  List<String>? ObservationTime;
  @JsonKey(defaultValue: [])
  List<String>? JCS;
  @JsonKey(defaultValue: [])
  List<String>? GCSE;
  @JsonKey(defaultValue: [])
  List<String>? GCSV;
  @JsonKey(defaultValue: [])
  List<String>? GCSM;
  @JsonKey(defaultValue: [])
  List<int>? Respiration;
  @JsonKey(defaultValue: [])
  List<int>? Pulse;
  @JsonKey(defaultValue: [])
  List<int>? BloodPressureHigh;
  @JsonKey(defaultValue: [])
  List<int>? BloodPressureLow;
  @JsonKey(defaultValue: [])
  List<int>? SpO2Percent;
  @JsonKey(defaultValue: [])
  List<int>? SpO2Liter;
  @JsonKey(defaultValue: [])
  List<int>? PupilRight;
  @JsonKey(defaultValue: [])
  List<int>? PupilLeft;
  @JsonKey(defaultValue: [])
  List<int>? LightReflexRight;
  @JsonKey(defaultValue: [])
  List<int>? PhotoreflexLeft;
  @JsonKey(defaultValue: [])
  List<int>? BodyTemperature;
  @JsonKey(defaultValue: [])
  List<String>? FacialFeatures;
  @JsonKey(defaultValue: [])
  List<String>? Hemorrhage;
  @JsonKey(defaultValue: [])
  List<String>? Incontinence;
  @JsonKey(defaultValue: [])
  List<int>? Vomiting;
  @JsonKey(defaultValue: [])
  List<String>? Extremities;
  @JsonKey(defaultValue: [])
  List<String>? DescriptionOfObservationTime;
  dynamic? SecuringAirway;
  dynamic? ForeignBodyRemoval;
  dynamic? Suction;
  dynamic? ArtificialRespiration;
  dynamic? ChestCompressions;
  dynamic? ECGMonitor;
  dynamic? O2Administration;
  dynamic? O2AdministrationTime;
  dynamic? SpinalCordMovementLimitation;
  dynamic? HemostaticTreatment;
  dynamic? AdductorFixation;
  dynamic? Coating;
  dynamic? BurnTreatment;
  dynamic? BSMeasurement1;
  dynamic? BSMeasurementTime1;
  dynamic? PunctureSite1;
  dynamic? BSMeasurement2;
  dynamic? BSMeasurementTime2;
  dynamic? PunctureSite2;
  dynamic? Other;
  dynamic? PerceiverName;
  dynamic? TypeOfDetection;
  dynamic? CallerName;
  dynamic? CallerTEL;
  dynamic? MedicalTransportFacility;
  dynamic? TransferringMedicalInstitution;
  dynamic? TransferSourceReceivingTime;
  dynamic? ReasonForTransfer;
  dynamic? ReasonForNotTransferring;
  dynamic? RecordOfRefusalOfTransfer;
  dynamic? Remark;
  dynamic? ReporterName;
  dynamic? ReporterPosition;
  dynamic? EntryName;
  dynamic? EntryMachine;
  dynamic? EntryDate;
  dynamic? UpdateName;
  dynamic? UpdateMachine;
  dynamic? UpdateDate;
  dynamic? ReporterAffiliation;
  dynamic? ReportingClass;





  DTReport({
    this.ID,
    this.TeamName,
    this.TeamTEL,
    this.TeamCaptainName,
    this.LifesaverQualification,
    this.WithLifeSavers,
    this.TeamMemberName,
    this.InstitutionalMemberName,
    this.Total,
    this.Team,
    this.SickInjuredPersonName,
    this.SickInjuredPersonKANA,
    this.SickInjuredPersonAddress,
    this.SickInjuredPersonGender,
    this.SickInjuredPersonBirthDate,
    this.SickInjuredPersonTEL,
    this.SickInjuredPersonFamilyTEL,
    this.SickInjuredPersonMedicalHistroy,
    this.SickInjuredPersonHistoryHospital,
    this.SickInjuredPersonKakaritsuke,
    this.SickInjuredPersonMedication,
    this.SickInjuredPersonMedicationDetail,
    this.SickInjuredPersonAllergy,
    this.SickInjuredPersonNameOfInjuaryOrSickness,
    this.SickInjuredPersonDegree,
    this.SickInjuredPersonAge,
    this.SenseTime,
    this.CommandTime,
    this.AttendanceTime,
    this.OnsiteArrivalTime,
    this.ContactTime,
    this.InvehicleTime,
    this.StartOfTransportTime,
    this.HospitalArrivalTime,
    this.FamilyContactTime,
    this.PoliceContactTime,
    this.TimeOfArrival,
    this.ReturnTime,
    this.TypeOfAccident,
    this.DateOfOccurrence,
    this.TimeOfOccurrence,
    this.PlaceOfIncident,
    this.AccidentSummary,
    this.ADL,
    this.TrafficAccidentClassification,
    this.Witnesses,
    this.BystanderCPR,
    this.VerbalGuidance,

    this.ObservationTime,
    this.JCS,
    this.GCSE,
    this.GCSV,
    this.GCSM,
    this.Respiration,
    this.Pulse,
    this.BloodPressureHigh,
    this.BloodPressureLow,
    this.SpO2Percent,
    this.SpO2Liter,
    this.PupilRight,
    this.PupilLeft,
    this.LightReflexRight,
    this.PhotoreflexLeft,
    this.BodyTemperature,
    this.FacialFeatures,
    this.Hemorrhage,
    this.Incontinence,
    this.Vomiting,
    this.Extremities,
    this.DescriptionOfObservationTime,

    this.SecuringAirway,
    this.ForeignBodyRemoval,
    this.Suction,
    this.ArtificialRespiration,
    this.ChestCompressions,
    this.ECGMonitor,
    this.O2Administration,
    this.O2AdministrationTime,
    this.SpinalCordMovementLimitation,
    this.HemostaticTreatment,
    this.AdductorFixation,
    this.Coating,
    this.BurnTreatment,
    this.BSMeasurement1,
    this.BSMeasurementTime1,
    this.PunctureSite1,
    this.BSMeasurement2,
    this.BSMeasurementTime2,
    this.PunctureSite2,
    this.Other,
    this.PerceiverName,
    this.TypeOfDetection,
    this.CallerName,
    this.CallerTEL,
    this.MedicalTransportFacility,
    this.TransferringMedicalInstitution,
    this.TransferSourceReceivingTime,
    this.ReasonForTransfer,
    this.ReasonForNotTransferring,
    this.RecordOfRefusalOfTransfer,
    this.Remark,
    this.ReporterName,
    this.ReporterPosition,
    this.EntryName,
    this.EntryMachine,
    this.EntryDate,
    this.UpdateName,
    this.UpdateMachine,
    this.UpdateDate,
    this.ReporterAffiliation,
    this.ReportingClass,
  });

  factory DTReport.fromJson(Map<String, dynamic?> json) =>
      _$DTReportFromJson(json);

  Map<String, dynamic?> toJson() => _$DTReportToJson(this);

}
