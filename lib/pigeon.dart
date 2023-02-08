// Autogenerated from Pigeon (v7.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum Unit {
  none,
  kpa,
  mmhg,
  c,
  f,
  percent,
  bpmBeats,
  bpmBreaths,
  nanovolts,
  microvolts,
  millivolts,
  volts,
  ppm,
  pacerPerMin,
  rpm,
  mah,
  ma,
  mOm,
  gDl,
  mmoL,
  mlDl,
  j,
}

enum AlarmStatus {
  notAlarming,
  alarming,
}

enum DataStatus {
  valid,
  invalid,
  underrange,
  overrange,
}

class XSeriesDevice {
  XSeriesDevice({
    required this.address,
    required this.serialNumber,
  });

  String address;

  String serialNumber;

  Object encode() {
    return <Object?>[
      address,
      serialNumber,
    ];
  }

  static XSeriesDevice decode(Object result) {
    result as List<Object?>;
    return XSeriesDevice(
      address: result[0]! as String,
      serialNumber: result[1]! as String,
    );
  }
}

class CaseListItem {
  CaseListItem({
    this.startTime,
    this.endTime,
    required this.caseId,
  });

  String? startTime;

  String? endTime;

  String caseId;

  Object encode() {
    return <Object?>[
      startTime,
      endTime,
      caseId,
    ];
  }

  static CaseListItem decode(Object result) {
    result as List<Object?>;
    return CaseListItem(
      startTime: result[0] as String?,
      endTime: result[1] as String?,
      caseId: result[2]! as String,
    );
  }
}

class _ZollSdkHostApiCodec extends StandardMessageCodec {
  const _ZollSdkHostApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is XSeriesDevice) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return XSeriesDevice.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class ZollSdkHostApi {
  /// Constructor for [ZollSdkHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ZollSdkHostApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _ZollSdkHostApiCodec();

  Future<void> browserStart() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ZollSdkHostApi.browserStart', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> browserStop() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ZollSdkHostApi.browserStop', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int> deviceGetCaseList(XSeriesDevice arg_device, String? arg_password) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ZollSdkHostApi.deviceGetCaseList', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_device, arg_password]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as int?)!;
    }
  }

  Future<int> deviceDownloadCase(XSeriesDevice arg_device, String arg_caseId, String arg_path, String? arg_password) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ZollSdkHostApi.deviceDownloadCase', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_device, arg_caseId, arg_path, arg_password]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as int?)!;
    }
  }
}

class _ZollSdkFlutterApiCodec extends StandardMessageCodec {
  const _ZollSdkFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CaseListItem) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is XSeriesDevice) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return CaseListItem.decode(readValue(buffer)!);
      case 129: 
        return XSeriesDevice.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class ZollSdkFlutterApi {
  static const MessageCodec<Object?> codec = _ZollSdkFlutterApiCodec();

  void onDeviceFound(XSeriesDevice device);

  void onDeviceLost(XSeriesDevice device);

  void onBrowseError();

  void onGetCaseListSuccess(int requestCode, String serialNumber, List<CaseListItem?> cases);

  void onDownloadCaseSuccess(int requestCode, String serialNumber, String caseId, String path);

  static void setup(ZollSdkFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceFound', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceFound was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final XSeriesDevice? arg_device = (args[0] as XSeriesDevice?);
          assert(arg_device != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceFound was null, expected non-null XSeriesDevice.');
          api.onDeviceFound(arg_device!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceLost', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceLost was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final XSeriesDevice? arg_device = (args[0] as XSeriesDevice?);
          assert(arg_device != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceLost was null, expected non-null XSeriesDevice.');
          api.onDeviceLost(arg_device!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ZollSdkFlutterApi.onBrowseError', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onBrowseError();
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_requestCode = (args[0] as int?);
          assert(arg_requestCode != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess was null, expected non-null int.');
          final String? arg_serialNumber = (args[1] as String?);
          assert(arg_serialNumber != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess was null, expected non-null String.');
          final List<CaseListItem?>? arg_cases = (args[2] as List<Object?>?)?.cast<CaseListItem?>();
          assert(arg_cases != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess was null, expected non-null List<CaseListItem?>.');
          api.onGetCaseListSuccess(arg_requestCode!, arg_serialNumber!, arg_cases!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_requestCode = (args[0] as int?);
          assert(arg_requestCode != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess was null, expected non-null int.');
          final String? arg_serialNumber = (args[1] as String?);
          assert(arg_serialNumber != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess was null, expected non-null String.');
          final String? arg_caseId = (args[2] as String?);
          assert(arg_caseId != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess was null, expected non-null String.');
          final String? arg_path = (args[3] as String?);
          assert(arg_path != null,
              'Argument for dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess was null, expected non-null String.');
          api.onDownloadCaseSuccess(arg_requestCode!, arg_serialNumber!, arg_caseId!, arg_path!);
          return;
        });
      }
    }
  }
}
