import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

// For some reason cannot use generic?
class ListStringConverter
    implements JsonConverter<ObservableList<String?>, String> {
  const ListStringConverter();

  @override
  ObservableList<String?> fromJson(String json) {
    return ObservableList.of(
        (jsonDecode(json) as Iterable<dynamic>).map((e) => e as String?));
  }

  @override
  String toJson(ObservableList<String?> object) => jsonEncode(object.toList());
}

class ListIntConverter implements JsonConverter<ObservableList<int?>, String> {
  const ListIntConverter();

  @override
  ObservableList<int?> fromJson(String json) {
    return ObservableList.of(
        (jsonDecode(json) as Iterable<dynamic>).map((e) => e as int?));
  }

  @override
  String toJson(ObservableList<int?> object) => jsonEncode(object.toList());
}

class ListBoolConverter
    implements JsonConverter<ObservableList<bool?>, String> {
  const ListBoolConverter();

  @override
  ObservableList<bool?> fromJson(String json) {
    return ObservableList.of(
        (jsonDecode(json) as Iterable<dynamic>).map((e) => e as bool?));
  }

  @override
  String toJson(ObservableList<bool?> object) => jsonEncode(object.toList());
}
