import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ms_hospital.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class MSHospital extends Equatable {
  dynamic HospitalCD;
  dynamic Name;
  dynamic Address;
  dynamic TEL;

  MSHospital({
    this.HospitalCD,
    this.Name,
    this.Address,
    this.TEL,
  });

  factory MSHospital.fromJson(Map<String, dynamic> json) =>
      _$MSHospitalFromJson(json);

  Map<String, dynamic> toJson() => _$MSHospitalToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
        HospitalCD,
        Name,
        Address,
        TEL,
      ];
}
