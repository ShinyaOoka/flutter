// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportStore on _ReportStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_ReportStore.loading'))
      .value;

  late final _$getReportsFutureAtom =
      Atom(name: '_ReportStore.getReportsFuture', context: context);

  @override
  ObservableFuture<List<Report>?> get getReportsFuture {
    _$getReportsFutureAtom.reportRead();
    return super.getReportsFuture;
  }

  @override
  set getReportsFuture(ObservableFuture<List<Report>?> value) {
    _$getReportsFutureAtom.reportWrite(value, super.getReportsFuture, () {
      super.getReportsFuture = value;
    });
  }

  late final _$createReportFutureAtom =
      Atom(name: '_ReportStore.createReportFuture', context: context);

  @override
  ObservableFuture<void> get createReportFuture {
    _$createReportFutureAtom.reportRead();
    return super.createReportFuture;
  }

  @override
  set createReportFuture(ObservableFuture<void> value) {
    _$createReportFutureAtom.reportWrite(value, super.createReportFuture, () {
      super.createReportFuture = value;
    });
  }

  late final _$deleteReportFutureAtom =
      Atom(name: '_ReportStore.deleteReportFuture', context: context);

  @override
  ObservableFuture<void> get deleteReportFuture {
    _$deleteReportFutureAtom.reportRead();
    return super.deleteReportFuture;
  }

  @override
  set deleteReportFuture(ObservableFuture<void> value) {
    _$deleteReportFutureAtom.reportWrite(value, super.deleteReportFuture, () {
      super.deleteReportFuture = value;
    });
  }

  late final _$reportsAtom =
      Atom(name: '_ReportStore.reports', context: context);

  @override
  ObservableList<Report>? get reports {
    _$reportsAtom.reportRead();
    return super.reports;
  }

  @override
  set reports(ObservableList<Report>? value) {
    _$reportsAtom.reportWrite(value, super.reports, () {
      super.reports = value;
    });
  }

  late final _$selectingReportAtom =
      Atom(name: '_ReportStore.selectingReport', context: context);

  @override
  Report? get selectingReport {
    _$selectingReportAtom.reportRead();
    return super.selectingReport;
  }

  @override
  set selectingReport(Report? value) {
    _$selectingReportAtom.reportWrite(value, super.selectingReport, () {
      super.selectingReport = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_ReportStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$getReportsAsyncAction =
      AsyncAction('_ReportStore.getReports', context: context);

  @override
  Future<dynamic> getReports() {
    return _$getReportsAsyncAction.run(() => super.getReports());
  }

  late final _$createReportAsyncAction =
      AsyncAction('_ReportStore.createReport', context: context);

  @override
  Future<dynamic> createReport(Report report) {
    return _$createReportAsyncAction.run(() => super.createReport(report));
  }

  late final _$editReportAsyncAction =
      AsyncAction('_ReportStore.editReport', context: context);

  @override
  Future<dynamic> editReport(Report report) {
    return _$editReportAsyncAction.run(() => super.editReport(report));
  }

  late final _$deleteReportsAsyncAction =
      AsyncAction('_ReportStore.deleteReports', context: context);

  @override
  Future<dynamic> deleteReports(List<int> reportIds) {
    return _$deleteReportsAsyncAction.run(() => super.deleteReports(reportIds));
  }

  late final _$_ReportStoreActionController =
      ActionController(name: '_ReportStore', context: context);

  @override
  void setSelectingReport(Report report) {
    final _$actionInfo = _$_ReportStoreActionController.startAction(
        name: '_ReportStore.setSelectingReport');
    try {
      return super.setSelectingReport(report);
    } finally {
      _$_ReportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
getReportsFuture: ${getReportsFuture},
createReportFuture: ${createReportFuture},
deleteReportFuture: ${deleteReportFuture},
reports: ${reports},
selectingReport: ${selectingReport},
success: ${success},
loading: ${loading}
    ''';
  }
}
