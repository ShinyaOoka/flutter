import 'dart:convert';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:mobx/mobx.dart';

class CaseParser {
  static Case parse(String raw) {
    final result = Case();
    final Map<String, dynamic> map = jsonDecode(raw);
    final Map<String, dynamic> zoll = map["ZOLL"];
    final List<dynamic> fullDisclosure = zoll["FullDisclosure"];
    final List<dynamic> fullDisclosureRecord = fullDisclosure.firstWhere(
      (element) {
        final e = element as Map<String, dynamic>;
        return e.containsKey("FullDisclosureRecord");
      },
    )["FullDisclosureRecord"];
    final events = fullDisclosureRecord
        .map((e) {
          final event = e as Map<String, dynamic>;
          var eventType = event.keys.first;
          final eventData = event.values.first;
          final stdHdr = ((eventData as Map<String, dynamic>)["StdHdr"]
              as Map<String, dynamic>);
          final dateString = stdHdr["DevDateTime"] as String;
          final date = DateTime.parse(dateString);
          if (eventType == "AnnotationEvt") {
            eventType += " " + eventData["@EvtName"];
          }
          final caseEvent = CaseEvent(
              date: date,
              type: eventType,
              elapsedTime: stdHdr["ElapsedTime"],
              msecTime: stdHdr["MsecTime"],
              rawData: eventData);
          caseEvent.date = date;
          caseEvent.type = eventType;
          return caseEvent;
        })
        .where((element) =>
            !element.type.startsWith("AnnotationEvt") &&
            element.type != "SysLogEntry" &&
            element.type != "PrtTrace" &&
            element.type != "DefibTrace")
        .toList();
    events.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare == 0) {
        return a.msecTime.compareTo(b.msecTime);
      }
      return dateCompare;
    });
    result.events = ObservableList.of(events);
    return result;
  }
}
