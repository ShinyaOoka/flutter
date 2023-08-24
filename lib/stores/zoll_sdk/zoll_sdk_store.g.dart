// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zoll_sdk_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ZollSdkStore on _ZollSdkStore, Store {
  late final _$devicesAtom =
      Atom(name: '_ZollSdkStore.devices', context: context);

  @override
  ObservableList<XSeriesDevice> get devices {
    _$devicesAtom.reportRead();
    return super.devices;
  }

  @override
  set devices(ObservableList<XSeriesDevice> value) {
    _$devicesAtom.reportWrite(value, super.devices, () {
      super.devices = value;
    });
  }

  late final _$caseListItemsAtom =
      Atom(name: '_ZollSdkStore.caseListItems', context: context);

  @override
  ObservableMap<String, List<CaseListItem>> get caseListItems {
    _$caseListItemsAtom.reportRead();
    return super.caseListItems;
  }

  @override
  set caseListItems(ObservableMap<String, List<CaseListItem>> value) {
    _$caseListItemsAtom.reportWrite(value, super.caseListItems, () {
      super.caseListItems = value;
    });
  }

  late final _$casesAtom = Atom(name: '_ZollSdkStore.cases', context: context);

  @override
  ObservableMap<String, Case> get cases {
    _$casesAtom.reportRead();
    return super.cases;
  }

  @override
  set cases(ObservableMap<String, Case> value) {
    _$casesAtom.reportWrite(value, super.cases, () {
      super.cases = value;
    });
  }

  late final _$downloadCaseCompleterAtom =
      Atom(name: '_ZollSdkStore.downloadCaseCompleter', context: context);

  @override
  Completer<dynamic>? get downloadCaseCompleter {
    _$downloadCaseCompleterAtom.reportRead();
    return super.downloadCaseCompleter;
  }

  @override
  set downloadCaseCompleter(Completer<dynamic>? value) {
    _$downloadCaseCompleterAtom.reportWrite(value, super.downloadCaseCompleter,
        () {
      super.downloadCaseCompleter = value;
    });
  }

  late final _$selectedDeviceAtom =
      Atom(name: '_ZollSdkStore.selectedDevice', context: context);

  @override
  XSeriesDevice? get selectedDevice {
    _$selectedDeviceAtom.reportRead();
    return super.selectedDevice;
  }

  @override
  set selectedDevice(XSeriesDevice? value) {
    _$selectedDeviceAtom.reportWrite(value, super.selectedDevice, () {
      super.selectedDevice = value;
    });
  }

  late final _$caseOriginAtom =
      Atom(name: '_ZollSdkStore.caseOrigin', context: context);

  @override
  CaseOrigin get caseOrigin {
    _$caseOriginAtom.reportRead();
    return super.caseOrigin;
  }

  @override
  set caseOrigin(CaseOrigin value) {
    _$caseOriginAtom.reportWrite(value, super.caseOrigin, () {
      super.caseOrigin = value;
    });
  }

  late final _$onDownloadCaseSuccessAsyncAction =
      AsyncAction('_ZollSdkStore.onDownloadCaseSuccess', context: context);

  @override
  Future<void> onDownloadCaseSuccess(int requestCode, String serialNumber,
      String caseId, String path, NativeCase nativeCase) {
    return _$onDownloadCaseSuccessAsyncAction.run(() => super
        .onDownloadCaseSuccess(
            requestCode, serialNumber, caseId, path, nativeCase));
  }

  late final _$onDownloadCaseFailedAsyncAction =
      AsyncAction('_ZollSdkStore.onDownloadCaseFailed', context: context);

  @override
  Future<void> onDownloadCaseFailed(int requestCode, String serialNumber,
      String caseId, String errorMessage) {
    return _$onDownloadCaseFailedAsyncAction.run(() => super
        .onDownloadCaseFailed(requestCode, serialNumber, caseId, errorMessage));
  }

  late final _$_ZollSdkStoreActionController =
      ActionController(name: '_ZollSdkStore', context: context);

  @override
  void onDeviceFound(XSeriesDevice device) {
    final _$actionInfo = _$_ZollSdkStoreActionController.startAction(
        name: '_ZollSdkStore.onDeviceFound');
    try {
      return super.onDeviceFound(device);
    } finally {
      _$_ZollSdkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onDeviceLost(XSeriesDevice device) {
    final _$actionInfo = _$_ZollSdkStoreActionController.startAction(
        name: '_ZollSdkStore.onDeviceLost');
    try {
      return super.onDeviceLost(device);
    } finally {
      _$_ZollSdkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onBrowseError() {
    final _$actionInfo = _$_ZollSdkStoreActionController.startAction(
        name: '_ZollSdkStore.onBrowseError');
    try {
      return super.onBrowseError();
    } finally {
      _$_ZollSdkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onGetCaseListSuccess(
      int requestCode, String deviceId, List<CaseListItem?> cases) {
    final _$actionInfo = _$_ZollSdkStoreActionController.startAction(
        name: '_ZollSdkStore.onGetCaseListSuccess');
    try {
      return super.onGetCaseListSuccess(requestCode, deviceId, cases);
    } finally {
      _$_ZollSdkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
devices: ${devices},
caseListItems: ${caseListItems},
cases: ${cases},
downloadCaseCompleter: ${downloadCaseCompleter},
selectedDevice: ${selectedDevice},
caseOrigin: ${caseOrigin}
    ''';
  }
}
