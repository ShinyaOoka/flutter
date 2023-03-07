import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'hospital.g.dart';

@JsonSerializable()
class Hospital extends _Hospital with _$Hospital {
  Hospital();
  factory Hospital.fromJson(Map<String, dynamic> json) =>
      _$HospitalFromJson(json);
  Map<String, dynamic> toJson() => _$HospitalToJson(this);
}

abstract class _Hospital with Store {
  @observable
  @JsonKey(name: 'HospitalCD')
  String? hospitalCd;
  @observable
  @JsonKey(name: 'Name')
  String? name;
  @observable
  @JsonKey(name: 'Address')
  String? address;
  @observable
  @JsonKey(name: 'TEL')
  String? tel;
  @observable
  @JsonKey(name: 'EmergencyMedicineLevel')
  int? emergencyMedicineLevel;
}
