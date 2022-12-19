import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_fire_station.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSFireStation extends Equatable {
  dynamic FireStationCD;
  dynamic Name;
  dynamic Address;
  dynamic TEL;

  MSFireStation({
    this.FireStationCD,
    this.Name,
    this.Address,
    this.TEL,
  });

  factory MSFireStation.fromJson(Map<String, dynamic> json) =>
      _$MSFireStationFromJson(json);

  Map<String, dynamic> toJson() => _$MSFireStationToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
        FireStationCD,
        Name,
        Address,
        TEL,
      ];
}
