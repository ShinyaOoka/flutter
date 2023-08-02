// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_case_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DownloadedCaseStore on _DownloadedCaseStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: '_DownloadedCaseStore.loading'))
      .value;

  late final _$getDownloadedCasesFutureAtom = Atom(
      name: '_DownloadedCaseStore.getDownloadedCasesFuture', context: context);

  @override
  ObservableFuture<List<DownloadedCase>?> get getDownloadedCasesFuture {
    _$getDownloadedCasesFutureAtom.reportRead();
    return super.getDownloadedCasesFuture;
  }

  @override
  set getDownloadedCasesFuture(ObservableFuture<List<DownloadedCase>?> value) {
    _$getDownloadedCasesFutureAtom
        .reportWrite(value, super.getDownloadedCasesFuture, () {
      super.getDownloadedCasesFuture = value;
    });
  }

  late final _$createDownloadedCaseFutureAtom = Atom(
      name: '_DownloadedCaseStore.createDownloadedCaseFuture',
      context: context);

  @override
  ObservableFuture<void> get createDownloadedCaseFuture {
    _$createDownloadedCaseFutureAtom.reportRead();
    return super.createDownloadedCaseFuture;
  }

  @override
  set createDownloadedCaseFuture(ObservableFuture<void> value) {
    _$createDownloadedCaseFutureAtom
        .reportWrite(value, super.createDownloadedCaseFuture, () {
      super.createDownloadedCaseFuture = value;
    });
  }

  late final _$deleteDownloadedCaseFutureAtom = Atom(
      name: '_DownloadedCaseStore.deleteDownloadedCaseFuture',
      context: context);

  @override
  ObservableFuture<void> get deleteDownloadedCaseFuture {
    _$deleteDownloadedCaseFutureAtom.reportRead();
    return super.deleteDownloadedCaseFuture;
  }

  @override
  set deleteDownloadedCaseFuture(ObservableFuture<void> value) {
    _$deleteDownloadedCaseFutureAtom
        .reportWrite(value, super.deleteDownloadedCaseFuture, () {
      super.deleteDownloadedCaseFuture = value;
    });
  }

  late final _$downloadedCasesAtom =
      Atom(name: '_DownloadedCaseStore.downloadedCases', context: context);

  @override
  ObservableList<DownloadedCase>? get downloadedCases {
    _$downloadedCasesAtom.reportRead();
    return super.downloadedCases;
  }

  @override
  set downloadedCases(ObservableList<DownloadedCase>? value) {
    _$downloadedCasesAtom.reportWrite(value, super.downloadedCases, () {
      super.downloadedCases = value;
    });
  }

  late final _$getDownloadedCasesAsyncAction =
      AsyncAction('_DownloadedCaseStore.getDownloadedCases', context: context);

  @override
  Future<dynamic> getDownloadedCases() {
    return _$getDownloadedCasesAsyncAction
        .run(() => super.getDownloadedCases());
  }

  late final _$saveCaseAsyncAction =
      AsyncAction('_DownloadedCaseStore.saveCase', context: context);

  @override
  Future<dynamic> saveCase(Case myCase, String deviceId, String caseId) {
    return _$saveCaseAsyncAction
        .run(() => super.saveCase(myCase, deviceId, caseId));
  }

  late final _$deleteDownloadedCaseAsyncAction = AsyncAction(
      '_DownloadedCaseStore.deleteDownloadedCase',
      context: context);

  @override
  Future<dynamic> deleteDownloadedCase(List<int> ids) {
    return _$deleteDownloadedCaseAsyncAction
        .run(() => super.deleteDownloadedCase(ids));
  }

  @override
  String toString() {
    return '''
getDownloadedCasesFuture: ${getDownloadedCasesFuture},
createDownloadedCaseFuture: ${createDownloadedCaseFuture},
deleteDownloadedCaseFuture: ${deleteDownloadedCaseFuture},
downloadedCases: ${downloadedCases},
loading: ${loading}
    ''';
  }
}
