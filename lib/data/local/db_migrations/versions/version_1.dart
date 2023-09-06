import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:sqflite/sqflite.dart';

const _createReportTable = '''CREATE TABLE ${DBConstants.reportTable} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  TeamCD VARCHAR,
  FireStationCD VARCHAR,
  TeamCaptainName VARCHAR(20),
  TeamAbbreviation VARCHAR(20),
  SickInjuredPersonName VARCHAR(20),
  SickInjuredPersonKANA VARCHAR(20),
  SickInjuredPersonAddress VARCHAR(60),
  SickInjuredPersonGender VARCHAR(3),
  SickInjuredPersonBirthDate DATE,
  SickInjuredPersonTEL VARCHAR(20),
  SickInjuredPersonMedicalHistroy VARCHAR(20),
  SickInjuredPersonHistoryHospital VARCHAR(20),
  SickInjuredPersonAge INTEGER,
  SenseTime STRING,
  OnSiteArrivalTime STRING,
  ContactTime STRING,
  InVehicleTime STRING,
  StartOfTransportTime STRING,
  HospitalArrivalTime STRING,
  FamilyContact INTEGER,
  TypeOfAccident VARCHAR(3),
  DateOfOccurrence DATE,
  TimeOfOccurrence STRING,
  PlaceOfIncident VARCHAR(100),
  AccidentSummary VARCHAR(100),	
  ObservationTime STRING,
  JCS VARCHAR,
  Respiration VARCHAR,
  Pulse VARCHAR,
  BloodPressure_High VARCHAR,
  BloodPressure_Low VARCHAR,
  SpO2Percent VARCHAR,
  PupilRight VARCHAR,
  PupilLeft VARCHAR,
  BodyTemperature VARCHAR,
  FacialFeatures_Anguish VARCHAR,
  OtherProcess8 VARCHAR,
  OtherProcess9 VARCHAR,
  OtherOfObservationTime VARCHAR,
  EntryName VARCHAR(20),
  EntryMachine VARCHAR(20),
  EntryDate DATETIME,
  UpdateName VARCHAR(20),
  UpdateMachine VARCHAR(20),
  UpdateDate DATETIME
)
''';

const _createTeamTable = '''CREATE TABLE ${DBConstants.teamTable} (
  TeamCD VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(20),
  Abbreviation VARCHAR(20),
  TEL VARCHAR(20),
  FireStationCD VARCHAR(20),
  Alias VARCHAR
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
  TEL VARCHAR(20),
  EmergencyMedicineLevel INTEGER
)''';

const _createClassificationTable =
    '''CREATE TABLE ${DBConstants.classificationTable} (
  ClassificationCD VARCHAR(3),
  ClassificationSubCD VARCHAR(3),
  Value VARCHAR(3),
  Description VARCHAR(100),
  PRIMARY KEY (ClassificationCD, ClassificationSubCD)
)''';

const _createDownloadedCaseTable =
    '''CREATE TABLE ${DBConstants.downloadedCaseTable} (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  DeviceID VARCHAR(255),
  CaseID VARCHAR(255),
  CaseStartDate DATETIME,
  CaseEndDate DATETIME,
  Filename VARCHAR(255),
  EntryName VARCHAR(20),
  EntryMachine VARCHAR(20),
  EntryDate DATETIME,
  UpdateName VARCHAR(20),
  UpdateMachine VARCHAR(20),
  UpdateDate DATETIME
)''';

void upgradeVersion1(Batch batch) {
  batch.execute(_createReportTable);
  batch.execute(_createTeamTable);
  batch.execute(_createFireStationTable);
  batch.execute(_createHospitalTable);
  batch.execute(_createClassificationTable);
  batch.execute(_createDownloadedCaseTable);
}

const _dropReportTable = '''DROP TABLE IF EXISTS ${DBConstants.reportTable}''';
const _dropTeamTable = '''DROP TABLE IF EXISTS ${DBConstants.teamTable}''';
const _dropFireStationTable =
    '''DROP TABLE IF EXISTS ${DBConstants.fireStationTable}''';
const _dropHospitalTable =
    '''DROP TABLE IF EXISTS ${DBConstants.hospitalTable}''';
const _dropClassificationTable =
    '''DROP TABLE IF EXISTS ${DBConstants.classificationTable}''';
const _dropDownloadedCaseTable =
    '''DROP TABLE IF EXISTS ${DBConstants.downloadedCaseTable}''';

void downgradeVersion1(Batch batch) {
  batch.execute(_dropReportTable);
  batch.execute(_dropTeamTable);
  batch.execute(_dropFireStationTable);
  batch.execute(_dropHospitalTable);
  batch.execute(_dropClassificationTable);
  batch.execute(_dropDownloadedCaseTable);
}
