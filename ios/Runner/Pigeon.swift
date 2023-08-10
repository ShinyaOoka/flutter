// Autogenerated from Pigeon (v7.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif



private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

enum Unit: Int {
  case none = 0
  case kpa = 1
  case mmhg = 2
  case c = 3
  case f = 4
  case percent = 5
  case bpmBeats = 6
  case bpmBreaths = 7
  case nanovolts = 8
  case microvolts = 9
  case millivolts = 10
  case volts = 11
  case ppm = 12
  case pacerPerMin = 13
  case rpm = 14
  case mah = 15
  case ma = 16
  case mOm = 17
  case gDl = 18
  case mmoL = 19
  case mlDl = 20
  case j = 21
}

enum AlarmStatus: Int {
  case notAlarming = 0
  case alarming = 1
}

enum DataStatus: Int {
  case valid = 0
  case invalid = 1
  case underrange = 2
  case overrange = 3
}

/// Generated class from Pigeon that represents data sent in messages.
struct XSeriesDevice {
  var address: String
  var serialNumber: String

  static func fromList(_ list: [Any?]) -> XSeriesDevice? {
    let address = list[0] as! String
    let serialNumber = list[1] as! String

    return XSeriesDevice(
      address: address,
      serialNumber: serialNumber
    )
  }
  func toList() -> [Any?] {
    return [
      address,
      serialNumber,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct CaseListItem {
  var startTime: String? = nil
  var endTime: String? = nil
  var caseId: String

  static func fromList(_ list: [Any?]) -> CaseListItem? {
    let startTime = list[0] as? String 
    let endTime = list[1] as? String 
    let caseId = list[2] as! String

    return CaseListItem(
      startTime: startTime,
      endTime: endTime,
      caseId: caseId
    )
  }
  func toList() -> [Any?] {
    return [
      startTime,
      endTime,
      caseId,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct NativeEvent {
  var date: String
  var type: String

  static func fromList(_ list: [Any?]) -> NativeEvent? {
    let date = list[0] as! String
    let type = list[1] as! String

    return NativeEvent(
      date: date,
      type: type
    )
  }
  func toList() -> [Any?] {
    return [
      date,
      type,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct NativeCase {
  var events: [NativeEvent?]

  static func fromList(_ list: [Any?]) -> NativeCase? {
    let events = list[0] as! [NativeEvent?]

    return NativeCase(
      events: events
    )
  }
  func toList() -> [Any?] {
    return [
      events,
    ]
  }
}

private class ZollSdkHostApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return XSeriesDevice.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class ZollSdkHostApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? XSeriesDevice {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ZollSdkHostApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ZollSdkHostApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ZollSdkHostApiCodecWriter(data: data)
  }
}

class ZollSdkHostApiCodec: FlutterStandardMessageCodec {
  static let shared = ZollSdkHostApiCodec(readerWriter: ZollSdkHostApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol ZollSdkHostApi {
  func browserStart() throws
  func browserStop() throws
  func deviceGetCaseList(device: XSeriesDevice, password: String?, completion: @escaping (Int32) -> Void)
  func deviceDownloadCase(device: XSeriesDevice, caseId: String, path: String, password: String?, completion: @escaping (Int32) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class ZollSdkHostApiSetup {
  /// The codec used by ZollSdkHostApi.
  static var codec: FlutterStandardMessageCodec { ZollSdkHostApiCodec.shared }
  /// Sets up an instance of `ZollSdkHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ZollSdkHostApi?) {
    let browserStartChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkHostApi.browserStart", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      browserStartChannel.setMessageHandler { _, reply in
        do {
          try api.browserStart()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      browserStartChannel.setMessageHandler(nil)
    }
    let browserStopChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkHostApi.browserStop", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      browserStopChannel.setMessageHandler { _, reply in
        do {
          try api.browserStop()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      browserStopChannel.setMessageHandler(nil)
    }
    let deviceGetCaseListChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkHostApi.deviceGetCaseList", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      deviceGetCaseListChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let deviceArg = args[0] as! XSeriesDevice
        let passwordArg = args[1] as? String
        api.deviceGetCaseList(device: deviceArg, password: passwordArg) { result in
          reply(wrapResult(result))
        }
      }
    } else {
      deviceGetCaseListChannel.setMessageHandler(nil)
    }
    let deviceDownloadCaseChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkHostApi.deviceDownloadCase", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      deviceDownloadCaseChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let deviceArg = args[0] as! XSeriesDevice
        let caseIdArg = args[1] as! String
        let pathArg = args[2] as! String
        let passwordArg = args[3] as? String
        api.deviceDownloadCase(device: deviceArg, caseId: caseIdArg, path: pathArg, password: passwordArg) { result in
          reply(wrapResult(result))
        }
      }
    } else {
      deviceDownloadCaseChannel.setMessageHandler(nil)
    }
  }
}
private class ZollSdkFlutterApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return CaseListItem.fromList(self.readValue() as! [Any])
      case 129:
        return NativeCase.fromList(self.readValue() as! [Any])
      case 130:
        return NativeEvent.fromList(self.readValue() as! [Any])
      case 131:
        return XSeriesDevice.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class ZollSdkFlutterApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? CaseListItem {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? NativeCase {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? NativeEvent {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? XSeriesDevice {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ZollSdkFlutterApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ZollSdkFlutterApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ZollSdkFlutterApiCodecWriter(data: data)
  }
}

class ZollSdkFlutterApiCodec: FlutterStandardMessageCodec {
  static let shared = ZollSdkFlutterApiCodec(readerWriter: ZollSdkFlutterApiCodecReaderWriter())
}

/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class ZollSdkFlutterApi {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger){
    self.binaryMessenger = binaryMessenger
  }
  var codec: FlutterStandardMessageCodec {
    return ZollSdkFlutterApiCodec.shared
  }
  func onDeviceFound(device deviceArg: XSeriesDevice, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceFound", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([deviceArg] as [Any?]) { _ in
      completion()
    }
  }
  func onDeviceLost(device deviceArg: XSeriesDevice, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onDeviceLost", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([deviceArg] as [Any?]) { _ in
      completion()
    }
  }
  func onBrowseError(completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onBrowseError", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage(nil) { _ in
      completion()
    }
  }
  func onGetCaseListSuccess(requestCode requestCodeArg: Int32, deviceId deviceIdArg: String, cases casesArg: [CaseListItem?], completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onGetCaseListSuccess", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([requestCodeArg, deviceIdArg, casesArg] as [Any?]) { _ in
      completion()
    }
  }
  func onDownloadCaseSuccess(requestCode requestCodeArg: Int32, serialNumber serialNumberArg: String, caseId caseIdArg: String, path pathArg: String, nativeCase nativeCaseArg: NativeCase, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseSuccess", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([requestCodeArg, serialNumberArg, caseIdArg, pathArg, nativeCaseArg] as [Any?]) { _ in
      completion()
    }
  }
  func onDownloadCaseFailed(requestCode requestCodeArg: Int32, serialNumber serialNumberArg: String, caseId caseIdArg: String, errorMessage errorMessageArg: String, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ZollSdkFlutterApi.onDownloadCaseFailed", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([requestCodeArg, serialNumberArg, caseIdArg, errorMessageArg] as [Any?]) { _ in
      completion()
    }
  }
}
