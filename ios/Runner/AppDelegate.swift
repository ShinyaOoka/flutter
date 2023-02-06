import UIKit
import XSeriesSDK
import Flutter

class ZollSdkHostApiImpl: NSObject, ZollSdkHostApi {
    private var browser = ZOXSeries.shared.xSeriesBrowser
    private var deviceApi = ZOXSeries.shared.deviceBrowser
    private var devices = [XSeriesSDK.XSeriesDevice]()
    private var flutterApi: ZollSdkFlutterApi
    
    init(flutterApi: ZollSdkFlutterApi) {
        self.flutterApi = flutterApi
    }
    
    func browserStart() {
        browser.start(delegate: self)
    }
    
    func browserStop() {
        browser.stop()
    }

    func deviceGetCaseList(device: XSeriesDevice, password: String?, completion: @escaping (Int32) -> Void) {
        print("start get case list");
        let nativeDevice = XSeriesSDK.XSeriesDevice(serialNumber: device.serialNumber,ipAdress: device.address)
        let requestCode = deviceApi.getXCaseCatalogItem(device: nativeDevice, password: password, delegate: self)
        completion(Int32(requestCode))
    }
}


extension ZollSdkHostApiImpl: XCaseCatalogItemDelegate {
    func onRequestFailed(requestCode: Int, deviceId: String, error: XSeriesSDK.ZOXError) {
        print("requet failed");
    }
    
    func onAuthenticationFailed(requestCode: Int, deviceId: String) {
        print("authentication needed");
    }
    
    func onRequestSuccess(requestCode: Int, deviceId: String, cases: [XCaseCatalogItem]) {
        let flutterCases = cases.map {hostToFlutterCaseListItem($0) };
        self.flutterApi.onGetCaseListSuccess(
            requestCode: Int32(requestCode),
            deviceId: deviceId,
            cases: flutterCases
        ) {};
    }
}

func hostToFlutterCaseListItem(_ x: XCaseCatalogItem) -> CaseListItem {
    let formatter = ISO8601DateFormatter();
    print("get case list returned");
    return CaseListItem(startTime: x.startTime != nil ? formatter.string(from: x.startTime!) : nil, endTime: x.endTime != nil ? formatter.string(from: x.endTime!) : nil)
}

func hostToFlutterUnit(_ x: XSeriesSDK.Unit) -> Unit {
    switch x {
    case .none:
        return Unit.none
    case .kpa:
        return Unit.kpa
    case .mmhg:
        return Unit.mmhg
    case .c:
        return Unit.c
    case .f:
        return Unit.f
    case .percent:
        return Unit.percent
    case .bpmBeats:
        return Unit.bpmBeats
    case .bpmBreaths:
        return Unit.bpmBreaths
    case .nanovolts:
        return Unit.nanovolts
    case .microvolts:
        return Unit.microvolts
    case .millivolts:
        return Unit.millivolts
    case .volts:
        return Unit.volts
    case .ppm:
        return Unit.ppm
    case .pacerPerMin:
        return Unit.pacerPerMin
    case .rpm:
        return Unit.rpm
    case .mah:
        return Unit.mah
    case .ma:
        return Unit.ma
    case .mOm:
        return Unit.mOm
    case .g_dl:
        return Unit.gDl
    case .mmo_l:
        return Unit.mmoL
    case .ml_dl:
        return Unit.mlDl
    case .j:
        return Unit.j
    case .undefined:
        fatalError()
    @unknown default:
        fatalError()
    }
}

func hostToFlutterAlarmStatus(_ x: XSeriesSDK.AlarmStatus) -> AlarmStatus {
    switch x {
    case .not_alarming:
        return AlarmStatus.notAlarming
    case .alarming:
        return AlarmStatus.alarming
    @unknown default:
        fatalError()
    }
}

func hostToFlutterDataStatus(_ x: XSeriesSDK.DataStatus) -> DataStatus {
    switch x {
    case .valid:
        return DataStatus.valid
    case .invalid:
        return DataStatus.invalid
    case .underrange:
        return DataStatus.underrange
    case .overrange:
        return DataStatus.overrange
    @unknown default:
        fatalError()
    }
}

//func hostToFlutterValueUnitPair(_ x: XSeriesSDK.ValueUnitPair) -> ValueUnitPair {
//    return ValueUnitPair(value: Float(x.value) , units: hostToFlutterUnit(x.units), isValid: x.isValid)
//}
//
//func hostToFlutterTrendData(_ x: XSeriesSDK.TrendData) -> TrendData {
//    return TrendData(value: hostToFlutterValueUnitPair(x.value),
//                     alarm: hostToFlutterAlarmStatus(x.alarm),
//                     dataStatus: hostToFlutterDataStatus(x.dataStatus)
//    )
//}

extension ZollSdkHostApiImpl: DevicesDelegate {
    func onDeviceFound(device: XSeriesSDK.XSeriesDevice) {
        self.devices.append(device)
        let flutterDevice = Runner.XSeriesDevice(address: device.ipAdress, serialNumber: device.serialNumber)
        self.flutterApi.onDeviceFound(device: flutterDevice) {}
    }
    
    func onDeviceLost(device: XSeriesSDK.XSeriesDevice) {
        devices.enumerated().forEach { index, deviceOne in
            if deviceOne.serialNumber == device.serialNumber {
                devices.remove(at: index)
            }
        }
        let flutterDevice = Runner.XSeriesDevice(address: device.ipAdress, serialNumber: device.serialNumber)
        self.flutterApi.onDeviceLost(device: flutterDevice) {}
    }
    
    func onBrowseError(error: ZOXError) {
        print(error.errorMessage)
        self.flutterApi.onBrowseError() {}
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var browser = ZOXSeries.shared.xSeriesBrowser
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let flutterApi = ZollSdkFlutterApi(binaryMessenger: controller.binaryMessenger)
        let hostApi = ZollSdkHostApiImpl(flutterApi: flutterApi)
        ZollSdkHostApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: hostApi)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
