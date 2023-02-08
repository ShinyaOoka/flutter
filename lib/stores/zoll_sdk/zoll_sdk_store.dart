import 'dart:io';

import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'zoll_sdk_store.g.dart';

class ZollSdkStore = _ZollSdkStore with _$ZollSdkStore;

abstract class _ZollSdkStore with Store {
  _ZollSdkStore();

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableList<XSeriesDevice> devices = ObservableList();

  @observable
  ObservableMap<String, List<CaseListItem>> caseListItems = ObservableMap();

  @observable
  ObservableMap<String, Case> cases = ObservableMap();

  @action
  void onDeviceFound(XSeriesDevice device) {
    devices.add(device);
  }

  @action
  void onDeviceLost(XSeriesDevice device) {
    devices
        .removeWhere((element) => element.serialNumber == device.serialNumber);
  }

  @action
  void onBrowseError() {}

  @action
  void onGetCaseListSuccess(
      int requestCode, String deviceId, List<CaseListItem?> cases) {
    this.caseListItems[deviceId] =
        cases.where((e) => e != null).map((e) => e!).toList();
  }

  @action
  Future<void> onDownloadCaseSuccess(
      int requestCode, String serialNumber, String caseId, String path) async {
    final String content = await File(path).readAsString();
    cases[caseId] = CaseParser.parse(content);
  }
}
