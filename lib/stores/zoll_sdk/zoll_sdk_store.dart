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
  ObservableMap<int, VitalSigns?> vitalSigns = ObservableMap();

  @action
  void onDeviceFound(XSeriesDevice device) {
    print('store');
    print(device);
    devices.add(device);
    print(devices);
  }

  @action
  void onDeviceLost(XSeriesDevice device) {
    devices
        .removeWhere((element) => element.serialNumber == device.serialNumber);
  }

  @action
  void onBrowseError() {}

  @action
  void onVitalSignsReceived(String? callbackId, int requestCode,
      String serialNumber, VitalSigns? report) {
    vitalSigns[requestCode] = report;
  }
}
