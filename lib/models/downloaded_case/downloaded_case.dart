import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'downloaded_case.g.dart';

@JsonSerializable()
class DownloadedCase extends _DownloadedCase with _$DownloadedCase {
  DownloadedCase();
  factory DownloadedCase.fromJson(Map<String, dynamic> json) =>
      _$DownloadedCaseFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadedCaseToJson(this);
}

abstract class _DownloadedCase with Store {
  @observable
  @JsonKey(name: 'ID')
  int? id;
  @observable
  @JsonKey(name: 'CaseID')
  String? caseCd;
  @observable
  @JsonKey(name: 'DeviceID')
  String? deviceCd;
  @observable
  @JsonKey(name: "CaseStartDate")
  DateTime? caseStartDate;
  @observable
  @JsonKey(name: "CaseEndDate")
  DateTime? caseEndDate;
  @observable
  @JsonKey(name: 'Filename')
  String? filename;
  @observable
  String? entryName;
  @observable
  String? entryMachine;
  @observable
  @JsonKey(name: "EntryDate")
  DateTime? entryDate;
  @observable
  String? updateName;
  @observable
  String? updateMachine;
  @observable
  @JsonKey(name: "UpdateDate")
  DateTime? updateDate;
}
