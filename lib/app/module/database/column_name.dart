//table DTReport
const String tableDTReport = 'DTReport';

//table MSTeamMember
const String tableMSTeamMember = 'MSTeamMember';

//table MSTeam
const String tableMSTeam = 'MSTeam';

//table MSFireStation
const String tableMSFireStation = 'MSFireStation';

//table MSHospital
const String tableMSHospital = 'MSHospital';

//table MSMessage
const String tableMSMessage = 'MSMessage';

//table MSClassification
const String tableMSClassification = 'MSClassification';



//CREATE TABLE
const String CREATE_TABLE_DTReport = '''CREATE TABLE $tableDTReport (
    $ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $TeamName VARCHAR(20),
    $TeamTEL VARCHAR(20),
    $FireStationName VARCHAR(20),
    $TeamCaptainName VARCHAR(20),
    $LifesaverQualification INTEGER,
    $WithLifeSavers INTEGER,
    $TeamMemberName VARCHAR(20),
    $InstitutionalMemberName VARCHAR(20),
    $Total INTEGER,
    $Team INTEGER,
    $SickInjuredPersonName VARCHAR(20),
    $SickInjuredPersonKANA VARCHAR(20),
    $SickInjuredPersonAddress VARCHAR(60),
    $SickInjuredPersonGender VARCHAR(3),
    $SickInjuredPersonBirthDate DATE,
    $SickInjuredPersonTEL VARCHAR(20),
    $SickInjuredPersonFamilyTEL VARCHAR(20),
    $SickInjuredPersonMedicalHistroy VARCHAR(20),
    $SickInjuredPersonHistoryHospital VARCHAR(20),
    $SickInjuredPersonKakaritsuke VARCHAR(20),
    $SickInjuredPersonMedication VARCHAR(3),
    $SickInjuredPersonMedicationDetail VARCHAR(20),
    $SickInjuredPersonAllergy VARCHAR(20),
    $SickInjuredPersonNameOfInjuaryOrSickness VARCHAR(60),
    $SickInjuredPersonDegree VARCHAR(60),
    $SickInjuredPersonAge INTEGER,
    $SenseTime TIME,
    $CommandTime TIME,
    $AttendanceTime TIME,
    $OnsiteArrivalTime TIME,
    $ContactTime TIME,
    $InvehicleTime TIME,
    $StartOfTransportTime TIME,
    $HospitalArrivalTime TIME,
    $FamilyContactTime TIME,
    $PoliceContactTime TIME,
    $TimeOfArrival TIME,
    $ReturnTime TIME,
    $TypeOfAccident  VARCHAR(3),
    $DateOfOccurrence DATE,
    $TimeOfOccurrence TIME,
    $PlaceOfIncident VARCHAR(100),
    $AccidentSummary VARCHAR(100),
    $ADL VARCHAR(3),
    $TrafficAccidentClassification VARCHAR(3),
    $Witnesses INTEGER,
    $BystanderCPR TIME,
    $VerbalGuidance VARCHAR(60),
    $ObservationTime VARCHAR,
    $JCS VARCHAR,
    $GCSE VARCHAR,
    $GCSV VARCHAR,
    $GCSM VARCHAR,
    $Respiration VARCHAR, 
    $Pulse VARCHAR,
    $BloodPressureHigh VARCHAR,
    $BloodPressureLow VARCHAR,
    $SpO2Percent VARCHAR,
    $SpO2Liter VARCHAR,
    $PupilRight VARCHAR,
    $PupilLeft VARCHAR,
    $LightReflexRight VARCHAR,
    $PhotoreflexLeft VARCHAR,
    $BodyTemperature VARCHAR,
    $FacialFeatures VARCHAR,
    $Hemorrhage VARCHAR,
    $Incontinence VARCHAR,
    $Vomiting VARCHAR,
    $Extremities VARCHAR,
    $DescriptionOfObservationTime VARCHAR,
    $OtherOfObservationTime VARCHAR,
    $SecuringAirway VARCHAR(3),
    $ForeignBodyRemoval INTEGER,
    $Suction INTEGER,
    $ArtificialRespiration INTEGER,
    $ChestCompressions INTEGER,
    $ECGMonitor INTEGER,
    $O2Administration INTEGER,
    $O2AdministrationTime TIME,
    $SpinalCordMovementLimitation VARCHAR(3),
    $HemostaticTreatment INTEGER,
    $AdductorFixation INTEGER,
    $Coating INTEGER,
    $BurnTreatment INTEGER,
    $BSMeasurement1 INTEGER,
    $BSMeasurementTime1 TIME,
    $PunctureSite1 VARCHAR(10),
    $BSMeasurement2 INTEGER,
    $BSMeasurementTime2 TIME,
    $PunctureSite2 VARCHAR(10),
    $Other VARCHAR(60),
    $PerceiverName VARCHAR(20),
    $TypeOfDetection VARCHAR(3),
    $CallerName  VARCHAR(20),
    $CallerTEL  VARCHAR(20),
    $MedicalTransportFacility VARCHAR(20),
    $TransferringMedicalInstitution VARCHAR(20),
    $TransferSourceReceivingTime TIME,
    $ReasonForTransfer VARCHAR(60),
    $ReasonForNotTransferring VARCHAR(100),
    $RecordOfRefusalOfTransfer INTEGER,
    $Remark VARCHAR(180),
    $EntryName VARCHAR(20),
    $EntryMachine VARCHAR(20),
    $EntryDate DATETIME,
    $UpdateName VARCHAR(20),
    $UpdateMachine VARCHAR(20),
    $UpdateDate DATETIME,
    $ReporterAffiliation VARCHAR,
    $ReportingClass VARCHAR,
    $NumberOfDispatches INTEGER(8),
    $NumberOfDispatchesPerTeam INTEGER(8),
    $NameOfReporter VARCHAR(20),
    $AffiliationOfReporter VARCHAR(20),
    $PositionOfReporter VARCHAR(20),
    $SummaryOfOccurrence VARCHAR(500)
      );''';


const String CREATE_TABLE_MSTeamMember = '''CREATE TABLE $tableMSTeamMember(
    $TeamMemberCD VARCHAR,
    $Name VARCHAR,
    $Position VARCHAR,
    $TEL VARCHAR,
    $TeamCD VARCHAR,
    $LifesaverQualification INTEGER
      );''';

const String CREATE_TABLE_MSTeam = '''CREATE TABLE $tableMSTeam (
    $TeamCD VARCHAR(20),
    $Name VARCHAR(20),
    $TEL VARCHAR(20),
    $FireStationCD VARCHAR(20)
      );''';

const String CREATE_TABLE_MSFireStation = '''CREATE TABLE $tableMSFireStation (
    $FireStationCD VARCHAR(20),
    $Name VARCHAR(20),
    $Address VARCHAR(60),
    $TEL VARCHAR(20)
      );''';

const String CREATE_TABLE_MSHospital = '''CREATE TABLE $tableMSHospital (
    $HospitalCD VARCHAR(20),
    $Name VARCHAR(20),
    $Address VARCHAR(60),
    $TEL VARCHAR(20)
      );''';

const String CREATE_TABLE_MSMessage = '''CREATE TABLE $tableMSMessage (
    $CD VARCHAR,
    $MessageType VARCHAR,
    $MessageContent VARCHAR,
    $Button VARCHAR,
    $Purpose VARCHAR
      );''';

const String CREATE_TABLE_MSClassification = '''CREATE TABLE $tableMSClassification (
    $ClassificationCD VARCHAR(3),
    $ClassificationSubCD VARCHAR(3),
    $Value VARCHAR(3),
    $Description VARCHAR(100)
      );''';


//Upgrade
//drop table DTReport
const String DROP_TABLE_DTReport = '''DROP TABLE IF EXISTS $tableDTReport;''';
const String DROP_TABLE_MSClassification = '''DROP TABLE IF EXISTS $tableMSClassification;''';
const String DROP_TABLE_MSMessage = '''DROP TABLE IF EXISTS $tableMSMessage;''';
const String DROP_TABLE_MSTeamMember = '''DROP TABLE IF EXISTS $tableMSTeamMember;''';
const String DROP_TABLE_MSTeam = '''DROP TABLE IF EXISTS $tableMSTeam;''';


//DT Report Table
const String? ID = 'ID';
const String TeamName = 'TeamName';
const String TeamTEL = 'TeamTEL';
const String FireStationName = 'FireStationName';
const String TeamCaptainName = 'TeamCaptainName';
const String LifesaverQualification = 'LifesaverQualification';
const String WithLifeSavers = 'WithLifeSavers';
const String TeamMemberName = 'TeamMemberName';
const String InstitutionalMemberName = 'InstitutionalMemberName';
const String Total = 'Total';
const String Team = 'Team';
const String SickInjuredPersonName = 'SickInjuredPersonName';
const String SickInjuredPersonKANA = 'SickInjuredPersonKANA';
const String SickInjuredPersonAddress = 'SickInjuredPersonAddress';
const String SickInjuredPersonGender = 'SickInjuredPersonGender';
const String SickInjuredPersonBirthDate = 'SickInjuredPersonBirthDate';
const String SickInjuredPersonTEL = 'SickInjuredPersonTEL';
const String SickInjuredPersonFamilyTEL = 'SickInjuredPersonFamilyTEL';
const String SickInjuredPersonMedicalHistroy =
    'SickInjuredPersonMedicalHistroy';
const String SickInjuredPersonHistoryHospital =
    'SickInjuredPersonHistoryHospital';
const String SickInjuredPersonKakaritsuke = 'SickInjuredPersonKakaritsuke';
const String SickInjuredPersonMedication = 'SickInjuredPersonMedication';
const String SickInjuredPersonMedicationDetail =
    'SickInjuredPersonMedicationDetail';
const String SickInjuredPersonAllergy = 'SickInjuredPersonAllergy';
const String SickInjuredPersonNameOfInjuaryOrSickness =
    'SickInjuredPersonNameOfInjuaryOrSickness';
const String SickInjuredPersonDegree = 'SickInjuredPersonDegree';
const String SickInjuredPersonAge = 'SickInjuredPersonAge';
const String SenseTime = 'SenseTime';
const String CommandTime = 'CommandTime';
const String AttendanceTime = 'AttendanceTime';
const String OnsiteArrivalTime = 'OnsiteArrivalTime';
const String ContactTime = 'ContactTime';
const String InvehicleTime = 'InvehicleTime';
const String StartOfTransportTime = 'StartOfTransportTime';
const String HospitalArrivalTime = 'HospitalArrivalTime';
const String FamilyContactTime = 'FamilyContactTime';
const String PoliceContactTime = 'PoliceContactTime';
const String TimeOfArrival = 'TimeOfArrival';
const String ReturnTime = 'ReturnTime';
const String TypeOfAccident = 'TypeOfAccident';
const String DateOfOccurrence = 'DateOfOccurrence';
const String TimeOfOccurrence = 'TimeOfOccurrence';
const String PlaceOfIncident = 'PlaceOfIncident';
const String AccidentSummary = 'AccidentSummary';
const String ADL = 'ADL';
const String TrafficAccidentClassification = 'TrafficAccidentClassification';
const String Witnesses = 'Witnesses';
const String BystanderCPR = 'BystanderCPR';
const String VerbalGuidance = 'VerbalGuidance';
const String ObservationTime = 'ObservationTime';
const String DescriptionOfObservationTime = 'DescriptionOfObservationTime';
const String OtherOfObservationTime = 'OtherOfObservationTime';
const String JCS = 'JCS';
const String GCSE = 'GCSE';
const String GCSV = 'GCSV';
const String GCSM = 'GCSM';
const String Respiration = 'Respiration';
const String Pulse = 'Pulse';
const String BloodPressureHigh = 'BloodPressureHigh';
const String BloodPressureLow = 'BloodPressureLow';
const String SpO2Percent = 'SpO2Percent';
const String SpO2Liter = 'SpO2Liter';
const String PupilRight = 'PupilRight';
const String PupilLeft = 'PupilLeft';
const String LightReflexRight = 'LightReflexRight';
const String PhotoreflexLeft = 'PhotoreflexLeft';
const String BodyTemperature = 'BodyTemperature';
const String FacialFeatures = 'FacialFeatures';
const String Hemorrhage = 'Hemorrhage';
const String Incontinence = 'Incontinence';
const String Vomiting = 'Vomiting';
const String Extremities = 'Extremities';
const String SecuringAirway = 'SecuringAirway';
const String ForeignBodyRemoval = 'ForeignBodyRemoval';
const String Suction = 'Suction';
const String ArtificialRespiration = 'ArtificialRespiration';
const String ChestCompressions = 'ChestCompressions';
const String ECGMonitor = 'ECGMonitor';
const String O2Administration = 'O2Administration';
const String O2AdministrationTime = 'O2AdministrationTime';
const String SpinalCordMovementLimitation = 'SpinalCordMovementLimitation';
const String HemostaticTreatment = 'HemostaticTreatment';
const String AdductorFixation = 'AdductorFixation';
const String Coating = 'Coating';
const String BurnTreatment = 'BurnTreatment';
const String BSMeasurement1 = 'BSMeasurement1';
const String BSMeasurementTime1 = 'BSMeasurementTime1';
const String PunctureSite1 = 'PunctureSite1';
const String BSMeasurement2 = 'BSMeasurement2';
const String BSMeasurementTime2 = 'BSMeasurementTime2';
const String PunctureSite2 = 'PunctureSite2';
const String Other = 'Other';
const String PerceiverName = 'PerceiverName';
const String TypeOfDetection = 'TypeOfDetection';
const String CallerName = 'CallerName';
const String CallerTEL = 'CallerTEL';
const String MedicalTransportFacility = 'MedicalTransportFacility';
const String TransferringMedicalInstitution = 'TransferringMedicalInstitution';
const String TransferSourceReceivingTime = 'TransferSourceReceivingTime';
const String ReasonForTransfer = 'ReasonForTransfer';
const String ReasonForNotTransferring = 'ReasonForNotTransferring';
const String RecordOfRefusalOfTransfer = 'RecordOfRefusalOfTransfer';
const String Remark = 'Remark';
const String AffiliationOfReporter = 'AffiliationOfReporter';
const String EntryName = 'EntryName';
const String EntryMachine = 'EntryMachine';
const String EntryDate = 'EntryDate';
const String UpdateName = 'UpdateName';
const String UpdateMachine = 'UpdateMachine';
const String UpdateDate = 'UpdateDate';
const String ReporterAffiliation = 'ReporterAffiliation';
const String ReportingClass = 'ReportingClass';

const String NumberOfDispatches = "NumberOfDispatches";
const String NumberOfDispatchesPerTeam = "NumberOfDispatchesPerTeam";
const String PositionOfReporter = 'PositionOfReporter';
const String NameOfReporter = "NameOfReporter";
const String SummaryOfOccurrence = "SummaryOfOccurrence";


//MSTeam Table
const String TeamCD = 'TeamCD';
const String Name = 'Name';
const String TEL = 'TEL';

//MSTeamMember Table
const String TeamMemberCD = 'TeamMemberCD';
//const String Name = 'Name';
const String Position = 'Position';
//const String TEL = 'TEL';
//const String TeamCD = 'TeamCD';

//MSClassification Table
const String ClassificationCD = 'ClassificationCD';
const String ClassificationSubCD = 'ClassificationSubCD';
const String Value = 'Value';
const String Description = 'Description';

//MSFireStation Table
const String FireStationCD = 'FireStationCD';
//const String Name = 'Name';
const String Address = 'Address';
//const String TEL = 'TEL';

//MSHospital Table
const String HospitalCD = 'HospitalCD';
//const String Name = 'Name';
//const String Address = 'Address';
//const String TEL = 'TEL';


//MSMessage table
const String CD = 'CD';
const String MessageType = 'MessageType';
const String MessageContent = 'MessageContent';
const String Button = 'Button';
const String Purpose = 'Purpose';