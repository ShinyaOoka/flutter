import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'report_store.g.dart';

class ReportStore = _ReportStore with _$ReportStore;

abstract class _ReportStore with Store {
  late final Repository _repository;

  _ReportStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableFuture<List<Report>?> getReportsFuture =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<void> createReportFuture = ObservableFuture.value(null);

  @observable
  ObservableList<Report>? reports;

  @observable
  Report? selectingReport;

  @observable
  bool success = false;

  @computed
  bool get loading => getReportsFuture.status == FutureStatus.pending;

  @action
  Future getReports() async {
    final future = _repository.getReports();
    getReportsFuture = ObservableFuture(future);

    await future.then((reportList) {
      reports = ObservableList.of(reportList);
    });
  }

  @action
  Future createReport(Report report) async {
    final future = _repository.createReport(report);
    createReportFuture = ObservableFuture(future);

    await future.catchError((error) {
      errorStore.errorMessage = error.toString();
    });
  }

  @action
  Future editReport(Report report) async {
    final future = _repository.editReport(report);
    createReportFuture = ObservableFuture(future);

    await future.catchError((error) {
      errorStore.errorMessage = error.toString();
    });
  }

  @action
  void setSelectingReport(Report report) {
    selectingReport = report;
  }
}
