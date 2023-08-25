import 'dart:io';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/downloaded_case/downloaded_case.dart';
import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';
import 'package:path_provider/path_provider.dart';

part 'downloaded_case_store.g.dart';

class DownloadedCaseStore = _DownloadedCaseStore with _$DownloadedCaseStore;

abstract class _DownloadedCaseStore with Store {
  late final Repository _repository;

  _DownloadedCaseStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableFuture<List<DownloadedCase>?> getDownloadedCasesFuture =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<void> createDownloadedCaseFuture =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<void> deleteDownloadedCaseFuture =
      ObservableFuture.value(null);

  @observable
  ObservableList<DownloadedCase>? downloadedCases;

  @computed
  bool get loading =>
      getDownloadedCasesFuture.status == FutureStatus.pending ||
      createDownloadedCaseFuture.status == FutureStatus.pending ||
      deleteDownloadedCaseFuture.status == FutureStatus.pending;

  @action
  Future getDownloadedCases() async {
    final future = _repository.getDownloadedCases();
    getDownloadedCasesFuture = ObservableFuture(future);

    await future.then((reportList) {
      reportList.sort((a, b) => b.entryDate!.compareTo(a.entryDate!));
      downloadedCases = ObservableList.of(reportList);
    }).catchError((error) {
      print(error);
      errorStore.errorMessage = error.toString();
    });
  }

  @action
  Future saveCase(Case myCase, String deviceId, String caseId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final filename = '$deviceId-$caseId.json';
    final filepath = '${appDir.path}/$filename';

    final file = File(filepath);
    file.writeAsString(myCase.rawData!);
    final oldIds = downloadedCases
        ?.where((e) => e.deviceCd == deviceId && e.caseCd == caseId)
        .map((e) => e.id!);
    if (oldIds?.isNotEmpty == true) {
      await deleteDownloadedCase(oldIds!.toList());
    }
    final downloadedCase = DownloadedCase();
    downloadedCase.caseCd = caseId;
    downloadedCase.deviceCd = deviceId;
    downloadedCase.filename = filename;
    downloadedCase.entryDate = DateTime.now();
    downloadedCase.caseStartDate = myCase.startTime;
    downloadedCase.caseEndDate = myCase.endTime;

    final future = _repository.createDownloadedCase(downloadedCase);
    createDownloadedCaseFuture = ObservableFuture(future);
    await future.catchError((error) {
      print(error);
      errorStore.errorMessage = error.toString();
    });
  }

  @action
  Future deleteDownloadedCase(List<int> ids) async {
    final appDir = await getApplicationDocumentsDirectory();
    final future = _repository.deleteDownloadedCase(ids);
    deleteDownloadedCaseFuture = ObservableFuture(future);
    downloadedCases
        ?.where((e) => ids.contains(e.id) && e.filename != null)
        .map((e) => e.filename)
        .forEach((e) => File('${appDir.path}/$e').deleteSync());

    await future.catchError((error) {
      errorStore.errorMessage = error.toString();
    });
  }
}
