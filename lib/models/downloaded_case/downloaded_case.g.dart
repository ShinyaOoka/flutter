// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadedCase _$DownloadedCaseFromJson(Map<String, dynamic> json) =>
    DownloadedCase()
      ..id = json['ID'] as int?
      ..caseCd = json['CaseCD'] as String?
      ..deviceCd = json['DeviceCD'] as String?
      ..caseStartDate = json['CaseStartDate'] == null
          ? null
          : DateTime.parse(json['CaseStartDate'] as String)
      ..caseEndDate = json['CaseEndDate'] == null
          ? null
          : DateTime.parse(json['CaseEndDate'] as String)
      ..filename = json['Filename'] as String?
      ..entryName = json['entryName'] as String?
      ..entryMachine = json['entryMachine'] as String?
      ..entryDate = json['EntryDate'] == null
          ? null
          : DateTime.parse(json['EntryDate'] as String)
      ..updateName = json['updateName'] as String?
      ..updateMachine = json['updateMachine'] as String?
      ..updateDate = json['UpdateDate'] == null
          ? null
          : DateTime.parse(json['UpdateDate'] as String);

Map<String, dynamic> _$DownloadedCaseToJson(DownloadedCase instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'CaseCD': instance.caseCd,
      'DeviceCD': instance.deviceCd,
      'CaseStartDate': instance.caseStartDate?.toIso8601String(),
      'CaseEndDate': instance.caseEndDate?.toIso8601String(),
      'Filename': instance.filename,
      'entryName': instance.entryName,
      'entryMachine': instance.entryMachine,
      'EntryDate': instance.entryDate?.toIso8601String(),
      'updateName': instance.updateName,
      'updateMachine': instance.updateMachine,
      'UpdateDate': instance.updateDate?.toIso8601String(),
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DownloadedCase on _DownloadedCase, Store {
  late final _$idAtom = Atom(name: '_DownloadedCase.id', context: context);

  @override
  int? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$caseCdAtom =
      Atom(name: '_DownloadedCase.caseCd', context: context);

  @override
  String? get caseCd {
    _$caseCdAtom.reportRead();
    return super.caseCd;
  }

  @override
  set caseCd(String? value) {
    _$caseCdAtom.reportWrite(value, super.caseCd, () {
      super.caseCd = value;
    });
  }

  late final _$deviceCdAtom =
      Atom(name: '_DownloadedCase.deviceCd', context: context);

  @override
  String? get deviceCd {
    _$deviceCdAtom.reportRead();
    return super.deviceCd;
  }

  @override
  set deviceCd(String? value) {
    _$deviceCdAtom.reportWrite(value, super.deviceCd, () {
      super.deviceCd = value;
    });
  }

  late final _$caseStartDateAtom =
      Atom(name: '_DownloadedCase.caseStartDate', context: context);

  @override
  DateTime? get caseStartDate {
    _$caseStartDateAtom.reportRead();
    return super.caseStartDate;
  }

  @override
  set caseStartDate(DateTime? value) {
    _$caseStartDateAtom.reportWrite(value, super.caseStartDate, () {
      super.caseStartDate = value;
    });
  }

  late final _$caseEndDateAtom =
      Atom(name: '_DownloadedCase.caseEndDate', context: context);

  @override
  DateTime? get caseEndDate {
    _$caseEndDateAtom.reportRead();
    return super.caseEndDate;
  }

  @override
  set caseEndDate(DateTime? value) {
    _$caseEndDateAtom.reportWrite(value, super.caseEndDate, () {
      super.caseEndDate = value;
    });
  }

  late final _$filenameAtom =
      Atom(name: '_DownloadedCase.filename', context: context);

  @override
  String? get filename {
    _$filenameAtom.reportRead();
    return super.filename;
  }

  @override
  set filename(String? value) {
    _$filenameAtom.reportWrite(value, super.filename, () {
      super.filename = value;
    });
  }

  late final _$entryNameAtom =
      Atom(name: '_DownloadedCase.entryName', context: context);

  @override
  String? get entryName {
    _$entryNameAtom.reportRead();
    return super.entryName;
  }

  @override
  set entryName(String? value) {
    _$entryNameAtom.reportWrite(value, super.entryName, () {
      super.entryName = value;
    });
  }

  late final _$entryMachineAtom =
      Atom(name: '_DownloadedCase.entryMachine', context: context);

  @override
  String? get entryMachine {
    _$entryMachineAtom.reportRead();
    return super.entryMachine;
  }

  @override
  set entryMachine(String? value) {
    _$entryMachineAtom.reportWrite(value, super.entryMachine, () {
      super.entryMachine = value;
    });
  }

  late final _$entryDateAtom =
      Atom(name: '_DownloadedCase.entryDate', context: context);

  @override
  DateTime? get entryDate {
    _$entryDateAtom.reportRead();
    return super.entryDate;
  }

  @override
  set entryDate(DateTime? value) {
    _$entryDateAtom.reportWrite(value, super.entryDate, () {
      super.entryDate = value;
    });
  }

  late final _$updateNameAtom =
      Atom(name: '_DownloadedCase.updateName', context: context);

  @override
  String? get updateName {
    _$updateNameAtom.reportRead();
    return super.updateName;
  }

  @override
  set updateName(String? value) {
    _$updateNameAtom.reportWrite(value, super.updateName, () {
      super.updateName = value;
    });
  }

  late final _$updateMachineAtom =
      Atom(name: '_DownloadedCase.updateMachine', context: context);

  @override
  String? get updateMachine {
    _$updateMachineAtom.reportRead();
    return super.updateMachine;
  }

  @override
  set updateMachine(String? value) {
    _$updateMachineAtom.reportWrite(value, super.updateMachine, () {
      super.updateMachine = value;
    });
  }

  late final _$updateDateAtom =
      Atom(name: '_DownloadedCase.updateDate', context: context);

  @override
  DateTime? get updateDate {
    _$updateDateAtom.reportRead();
    return super.updateDate;
  }

  @override
  set updateDate(DateTime? value) {
    _$updateDateAtom.reportWrite(value, super.updateDate, () {
      super.updateDate = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
caseCd: ${caseCd},
deviceCd: ${deviceCd},
caseStartDate: ${caseStartDate},
caseEndDate: ${caseEndDate},
filename: ${filename},
entryName: ${entryName},
entryMachine: ${entryMachine},
entryDate: ${entryDate},
updateName: ${updateName},
updateMachine: ${updateMachine},
updateDate: ${updateDate}
    ''';
  }
}
