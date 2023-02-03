import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';

class ZollSdkFlutterApiImpl extends ZollSdkFlutterApi {
  final ZollSdkStore store;
  ZollSdkFlutterApiImpl({required this.store});

  @override
  void onDeviceFound(XSeriesDevice device) {
    print('zzz');
    print(store);
    print(store.hashCode);
    store.onDeviceFound(device);
  }

  @override
  void onDeviceLost(XSeriesDevice device) {
    store.onDeviceLost(device);
  }

  @override
  void onBrowseError() {
    // TODO: implement onBrowseError
  }

  @override
  void onVitalSignsReceived(String? callbackId, int requestCode,
      String serialNumber, VitalSigns? report) {
    store.onVitalSignsReceived(callbackId, requestCode, serialNumber, report);
  }
}
