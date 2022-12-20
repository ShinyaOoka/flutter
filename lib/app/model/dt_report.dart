import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dt_report.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DTReport extends Equatable {
  dynamic? ID;
  dynamic TeamName;
  dynamic TeamTEL;
  dynamic TeamCaptainName;
  dynamic LifesaverQualification;
  dynamic WithLifeSavers;
  dynamic TeamMemberName;
  dynamic InstitutionalMemberName;
  dynamic Total;
  dynamic Team;
  dynamic SickInjuredPersonName;
  dynamic SickInjuredPersonKANA;
  dynamic SickInjuredPersonAddress;
  dynamic SickInjuredPersonGender;
  dynamic SickInjuredPersonBirthDate;
  dynamic SickInjuredPersonTEL;
  dynamic SickInjuredPersonFamilyTEL;
  dynamic SickInjuredPersonMedicalHistroy;
  dynamic SickInjuredPersonHistoryHospital;
  dynamic SickInjuredPersonKakaritsuke;
  dynamic SickInjuredPersonMedication;
  dynamic SickInjuredPersonMedicationDetail;
  dynamic SickInjuredPersonAllergy;
  dynamic SickInjuredPersonNameOfInjuaryOrSickness;
  dynamic SickInjuredPersonDegree;
  dynamic SickInjuredPersonAge;
  dynamic SenseTime;
  dynamic CommandTime;
  dynamic AttendanceTime;
  dynamic OnsiteArrivalTime;
  dynamic ContactTime;
  dynamic InvehicleTime;
  dynamic StartOfTransportTime;
  dynamic HospitalArrivalTime;
  dynamic FamilyContactTime;
  dynamic PoliceContactTime;
  dynamic TimeOfArrival;
  dynamic ReturnTime;
  dynamic TypeOfAccident;
  dynamic DateOfOccurrence;
  dynamic TimeOfOccurrence;
  dynamic PlaceOfIncident;
  dynamic AccidentSummary;
  dynamic ADL;
  dynamic TrafficAccidentClassification;
  dynamic Witnesses;
  dynamic BystanderCPR;
  dynamic VerbalGuidance;
  dynamic ObservationTime;
  dynamic DescriptionOfObservationTime;
  dynamic JCS;
  dynamic GCS;
  dynamic Respiration;
  dynamic Pulse;
  dynamic BloodPressureHigh;
  dynamic BloodPressureLow;
  dynamic SpO2Percent;
  dynamic SpO2Liter;
  dynamic PupilRight;
  dynamic PupilLeft;
  dynamic LightReflexRight;
  dynamic PhotoreflexLeft;
  dynamic BodyTemperature;
  dynamic FacialFeatures;
  dynamic Hemorrhage;
  dynamic Incontinence;
  dynamic Vomiting;
  dynamic Extremities;
  dynamic SecuringAirway;
  dynamic ForeignBodyRemoval;
  dynamic Suction;
  dynamic ArtificialRespiration;
  dynamic ChestCompressions;
  dynamic ECGMonitor;
  dynamic O2Administration;
  dynamic O2AdministrationTime;
  dynamic SpinalCordMovementLimitation;
  dynamic HemostaticTreatment;
  dynamic AdductorFixation;
  dynamic Coating;
  dynamic BurnTreatment;
  dynamic BSMeasurement1;
  dynamic BSMeasurementTime1;
  dynamic PunctureSite1;
  dynamic BSMeasurement2;
  dynamic BSMeasurementTime2;
  dynamic PunctureSite2;
  dynamic Other;
  dynamic PerceiverName;
  dynamic TypeOfDetection;
  dynamic CallerName;
  dynamic CallerTEL;
  dynamic MedicalTransportFacility;
  dynamic TransferringMedicalInstitution;
  dynamic TransferSourceReceivingTime;
  dynamic ReasonForTransfer;
  dynamic ReasonForNotTransferring;
  dynamic RecordOfRefusalOfTransfer;
  dynamic Remark;
  dynamic ReporterName;
  dynamic ReporterPosition;
  dynamic EntryName;
  dynamic EntryMachine;
  dynamic EntryDate;
  dynamic UpdateName;
  dynamic UpdateMachine;
  dynamic UpdateDate;

  MSClassification? msClassification;

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
    this.DescriptionOfObservationTime,
    this.JCS,
    this.GCS,
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
    this.msClassification,
  });

  factory DTReport.fromJson(Map<String, dynamic> json) =>
      _$DTReportFromJson(json);

  Map<String, dynamic> toJson() => _$DTReportToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
    ID,
    TeamName,
    TeamTEL,
    TeamCaptainName,
    LifesaverQualification,
    WithLifeSavers,
    TeamMemberName,
    InstitutionalMemberName,
    Total,
    Team,
    SickInjuredPersonName,
    SickInjuredPersonKANA,
    SickInjuredPersonAddress,
    SickInjuredPersonGender,
    SickInjuredPersonBirthDate,
    SickInjuredPersonTEL,
    SickInjuredPersonFamilyTEL,
    SickInjuredPersonMedicalHistroy,
    SickInjuredPersonHistoryHospital,
    SickInjuredPersonKakaritsuke,
    SickInjuredPersonMedication,
    SickInjuredPersonMedicationDetail,
    SickInjuredPersonAllergy,
    SickInjuredPersonNameOfInjuaryOrSickness,
    SickInjuredPersonDegree,
    SickInjuredPersonAge,
    SenseTime,
    CommandTime,
    AttendanceTime,
    OnsiteArrivalTime,
    ContactTime,
    InvehicleTime,
    StartOfTransportTime,
    HospitalArrivalTime,
    FamilyContactTime,
    PoliceContactTime,
    TimeOfArrival,
    ReturnTime,
    TypeOfAccident,
    DateOfOccurrence,
    TimeOfOccurrence,
    PlaceOfIncident,
    AccidentSummary,
    ADL,
    TrafficAccidentClassification,
    Witnesses,
    BystanderCPR,
    VerbalGuidance,
    ObservationTime,
    DescriptionOfObservationTime,
    JCS,
    GCS,
    Respiration,
    Pulse,
    BloodPressureHigh,
    BloodPressureLow,
    SpO2Percent,
    SpO2Liter,
    PupilRight,
    PupilLeft,
    LightReflexRight,
    PhotoreflexLeft,
    BodyTemperature,
    FacialFeatures,
    Hemorrhage,
    Incontinence,
    Vomiting,
    Extremities,
    SecuringAirway,
    ForeignBodyRemoval,
    Suction,
    ArtificialRespiration,
    ChestCompressions,
    ECGMonitor,
    O2Administration,
    O2AdministrationTime,
    SpinalCordMovementLimitation,
    HemostaticTreatment,
    AdductorFixation,
    Coating,
    BurnTreatment,
    BSMeasurement1,
    BSMeasurementTime1,
    PunctureSite1,
    BSMeasurement2,
    BSMeasurementTime2,
    PunctureSite2,
    Other,
    PerceiverName,
    TypeOfDetection,
    CallerName,
    CallerTEL,
    MedicalTransportFacility,
    TransferringMedicalInstitution,
    TransferSourceReceivingTime,
    ReasonForTransfer,
    ReasonForNotTransferring,
    RecordOfRefusalOfTransfer,
    Remark,
    ReporterName,
    ReporterPosition,
    EntryName,
    EntryMachine,
    EntryDate,
    UpdateName,
    UpdateMachine,
    UpdateDate,
      ];
}
