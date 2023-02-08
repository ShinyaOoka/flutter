import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';

class ZollSdkFlutterApiImpl extends ZollSdkFlutterApi {
  final ZollSdkStore store;
  ZollSdkFlutterApiImpl({required this.store});

  @override
  void onDeviceFound(XSeriesDevice device) {
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
  void onGetCaseListSuccess(
      int requestCode, String serialNumber, List<CaseListItem?> cases) {
    store.onGetCaseListSuccess(requestCode, serialNumber, cases);
  }

  @override
  void onDownloadCaseSuccess(
      int requestCode, String serialNumber, String caseId, String path, NativeCase nativeCase) {
    store.onDownloadCaseSuccess(requestCode, serialNumber, caseId, path, nativeCase);
  }
}
