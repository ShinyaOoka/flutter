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
  ObservableMap<String, List<CaseListItem>> cases = ObservableMap();

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
    this.cases[deviceId] =
        cases.where((e) => e != null).map((e) => e!).toList();
  }
}
