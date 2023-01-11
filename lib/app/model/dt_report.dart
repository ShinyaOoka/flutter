import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dt_report.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DTReport {
  int? ID;
  String? TeamName;
  String? TeamTEL;
  String? FireStationName;
  String? TeamCaptainName;
  int? LifesaverQualification;
  int? WithLifeSavers;
  String? TeamMemberName;
  String? InstitutionalMemberName;
  int? Total;
  int? Team;
  String? SickInjuredPersonName;
  String? SickInjuredPersonKANA;
  String? SickInjuredPersonAddress;
  String? SickInjuredPersonGender;
  String? SickInjuredPersonBirthDate;
  String? SickInjuredPersonTEL;
  String? SickInjuredPersonFamilyTEL;
  String? SickInjuredPersonMedicalHistroy;
  String? SickInjuredPersonHistoryHospital;
  String? SickInjuredPersonKakaritsuke;
  String? SickInjuredPersonMedication;
  String? SickInjuredPersonMedicationDetail;
  String? SickInjuredPersonAllergy;
  String? SickInjuredPersonNameOfInjuaryOrSickness;
  String? SickInjuredPersonDegree;
  int? SickInjuredPersonAge;
  String? SenseTime;
  String? CommandTime;
  String? AttendanceTime;
  String? OnsiteArrivalTime;
  String? ContactTime;
  String? InvehicleTime;
  String? StartOfTransportTime;
  String? HospitalArrivalTime;
  String? FamilyContactTime;
  String? PoliceContactTime;
  String? TimeOfArrival;
  String? ReturnTime;
  String? TypeOfAccident;
  String? DateOfOccurrence;
  String? TimeOfOccurrence;
  String? PlaceOfIncident;
  String? AccidentSummary;
  String? ADL;
  String? TrafficAccidentClassification;
  int? Witnesses;
  String? BystanderCPR;
  String? VerbalGuidance;


  String? ObservationTime;

  String? JCS;

  String? GCSE;

  String? GCSV;

  String? GCSM;

  String? Respiration;

  String? Pulse;

  String? BloodPressureHigh;

  String? BloodPressureLow;

  String? SpO2Percent;

  String? SpO2Liter;

  String? PupilRight;

  String? PupilLeft;

  String? LightReflexRight;

  String? PhotoreflexLeft;

  String? BodyTemperature;

  String? FacialFeatures;

  String? Hemorrhage;

  String? Incontinence;

  String? Vomiting;

  String? Extremities;

  String? DescriptionOfObservationTime;

  String? OtherOfObservationTime;

  String? SecuringAirway;
  int? ForeignBodyRemoval;
  int? Suction;
  int? ArtificialRespiration;
  int? ChestCompressions;
  int? ECGMonitor;
  int? O2Administration;
  String? O2AdministrationTime;
  String? SpinalCordMovementLimitation;
  int? HemostaticTreatment;
  int? AdductorFixation;
  int? Coating;
  int? BurnTreatment;
  int? BSMeasurement1;
  String? BSMeasurementTime1;
  String? PunctureSite1;
  int? BSMeasurement2;
  String? BSMeasurementTime2;
  String? PunctureSite2;
  String? Other;
  String? PerceiverName;
  String? TypeOfDetection;
  String? CallerName;
  String? CallerTEL;
  String? MedicalTransportFacility;
  String? TransferringMedicalInstitution;
  String? TransferSourceReceivingTime;
  String? ReasonForTransfer;
  String? ReasonForNotTransferring;
  int? RecordOfRefusalOfTransfer;
  String? Remark;
  String? EntryName;
  String? EntryMachine;
  String? EntryDate;
  String? UpdateName;
  String? UpdateMachine;
  String? UpdateDate;
  String? ReporterAffiliation;
  String? ReportingClass;
  int? NumberOfDispatches;
  int? NumberOfDispatchesPerTeam;
  String? NameOfReporter;
  String? AffiliationOfReporter;
  String? PositionOfReporter;
  String? SummaryOfOccurrence;





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
    this.EntryName,
    this.EntryMachine,
    this.EntryDate,
    this.UpdateName,
    this.UpdateMachine,
    this.UpdateDate,
    this.ReporterAffiliation,
    this.ReportingClass,
    this.NumberOfDispatches,
    this.NumberOfDispatchesPerTeam,
    this.NameOfReporter,
    this.AffiliationOfReporter,
    this.PositionOfReporter,
    this.SummaryOfOccurrence,
  });


  factory DTReport.fromJson(Map<String, dynamic?> json) =>
      _$DTReportFromJson(json);

  Map<String, dynamic?> toJson() => _$DTReportToJson(this);

}
