import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

part 'case.g.dart';

class TrendData {
  int status;
  int value;
  String unit;

  TrendData({
    required this.status,
    required this.value,
    required this.unit,
  });
}

class CprCompression {
  int timestamp;
  int compDisp;
  int relVelocity;
  int loRateFlag;
  int compRate;
  int detectionFlag;
  int loDepthFlag;
  int hiDepthFlag;
  int hiRateFlag;

  double get inSeconds {
    return timestamp / 1000000;
  }

  CprCompression({
    required this.timestamp,
    required this.compDisp,
    required this.relVelocity,
    required this.loRateFlag,
    required this.compRate,
    required this.detectionFlag,
    required this.loDepthFlag,
    required this.hiDepthFlag,
    required this.hiRateFlag,
  });
}

class PatientData {
  String firstName;
  String middleName;
  String lastName;
  int age;
  String patientId;
  String sex;
  int gender;

  PatientData({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.age,
    required this.patientId,
    required this.sex,
    required this.gender,
  });
}

class Trend {
  List<TrendData> temps;
  TrendData hr;
  TrendData fico2;
  TrendData spo2;
  TrendData spCo;
  TrendData spMet;
  TrendData pVI;
  TrendData pI;
  TrendData spOC;
  TrendData spHb;
  TrendData nibpMap;
  TrendData nibpDia;
  TrendData nibpSys;
  List<TrendData> ibpSys;
  List<TrendData> ibpMap;
  List<TrendData> ibpDia;
  TrendData etco2;
  TrendData resp;

  Trend({
    required this.temps,
    required this.hr,
    required this.fico2,
    required this.spo2,
    required this.spCo,
    required this.spMet,
    required this.pVI,
    required this.pI,
    required this.spOC,
    required this.spHb,
    required this.nibpMap,
    required this.nibpDia,
    required this.nibpSys,
    required this.ibpSys,
    required this.ibpMap,
    required this.ibpDia,
    required this.etco2,
    required this.resp,
  });
}

class Sample {
  double value;
  int timestamp;

  Sample({required this.timestamp, required this.value});

  double get inSeconds {
    return timestamp / 1000000;
  }

  @override
  String toString() {
    return 'S: {$timestamp:$value}';
  }
}

class Waveform {
  List<Sample> samples = [];
  List<Sample> statuses = [];
  String type;

  Waveform({required this.type});

  @override
  String toString() {
    return samples.toString();
  }
}

class Ecg12Lead {
  DateTime time;

  PatientData patientData;
  int heartRate;
  int qrsDur;
  int qtInt;
  int corrQtInt;
  int prInt;
  int pAxis;
  int qrsAxis;
  int tAxis;
  List<int> stValues;
  List<String> statements;
  Waveform leadI;
  Waveform leadII;
  Waveform leadIII;
  Waveform leadV1;
  Waveform leadV2;
  Waveform leadV3;
  Waveform leadV4;
  Waveform leadV5;
  Waveform leadV6;
  Waveform leadAVL;
  Waveform leadAVR;
  Waveform leadAVF;

  Ecg12Lead({
    required this.time,
    required this.qrsDur,
    required this.qtInt,
    required this.corrQtInt,
    required this.prInt,
    required this.pAxis,
    required this.qrsAxis,
    required this.tAxis,
    required this.stValues,
    required this.patientData,
    required this.heartRate,
    required this.statements,
    required this.leadI,
    required this.leadII,
    required this.leadIII,
    required this.leadV1,
    required this.leadV2,
    required this.leadV3,
    required this.leadV4,
    required this.leadV5,
    required this.leadV6,
    required this.leadAVL,
    required this.leadAVR,
    required this.leadAVF,
  });
}

class Snapshot {
  DateTime time;
  Map<String, Waveform> waveforms;
  Trend trend;

  Snapshot({required this.time, required this.waveforms, required this.trend});
}

List<Sample> movingAverage(List<Sample> samples, int windowSize) {
  int i = 0;
  List<Sample> result = [];
  while (i < samples.length - windowSize + 1) {
    double average =
        samples.sublist(i, i + windowSize).map((e) => e.value).sum / windowSize;
    result.add(Sample(timestamp: samples[i].timestamp, value: average));
    i += 1;
  }
  while (i < samples.length) {
    result
        .add(Sample(timestamp: samples[i].timestamp, value: samples[i].value));
    i += 1;
  }
  return result;
}

class Case = _Case with _$Case;

abstract class _Case with Store {
  @observable
  ObservableList<CaseEvent> events = ObservableList();

  @observable
  NativeCase? nativeCase;

  @observable
  DateTime? startTime;

  @observable
  DateTime? endTime;

  @computed
  ObservableList<Tuple2<int, CaseEvent>> get displayableEvents {
    final hiddenEvents = <String>{};
    hiddenEvents.addAll(events.map((e) => e.type));

    final shownEvents = events
        .asMap()
        .entries
        .map((e) => Tuple2(e.key, e.value))
        .where((event) {
          var keep = true;
          if (startTime != null) {
            keep &=
                event.item2.date.toLocal().compareTo(startTime!.toLocal()) >= 0;
          }
          if (endTime != null) {
            keep &=
                event.item2.date.toLocal().compareTo(endTime!.toLocal()) <= 0;
          }
          return keep;
        })
        .where((e) {
          return e.item2.type != "Aed" &&
              e.item2.type != "AedContinAnalysis" &&
              e.item2.type != "AlarmLimits" &&
              e.item2.type != "ContinWaveRec" &&
              e.item2.type != "CprAccelWaveRec" &&
              e.item2.type != "CprCompression" &&
              e.item2.type != "DataChannels" &&
              e.item2.type != "DefibFireEvt" &&
              e.item2.type != "DefibTrace" &&
              e.item2.type != "DeviceConfiguration" &&
              e.item2.type != "DisplayInfo" &&
              e.item2.type != "InstrumentPacket" &&
              e.item2.type != "NewCase" &&
              e.item2.type != "PatientInfo" &&
              e.item2.type != "PrtTrace" &&
              e.item2.type != "TraceConfigs" &&
              e.item2.type != "AnnotationEvt Defib Out of Lead Fault" &&
              e.item2.type != "AnnotationEvt CO2 Sfm In Process" &&
              e.item2.type != "AnnotationEvt Fan Turned On" &&
              e.item2.type != "AnnotationEvt Internal Disarm" &&
              e.item2.type != "AnnotationEvt Deflib Precharging" &&
              e.item2.type != "AnnotationEvt Deflib Precharged" &&
              e.item2.type != "AnnotationEvt Defib Lead Fault" &&
              e.item2.type != "AnnotationEvt Resp Lead Change" &&
              e.item2.type != "AnnotationEvt CO2 Cal Required" &&
              e.item2.type != "AnnotationEvt NIBP Device Status" &&
              e.item2.type != "AnnotationEvt Self Test Passed" &&
              e.item2.type != "AnnotationEvt Comm Processor Ready" &&
              e.item2.type != "AnnotationEvt SPO2 Probe Connected" &&
              e.item2.type != "AnnotationEvt Wi-Fi Profile Selected" &&
              e.item2.type != "AnnotationEvt Wi-Fi Connection Up" &&
              e.item2.type != "AnnotationEvt SPO2 Probe Disconnect" &&
              e.item2.type != "AnnotationEvt SpO2 Calibrating" &&
              e.item2.type != "AnnotationEvt CO2 On" &&
              e.item2.type != "AnnotationEvt Defib Lead Fault" &&
              e.item2.type != "AnnotationEvt Defib Precharging" &&
              e.item2.type != "AnnotationEvt Defib Precharged" &&
              e.item2.type != "AnnotationEvt SPO2 Check Probe" &&
              e.item2.type != "AnnotationEvt SpO2 Low Perfusion" &&
              e.item2.type != "AnnotationEvt CO2 Off" &&
              e.item2.type != "AnnotationEvt SPO2 Probe Not Connected" &&
              e.item2.type != "AedSingleAnalysis" &&
              e.item2.type != "TrendRpt";
        })
        .toList()
        .asObservable();
    hiddenEvents.removeAll(shownEvents.map((e) => e.item2.type));
    return shownEvents;
  }

  @computed
  Map<String, Waveform> get waves {
    final map = <String, Waveform>{};
    for (var event in events) {
      if (event.type == 'ContinWaveRec') {
        final startTimeString = event.rawData['StdHdr']['DevDateTime'];
        final date =
            DateFormat("yyyy-MM-ddTHH:mm:ss").parse(startTimeString).toLocal();
        final timestamp = date.microsecondsSinceEpoch;
        final waveforms = event.rawData['Waveform'];
        for (var waveformRaw in waveforms) {
          final samples = waveformRaw['WaveRec']['UnpackedSamples'];
          final sampleStatuses = waveformRaw['WaveRec']['SampleStatus'];
          final waveType = waveformRaw['WaveRec']['WaveTypeVar'];
          final count = waveformRaw['WaveRec']['FrameSize'] as int;
          final sampleTime = waveformRaw['WaveRec']['SampleTime'] as int;
          if (!map.containsKey(waveType)) {
            map[waveType] = Waveform(type: waveType);
          }
          final waveform = map[waveType]!;
          for (var i = 0; i < count; i++) {
            var value;
            if (waveType == 'Pads') {
              value = samples[i] / 4 * 10;
            } else if (waveType == 'CO2 mmHg, Waveform') {
              value = samples[i] / 10;
            } else if (waveType == 'Pads Impedance') {
              value = samples[i].toDouble() + 20250;
            } else {
              value = samples[i].toDouble();
            }
            waveform.samples.add(
                Sample(timestamp: timestamp + i * sampleTime, value: value));
          }
        }
      }
    }
    // map['Pads Impedance']!.samples =
    //     movingAverage(map['Pads Impedance']!.samples, 10);

    return map;
  }

  @computed
  List<CprCompression> get cprCompressions {
    List<CprCompression> result = [];
    late int firstMsecTime;
    late int firstTimestamp;
    for (var event in events) {
      if (event.type == 'NewCase') {
        firstMsecTime = event.rawData['StdHdr']['MsecTime'];
        firstTimestamp = DateFormat("yyyy-MM-ddTHH:mm:ss")
            .parse(event.rawData['StdHdr']['DevDateTime'])
            .toLocal()
            .microsecondsSinceEpoch;
      }
      if (event.type == 'CprCompression') {
        result.add(CprCompression(
            timestamp: firstTimestamp -
                firstMsecTime * 1000 +
                (event.rawData['StdHdr']['MsecTime'] as int) * 1000,
            compDisp: event.rawData['CompDisp'],
            relVelocity: event.rawData['RelVelocity'],
            loRateFlag: event.rawData['LoRateFlag'],
            compRate: event.rawData['CompRate'],
            detectionFlag: event.rawData['DetectionFlag'],
            loDepthFlag: event.rawData['LoDepthFlag'],
            hiDepthFlag: event.rawData['HiDepthFlag'],
            hiRateFlag: event.rawData['HiRateFlag']));
      }
    }
    return result;
  }

  @computed
  List<Ecg12Lead> get leads {
    final List<Ecg12Lead> result = [];
    for (var event in events) {
      if (event.type == 'Ecg12LeadRec') {
        print('here');
        final startTimeString = event.rawData['StdHdr']['DevDateTime'];
        final date =
            DateFormat("yyyy-MM-ddTHH:mm:ss").parse(startTimeString).toLocal();
        final timestamp = date.microsecondsSinceEpoch;
        final sampleRate = event.rawData['SampleRate'] as int;
        final patientDataRaw = event.rawData['PatientData'];
        final patientData = PatientData(
            firstName: patientDataRaw['FirstName'],
            middleName: patientDataRaw['MiddleName'],
            lastName: patientDataRaw['LastName'],
            age: patientDataRaw['Age'],
            patientId: patientDataRaw['PatientId'],
            sex: patientDataRaw['Sex'],
            gender: patientDataRaw['Gender']);
        Waveform leadI = Waveform(type: "LeadI");
        Waveform leadII = Waveform(type: "LeadII");
        Waveform leadIII = Waveform(type: "LeadIII");
        Waveform leadAVL = Waveform(type: "LeadAVL");
        Waveform leadAVR = Waveform(type: "LeadAVR");
        Waveform leadAVF = Waveform(type: "LeadAVF");
        Waveform leadV1 = Waveform(type: "LeadV1");
        Waveform leadV2 = Waveform(type: "LeadV2");
        Waveform leadV3 = Waveform(type: "LeadV3");
        Waveform leadV4 = Waveform(type: "LeadV4");
        Waveform leadV5 = Waveform(type: "LeadV5");
        Waveform leadV6 = Waveform(type: "LeadV6");
        final leadIRaw = event.rawData['LeadData']['LeadI'];
        final leadIIRaw = event.rawData['LeadData']['LeadII'];
        final leadV1Raw = event.rawData['LeadData']['LeadV1'];
        final leadV2Raw = event.rawData['LeadData']['LeadV2'];
        final leadV3Raw = event.rawData['LeadData']['LeadV3'];
        final leadV4Raw = event.rawData['LeadData']['LeadV4'];
        final leadV5Raw = event.rawData['LeadData']['LeadV5'];
        final leadV6Raw = event.rawData['LeadData']['LeadV6'];
        final total = event.rawData['LeadData']['RecordCnt'];
        for (var i = 0; i < total; i++) {
          final t = timestamp + i * (1000000 ~/ sampleRate);
          leadI.samples.add(
              Sample(timestamp: t, value: leadIRaw[i].toDouble() / 4 * 10));
          leadII.samples.add(
              Sample(timestamp: t, value: leadIIRaw[i].toDouble() / 4 * 10));
          leadIII.samples.add(Sample(
              timestamp: t,
              value:
                  (leadIIRaw[i].toDouble() - leadIRaw[i].toDouble()) / 4 * 10));
          leadAVL.samples.add(Sample(
              timestamp: t,
              value: (leadIRaw[i].toDouble() - leadIIRaw[i].toDouble() / 2) /
                  4 *
                  10));
          leadAVR.samples.add(Sample(
              timestamp: t,
              value: (-leadIIRaw[i].toDouble() - leadIRaw[i].toDouble()) /
                  2 /
                  4 *
                  10));
          leadAVF.samples.add(Sample(
              timestamp: t,
              value: (leadIIRaw[i].toDouble() - leadIRaw[i].toDouble() / 2) /
                  4 *
                  10));
          leadV1.samples.add(
              Sample(timestamp: t, value: leadV1Raw[i].toDouble() / 4 * 10));
          leadV2.samples.add(
              Sample(timestamp: t, value: leadV2Raw[i].toDouble() / 4 * 10));
          leadV3.samples.add(
              Sample(timestamp: t, value: leadV3Raw[i].toDouble() / 4 * 10));
          leadV4.samples.add(
              Sample(timestamp: t, value: leadV4Raw[i].toDouble() / 4 * 10));
          leadV5.samples.add(
              Sample(timestamp: t, value: leadV5Raw[i].toDouble() / 4 * 10));
          leadV6.samples.add(
              Sample(timestamp: t, value: leadV6Raw[i].toDouble() / 4 * 10));
        }
        result.add(Ecg12Lead(
          time: date,
          patientData: patientData,
          qrsDur: event.rawData['AnalysisResult']['QrsDur'],
          qtInt: event.rawData['AnalysisResult']['QtInt'],
          corrQtInt: event.rawData['AnalysisResult']['CorrQtInt'],
          prInt: event.rawData['AnalysisResult']['PrInt'],
          pAxis: event.rawData['AnalysisResult']['PAxis'],
          qrsAxis: event.rawData['AnalysisResult']['QrsAxis'],
          tAxis: event.rawData['AnalysisResult']['TAxis'],
          stValues:
              (event.rawData['AnalysisResult']['StValues'] as List<dynamic>)
                  .map((x) => x as int)
                  .toList(),
          heartRate: event.rawData['AnalysisResult']['HeartRate'],
          statements: (event.rawData['AnalysisResult']['Statements']
                  ['Statement'] as List<dynamic>)
              .map((x) => x.toString())
              .toList(),
          leadI: leadI,
          leadII: leadII,
          leadIII: leadIII,
          leadAVL: leadAVL,
          leadAVR: leadAVR,
          leadAVF: leadAVF,
          leadV1: leadV1,
          leadV2: leadV2,
          leadV3: leadV3,
          leadV4: leadV4,
          leadV5: leadV5,
          leadV6: leadV6,
        ));
      }
    }
    return result;
  }

  TrendData parseTrendData(dynamic raw) {
    return TrendData(
      status: raw['DataStatus'],
      value: raw['Val']['#text'],
      unit: raw['Val']['@UnitsVal'],
    );
  }

  @computed
  List<Snapshot> get snapshots {
    final List<Snapshot> result = [];
    for (var event in events) {
      if (event.type == 'SnapshotRpt') {
        final map = <String, Waveform>{};
        final startTimeString = event.rawData['StdHdr']['DevDateTime'];
        final time =
            DateFormat("yyyy-MM-ddTHH:mm:ss").parse(startTimeString).toLocal();
        final waveforms = event.rawData['Waveform'];
        final timestamp = time.microsecondsSinceEpoch;
        for (var waveformRaw in waveforms) {
          final samples = waveformRaw['WaveRec']['UnpackedSamples'];
          final sampleStatuses = waveformRaw['WaveRec']['SampleStatus'];
          final waveType = waveformRaw['WaveRec']['WaveTypeVar'];
          final sampleTime = waveformRaw['WaveRec']['SampleTime'] as int;
          if (!map.containsKey(waveType)) {
            map[waveType] = Waveform(type: waveType);
          }
          final waveform = map[waveType]!;
          for (var i = 0; i < samples.length; i++) {
            double value;
            if (waveType == 'Pads') {
              value = samples[i] / 4 * 10;
            } else {
              value = samples[i].toDouble();
            }
            waveform.samples.add(
                Sample(timestamp: timestamp + i * sampleTime, value: value));
          }
        }
        final trendRaw = event.rawData['Trend'];
        result.add(Snapshot(
            time: time,
            waveforms: map,
            trend: Trend(
              temps: (trendRaw['Temp'] as List<dynamic>)
                  .map((x) => parseTrendData(x['TrendData']))
                  .toList(),
              hr: parseTrendData(trendRaw['Hr']['TrendData']),
              fico2: parseTrendData(trendRaw['Fico2']['TrendData']),
              spo2: parseTrendData(trendRaw['Spo2']['TrendData']),
              spCo: parseTrendData(trendRaw['Spo2']['SpCo']['TrendData']),
              spMet: parseTrendData(trendRaw['Spo2']['SpMet']['TrendData']),
              pVI: parseTrendData(trendRaw['Spo2']['PVI']['TrendData']),
              pI: parseTrendData(trendRaw['Spo2']['PI']['TrendData']),
              spOC: parseTrendData(trendRaw['Spo2']['SpOC']['TrendData']),
              spHb: parseTrendData(trendRaw['Spo2']['SpHb']['TrendData']),
              nibpMap: parseTrendData(trendRaw['Nibp']['Map']['TrendData']),
              nibpDia: parseTrendData(trendRaw['Nibp']['Dia']['TrendData']),
              nibpSys: parseTrendData(trendRaw['Nibp']['Sys']['TrendData']),
              ibpSys: (trendRaw['Ibp'] as List<dynamic>)
                  .map((x) => parseTrendData(x['Sys']['TrendData']))
                  .toList(),
              ibpMap: (trendRaw['Ibp'] as List<dynamic>)
                  .map((x) => parseTrendData(x['Map']['TrendData']))
                  .toList(),
              ibpDia: (trendRaw['Ibp'] as List<dynamic>)
                  .map((x) => parseTrendData(x['Dia']['TrendData']))
                  .toList(),
              etco2: parseTrendData(trendRaw['Etco2']['TrendData']),
              resp: parseTrendData(trendRaw['Resp']['TrendData']),
            )));
      }
    }
    return result;
  }
}
