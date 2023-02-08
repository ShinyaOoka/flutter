import 'package:pigeon/pigeon.dart';

class XSeriesDevice {
  late String address;
  late String serialNumber;
}

enum Unit {
  none,
  kpa,
  mmhg,
  c,
  f,
  percent,
  bpmBeats,
  bpmBreaths,
  nanovolts,
  microvolts,
  millivolts,
  volts,
  ppm,
  pacerPerMin,
  rpm,
  mah,
  ma,
  mOm,
  gDl,
  mmoL,
  mlDl,
  j
}

class ValueUnitPair {
  late double value;
  late Unit unit;
  late bool isValid;
}

enum AlarmStatus {
  notAlarming,
  alarming,
}

enum DataStatus {
  valid,
  invalid,
  underrange,
  overrange,
}

class TrendData {
  late ValueUnitPair value;
  late AlarmStatus alarm;
  late DataStatus dataStatus;
}

class VitalSigns {
  late TrendData spo2;
}

class CaseListItem {
  late String? startTime;
  late String? endTime;
  late String caseId;
}

@HostApi()
abstract class ZollSdkHostApi {
  void browserStart();
  void browserStop();

  @async
  int deviceGetCaseList(XSeriesDevice device, String? password);

  @async
  int deviceDownloadCase(
      XSeriesDevice device, String caseId, String path, String? password);
}

@FlutterApi()
abstract class ZollSdkFlutterApi {
  void onDeviceFound(XSeriesDevice device);
  void onDeviceLost(XSeriesDevice device);
  void onBrowseError();

  void onGetCaseListSuccess(
      int requestCode, String serialNumber, List<CaseListItem?> cases);

  void onDownloadCaseSuccess(
      int requestCode, String serialNumber, String caseId, String path);
}
