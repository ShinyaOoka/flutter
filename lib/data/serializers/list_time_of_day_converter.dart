import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

class ListTimeOfDayConverter
    implements JsonConverter<ObservableList<TimeOfDay?>, String> {
  const ListTimeOfDayConverter();

  @override
  ObservableList<TimeOfDay?> fromJson(String json) {
    return ObservableList.of((jsonDecode(json) as Iterable).map(
      (e) {
        e = e as String;
        if (e.isEmpty) return null;
        final parts = e.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      },
    ));
  }

  @override
  String toJson(ObservableList<TimeOfDay?> object) => jsonEncode(
      object.map((e) => e != null ? '${e.hour}:${e.minute}' : '').toList());
}
