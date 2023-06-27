import 'dart:convert';

import 'package:ak_azm_flutter/data/parser/full_case.dart';

class FullCaseParser {
  static void parse(String raw) {
    final result = FullCase();
    final json = jsonDecode(raw);
    final events = json["ZOLL"]["FullDisclosure"]["FullDisclosureRecord"];
    for (final event in events) {
      final String eventType = event.keys.first;
      final eventData = event.values.first;
      switch (eventType) {
        case 'NewCase':
          result.newCaseHeader = StdHdr.parse(eventData['StdHdr']);
          break;
        case 'PatientInfo':
          result.patientInfo = PatientInfo.parse(eventData);
          break;
        case 'DeviceConfiguration':
          result.deviceConfiguration = DeviceConfiguration.parse(eventData);
          break;
        case 'TrendRpt':
          result.trends.add(TrendReport.parse(eventData));
          break;
        case 'SnapshotRpt':
          result.trends.add(TrendReport.parse(eventData));
          break;
      }
    }
  }
}
