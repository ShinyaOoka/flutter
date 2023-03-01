import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:sqflite/sqflite.dart';

const _createReportTable = '''CREATE TABLE ${DBConstants.reportTable} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  TeamCD VARCHAR,
  FireStationCD VARCHAR,
  TeamCaptainName VARCHAR(20),
  TeamMemberName VARCHAR(20),
  InstitutionalMemberName VARCHAR(20),
  LifesaverQualification INTEGER,
  WithLifeSavers INTEGER,
  Total INTEGER,
  Team INTEGER,
  SickInjuredPersonName VARCHAR(20),
  SickInjuredPersonKANA VARCHAR(20),
  SickInjuredPersonAddress VARCHAR(60),
  SickInjuredPersonGender VARCHAR(3),
  SickInjuredPersonBirthDate DATE,
  SickInjuredPersonTEL VARCHAR(20),
  SickInjuredPersonFamily VARCHAR(10),
  SickInjuredPersonFamilyTEL VARCHAR(20),
  SickInjuredPersonMedicalHistroy VARCHAR(20),
  SickInjuredPersonHistoryHospital VARCHAR(20),
  SickInjuredPersonKakaritsuke VARCHAR(20),
  SickInjuredPersonMedication VARCHAR(3),
  SickInjuredPersonMedicationDetail VARCHAR(20),
  SickInjuredPersonAllergy VARCHAR(20),
  SickInjuredPersonNameOfInjuryOrSickness VARCHAR(60),
  SickInjuredPersonDegree VARCHAR(60),
  SickInjuredPersonAge INTEGER,
  SenseTime STRING,
  CommandTime STRING,
  AttendanceTime STRING,
  OnSiteArrivalTime STRING,
  ContactTime STRING,
  InVehicleTime STRING,
  StartOfTransportTime STRING,
  HospitalArrivalTime STRING,
  FamilyContactTime STRING,
  PoliceContactTime STRING,
  TimeOfArrival STRING,
  ReturnTime STRING,
  TypeOfAccident VARCHAR(3),
  DateOfOccurrence DATE,
  TimeOfOccurrence STRING,
  PlaceOfIncident VARCHAR(100),
  AccidentSummary VARCHAR(100),	
  ADL VARCHAR(3),
  TrafficAccidentClassification VARCHAR(3),
  Witnesses INTEGER,
  BystanderCPR STRING,
  VerbalGuidance VARCHAR(60),
  ObservationTime STRING,
  JCS VARCHAR,
  GCS_E VARCHAR,
  GCS_V VARCHAR,
  GCS_M VARCHAR,
  Respiration VARCHAR,
  Pulse VARCHAR,
  BloodPressure_High VARCHAR,
  BloodPressure_Low VARCHAR,
  SpO2Percent VARCHAR,
  SpO2Liter VARCHAR,
  PupilRight VARCHAR,
  PupilLeft VARCHAR,
  LightReflexRight VARCHAR,
  LightReflexLeft VARCHAR,
  BodyTemperature VARCHAR,
  FacialFeatures VARCHAR,
  Hemorrhage VARCHAR,
  Incontinence VARCHAR,
  Vomiting VARCHAR,
  Extremities VARCHAR,
  DescriptionOfObservationTime VARCHAR,
  EachECG VARCHAR,
  EachOxygenInhalation VARCHAR,
  EachHemostasis VARCHAR,
  EachSuction VARCHAR,
  OtherProcess1 VARCHAR,
  OtherProcess2 VARCHAR,
  OtherProcess3 VARCHAR,
  OtherProcess4 VARCHAR,
  OtherProcess5 VARCHAR,
  OtherProcess6 VARCHAR,
  OtherProcess7 VARCHAR,
  OtherProcess8 VARCHAR,
  OtherProcess9 VARCHAR,
  OtherOfObservationTime VARCHAR,
  SecuringAirway VARCHAR(3),
  ForeignBodyRemoval INTEGER,
  Suction INTEGER,
  ArtificialRespiration INTEGER,
  ChestCompressions INTEGER,
  ECGMonitor INTEGER,
  O2Administration DECIMAL(4,1),
  O2AdministrationTime STRING,
  SpinalCordMovementLimitation VARCHAR(3),
  HemostaticTreatment INTEGER,
  AdductorFixation INTEGER,
  Coating INTEGER,
  BurnTreatment INTEGER,
  BSMeasurement1 INTEGER,
  BSMeasurementTime1 STRING,
  PunctureSite1 VARCHAR(10),
  BSMeasurement2 INTEGER,
  BSMeasurementTime2 STRING,
  PunctureSite2 VARCHAR(10),
  Other VARCHAR(60),
  PerceiverName VARCHAR(20),
  TypeOfDetection VARCHAR(3),
  CallerName VARCHAR(20),
  CallerTEL VARCHAR(20),
  MedicalTransportFacility VARCHAR(20),
  OtherMedicalTransportFacility VARCHAR(20),
  TransferringMedicalInstitution VARCHAR(20),
  OtherTransferringMedicalInstitution VARCHAR(20),
  TransferSourceReceivingTime STRING,
  ReasonForTransfer VARCHAR(60),
  ReasonForNotTransferring VARCHAR(100),
  RecordOfRefusalOfTransfer INTEGER,
  NameOfReporter VARCHAR(20),
  AffiliationOfReporter	VARCHAR(20),
  PositionOfReporter VARCHAR(20),
  SummaryOfOccurrence VARCHAR(500),
  Remarks VARCHAR(180),
  EntryName VARCHAR(20),
  EntryMachine VARCHAR(20),
  EntryDate DATETIME,
  UpdateName VARCHAR(20),
  UpdateMachine VARCHAR(20),
  UpdateDate DATETIME
)
''';

const _createTeamMemberTable = '''CREATE TABLE ${DBConstants.teamMemberTable} (
  TeamMemberCD VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(20),
  Position VARCHAR(20),
  TEL VARCHAR(20),
  TeamCD VARCHAR(20),
  LifesaverQualification INTEGER	
)
''';

const _createTeamTable = '''CREATE TABLE ${DBConstants.teamTable} (
  TeamCD VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(20),
  TEL VARCHAR(20),
  FireStationCD VARCHAR(20)
)''';

const _createFireStationTable =
    '''CREATE TABLE ${DBConstants.fireStationTable} (
  FireStationCD VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(20),
  Address VARCHAR(60),
  TEL VARCHAR(20)
)''';

const _createHospitalTable = '''CREATE TABLE ${DBConstants.hospitalTable} (
  HospitalCD VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(20),
  Address VARCHAR(60),
  TEL VARCHAR(20)
)''';

const _createClassificationTable =
    '''CREATE TABLE ${DBConstants.classificationTable} (
  ClassificationCD VARCHAR(3),
  ClassificationSubCD VARCHAR(3),
  Value VARCHAR(3),
  Description VARCHAR(100),
  PRIMARY KEY (ClassificationCD, ClassificationSubCD)
)''';

void upgradeVersion1(Batch batch) {
  batch.execute(_createReportTable);
  batch.execute(_createTeamMemberTable);
  batch.execute(_createTeamTable);
  batch.execute(_createFireStationTable);
  batch.execute(_createHospitalTable);
  batch.execute(_createClassificationTable);
}

const _dropReportTable = '''DROP TABLE IF EXISTS ${DBConstants.reportTable}''';
const _dropTeamMemberTable =
    '''DROP TABLE IF EXISTS ${DBConstants.teamMemberTable}''';
const _dropTeamTable = '''DROP TABLE IF EXISTS ${DBConstants.teamTable}''';
const _dropFireStationTable =
    '''DROP TABLE IF EXISTS ${DBConstants.fireStationTable}''';
const _dropHospitalTable =
    '''DROP TABLE IF EXISTS ${DBConstants.hospitalTable}''';
const _dropClassificationTable =
    '''DROP TABLE IF EXISTS ${DBConstants.classificationTable}''';

void downgradeVersion1(Batch batch) {
  batch.execute(_dropReportTable);
  batch.execute(_dropTeamMemberTable);
  batch.execute(_dropTeamTable);
  batch.execute(_dropFireStationTable);
  batch.execute(_dropHospitalTable);
  batch.execute(_dropClassificationTable);
}
