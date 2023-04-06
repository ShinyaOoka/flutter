import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:tuple/tuple.dart';

part 'case.g.dart';

class Sample {
  double value;
  int timestamp;

  Sample({required this.timestamp, required this.value});

  double get inSeconds {
    return timestamp / 1000000;
  }

  @override
  String toString() {
    return 'S: {${timestamp}:${value}}';
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

class Case = _Case with _$Case;

abstract class _Case with Store {
  @observable
  List<CaseEvent> events = [];

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
    final map = Map<String, Waveform>();
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
            } else {
              value = samples[i].toDouble();
            }
            waveform.samples.add(
                Sample(timestamp: timestamp + i * sampleTime, value: value));
          }
        }
      }
    }
    return map;
  }
}
