import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'fire_station.g.dart';

@JsonSerializable()
class FireStation extends _FireStation with _$FireStation {
  FireStation();
  factory FireStation.fromJson(Map<String, dynamic> json) =>
      _$FireStationFromJson(json);
  Map<String, dynamic> toJson() => _$FireStationToJson(this);
}

abstract class _FireStation with Store {
  @observable
  @JsonKey(name: 'FireStationCD')
  String? fireStationCd;
  @observable
  @JsonKey(name: 'Name')
  String? name;
  @observable
  @JsonKey(name: 'Address')
  String? address;
  @observable
  @JsonKey(name: 'TEL')
  String? tel;
}
