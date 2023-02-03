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

  late final _$vitalSignsAtom =
      Atom(name: '_ZollSdkStore.vitalSigns', context: context);

  @override
  ObservableMap<int, VitalSigns?> get vitalSigns {
    _$vitalSignsAtom.reportRead();
    return super.vitalSigns;
  }

  @override
  set vitalSigns(ObservableMap<int, VitalSigns?> value) {
    _$vitalSignsAtom.reportWrite(value, super.vitalSigns, () {
      super.vitalSigns = value;
    });
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
  void onVitalSignsReceived(String? callbackId, int requestCode,
      String serialNumber, VitalSigns? report) {
    final _$actionInfo = _$_ZollSdkStoreActionController.startAction(
        name: '_ZollSdkStore.onVitalSignsReceived');
    try {
      return super
          .onVitalSignsReceived(callbackId, requestCode, serialNumber, report);
    } finally {
      _$_ZollSdkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
devices: ${devices},
vitalSigns: ${vitalSigns}
    ''';
  }
}
