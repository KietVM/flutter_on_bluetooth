import Flutter
import UIKit
import CoreBluetooth

public class SwiftOnBluetoothPlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "on_bluetooth", binaryMessenger: registrar.messenger())
    let instance = SwiftOnBluetoothPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "turnOnBluetooth":
        let _ = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        break
    case "statusBluetooth":
        let blueCentral = CBCentralManager()
        switch blueCentral.state {
        case .poweredOn:
            result("on")
            break
        case .unauthorized:
            result("unauthorized")
            break
        default:
            result("off")
        }
        break
    case "requestPermission":
        // there is no way to call request permission bluetooth now
        // so call it pass central manager init
        let _ = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        break
    default:
        result("iOS " + UIDevice.current.systemVersion)
        break
    }
  }
   public func centralManagerDidUpdateState(_ central: CBCentralManager) {}
}

