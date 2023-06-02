import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:intl/intl.dart';

class StdHdr {
  late int elapsedTime;
  late int msecTime;
  late int recId;
  late DateTime devDateTime;
  late String guid;

  StdHdr._();

  static StdHdr parse(dynamic json) {
    final result = StdHdr._();
    result.elapsedTime = json['ElapsedTime'];
    result.msecTime = json['MsecTime'];
    result.recId = json['RecId'];
    result.devDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').parse(json['DevDateTime']).toLocal();
    result.guid = json['GUID'];
    return result;
  }
}

enum Gender {
  male,
  female,
  unknown,
}

class PatientInfo {
  late String patientId;
  late int age;
  late String firstName;
  late String middleName;
  late String lastName;
  late Gender sex;

  PatientInfo._();

  static PatientInfo parse(dynamic json) {
    final result = PatientInfo._();
    final patientData = json['PatientData'];
    result.age = patientData['Age'];
    result.firstName = patientData['FirstName'] ?? '';
    result.middleName = patientData['MiddleName'] ?? '';
    result.lastName = patientData['LastName'] ?? '';
    result.sex = _parseGender(json['Gender']);
    result.patientId = patientData['PatientId'];
    return result;
  }

  static Gender _parseGender(dynamic json) {
    switch (json) {
      case 1:
        return Gender.male;
      case 2:
        return Gender.female;
      default:
        return Gender.unknown;
    }
  }
}

class DeviceConfiguration {
  late String serialNumber;
  late String unitId;
  late String softwareVersion;

  DeviceConfiguration._();

  static DeviceConfiguration parse(dynamic json) {
    final result = DeviceConfiguration._();
    result.serialNumber = json['DeviceSerialNumber'];
    result.unitId = json['UnitId'];
    result.softwareVersion = json['SoftwareVersions']['PpSwVer'];
    return result;
  }
}

enum HeartRateSource {
  unspecified,
  ecg,
  ibp1,
  spo2,
  ibp2,
  ibp3,
  nibp,
}

class HeartRate {
  late TrendData trendData;
  late HeartRateSource source;

  HeartRate._();

  static HeartRate parse(dynamic json) {
    final result = HeartRate._();
    result.trendData = TrendData.parse(json);
    result.source = _parseHeartRateSource(json['SrcLabel']);
    return result;
  }

  static HeartRateSource _parseHeartRateSource(dynamic json) {
    switch (json) {
      case 1:
        return HeartRateSource.ecg;
      case 2:
        return HeartRateSource.ibp1;
      case 3:
        return HeartRateSource.spo2;
      case 4:
        return HeartRateSource.ibp2;
      case 5:
        return HeartRateSource.ibp3;
      case 6:
        return HeartRateSource.nibp;
      default:
        return HeartRateSource.unspecified;
    }
  }
}

enum RespirationSource {
  co2,
  impedanceRespiration,
  unspecified,
}

class RespirationRate {
  late TrendData trendData;
  late RespirationSource source;

  RespirationRate._();

  static RespirationRate parse(dynamic json) {
    final result = RespirationRate._();
    result.trendData = TrendData.parse(json);
    result.source = _parseRespirationRateSource(json['SrcLabel']);
    return result;
  }

  static RespirationSource _parseRespirationRateSource(dynamic json) {
    switch (json) {
      case 0:
        return RespirationSource.co2;
      case 1:
        return RespirationSource.impedanceRespiration;
      default:
        return RespirationSource.unspecified;
    }
  }
}

enum TemperatureSource {
  na,
  unspecified,
  none,
  art,
  core,
  cereb,
  rect,
  skin,
}

class Temperature {
  late TrendData trendData;
  late TemperatureSource source;

  Temperature._();

  static Temperature parse(dynamic json) {
    final result = Temperature._();
    result.trendData = TrendData.parse(json);
    result.source = _parseTemperatureSource(json['SrcLabel']);
    return result;
  }

  static TemperatureSource _parseTemperatureSource(dynamic json) {
    switch (json) {
      case -2:
        return TemperatureSource.na;
      case 1:
        return TemperatureSource.none;
      case 3:
        return TemperatureSource.art;
      case 4:
        return TemperatureSource.core;
      case 5:
        return TemperatureSource.cereb;
      case 6:
        return TemperatureSource.rect;
      case 7:
        return TemperatureSource.skin;

      case -1:
      case 0:
      case 2:
      default:
        return TemperatureSource.unspecified;
    }
  }
}

enum Unit {
  none,
  kpa,
  mmhg,
  c,
  f,
  percent,
  bpmBreaths,
  bpmBeats,
  nanovolts,
  microvolts,
  millivolts,
  volts,
  ppm,
  rpm,
  mah,
  milliohms,
  gDl,
  mmoL,
  mlDl,
  ma,
  j,
  pacerPerMin,
}

class ValueUnitPair {
  int value;
  Unit? unit;
  bool valid;

  ValueUnitPair(this.value, this.unit, this.valid);
}

class TrendData {
  late ValueUnitPair value;
  late int alarm;
  late int dataStatus;

  TrendData._();

  static TrendData parse(dynamic json, {bool forceInvalid = false}) {
    final result = TrendData._();
    final trendData = json['TrendData'];

    final chanState = json["ChanState"];

    final trendDataStatus = trendData["DataStatus"];
    final alarm = trendData["Alarm"];
    final val = trendData['Val'];
    final unit = _parseUnit(val['@Units']);
    int value = val['#text'];

    bool valid = true;
    if (forceInvalid) {
      valid = false;
      value = -1;
    } else {
      if (chanState != null && chanState != 0 ||
          trendDataStatus == 1 ||
          value == -1) {
        valid = false;
        value = -1;
      }

      if (trendDataStatus == 2 || trendDataStatus == 3) {
        valid = false;
        value = -1;
      }

      if (trendDataStatus == 1 || (value.toDouble() - -1.0).abs() < 0.0) {
        valid = false;
        value = -1;
      }
    }

    ValueUnitPair vup = ValueUnitPair(value, unit, valid);
    result.value = vup;
    result.alarm = alarm ?? 0;
    result.dataStatus = trendDataStatus ?? 0;
    return result;
  }

  static Unit? _parseUnit(int unit) {
    switch (unit) {
      case 0:
        return Unit.none;
      case 1:
        return Unit.kpa;
      case 2:
        return Unit.mmhg;
      case 3:
        return Unit.c;
      case 4:
        return Unit.f;
      case 5:
        return Unit.percent;
      case 10:
        return Unit.bpmBreaths;
      case 11:
        return Unit.bpmBeats;
      case 20:
        return Unit.nanovolts;
      case 21:
        return Unit.microvolts;
      case 22:
        return Unit.millivolts;
      case 23:
        return Unit.volts;
      case 32:
        return Unit.ppm;
      case 33:
        return Unit.rpm;
      case 34:
        return Unit.mah;
      case 35:
        return Unit.milliohms;
      case 36:
        return Unit.gDl;
      case 37:
        return Unit.mmoL;
      case 38:
        return Unit.mlDl;

      case 6:
      case 7:
      case 8:
      case 9:
      case 12:
      case 13:
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28:
      case 29:
      case 30:
      case 31:
      default:
        return null;
    }
  }
}

class TrendReport {
  late HeartRate heartRate;
  late RespirationRate respirationRate;
  late TrendData etco2;
  late TrendData spo2;
  late TrendData diastolicBloodPressure;
  late TrendData systolicBloodPressure;
  late TrendData meanArterialPressure;
  late IBPReport ibp1Report;
  late IBPReport ibp2Report;
  late IBPReport ibp3Report;
  late Temperature temperature1;
  late Temperature temperature2;
  late Temperature temperatureDelta;

  TrendReport._();

  static TrendReport parse(dynamic json) {
    final result = TrendReport._();
    final trend = json['Trend'];
    result.heartRate = HeartRate.parse(trend['Hr']);
    result.respirationRate = RespirationRate.parse(trend['Resp']);
    result.etco2 = TrendData.parse(trend['Etco2']);
    result.spo2 = TrendData.parse(trend['Spo2']);
    int? nibpChanState = trend['Nibp']["ChanState"];
    bool forceNibpInvalid = nibpChanState != null && nibpChanState == 1;
    result.diastolicBloodPressure =
        TrendData.parse(trend['Nibp']['Dia'], forceInvalid: forceNibpInvalid);
    result.systolicBloodPressure =
        TrendData.parse(trend['Nibp']['Sys'], forceInvalid: forceNibpInvalid);
    result.meanArterialPressure =
        TrendData.parse(trend['Nibp']['Map'], forceInvalid: forceNibpInvalid);
    if (trend.containsKey('Ibp')) {
      final ibps = trend['Ibp'];
      for (final ibp in ibps) {
        int chanNum = ibp['@ChanNum'];
        switch (chanNum) {
          case 1:
            result.ibp1Report = IBPReport.parse(ibp);
            break;
          case 2:
            result.ibp2Report = IBPReport.parse(ibp);
            break;
          case 3:
            result.ibp3Report = IBPReport.parse(ibp);
            break;
        }
      }
    }

    if (trend.containsKey('Temp')) {
      final temps = trend['Temp'];
      for (final temp in temps) {
        int type = temp['@Type'];
        switch (type) {
          case 1:
            result.temperature1 = Temperature.parse(temp);
            break;
          case 2:
            result.temperature2 = Temperature.parse(temp);
            break;
          case 3:
            result.temperatureDelta = Temperature.parse(temp);
            break;
        }
      }
    }

    return result;
  }
}

enum IBPSource {
  unspecified,
  none,
  abp,
  art,
  ao,
  cvp,
  icp,
  lap,
  p1,
  p2,
  p3,
  pap,
  rap,
  uap,
  uvp,
  bap,
  fap,
}

class IBPReport {
  late int chanNum;
  late IBPSource source;
  late TrendData diastolicBloodPressure;
  late TrendData systolicBloodPressure;
  late TrendData meanArterialPressure;
  IBPReport._();

  static IBPReport parse(dynamic json) {
    final result = IBPReport._();
    result.chanNum = json['@ChanNum'];
    result.source = _parseIBPSource(json['SrcLabel'], json['@ChanNum']);
    final ibpChanState = json["ChanState"];
    final forceInvalid = ibpChanState != null && ibpChanState == 1;
    result.diastolicBloodPressure =
        TrendData.parse(json['Dia'], forceInvalid: forceInvalid);
    result.systolicBloodPressure =
        TrendData.parse(json['Sys'], forceInvalid: forceInvalid);
    result.meanArterialPressure =
        TrendData.parse(json['Map'], forceInvalid: forceInvalid);
    return result;
  }

  static IBPSource _parseIBPSource(int value, int chanNum) {
    switch (value) {
      case 0:
        return IBPSource.none;
      case 1:
        return IBPSource.abp;
      case 2:
        return IBPSource.art;
      case 3:
        return IBPSource.ao;
      case 4:
        return IBPSource.cvp;
      case 5:
        return IBPSource.icp;
      case 6:
        return IBPSource.lap;
      case 7:
        if (chanNum == 1) {
          return IBPSource.p1;
        } else {
          if (chanNum == 2) {
            return IBPSource.p2;
          }

          return IBPSource.p3;
        }
      case 8:
        return IBPSource.pap;
      case 9:
        return IBPSource.rap;
      case 10:
        return IBPSource.uap;
      case 11:
        return IBPSource.uvp;
      case 12:
        return IBPSource.bap;
      case 13:
        return IBPSource.fap;
      default:
        return IBPSource.unspecified;
    }
  }
}

class FullCase {
  FullCase();

  late StdHdr newCaseHeader;
  late PatientInfo patientInfo;
  late DeviceConfiguration deviceConfiguration;
  late List<TrendReport> trends = [];
}
