import Flutter
import UIKit
import CoreBluetooth

public class SwiftOnBluetoothPlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate {
    
    var methodChannel: FlutterMethodChannel
    var centralManager: CBCentralManager?
    
    public init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "on_bluetooth", binaryMessenger: registrar.messenger())
    let instance = SwiftOnBluetoothPlugin(methodChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "turnOnBluetooth":
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        result(true)
        break
    case "statusBluetooth":
        if (self.centralManager == nil) {
            self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        }
        print("statusBluetooth \(self.centralManager!.state.rawValue)")
        switch self.centralManager!.state {
        case .poweredOn:
            print("statusBluetooth on")
            result("on")
            break
        case .unauthorized:
            print("statusBluetooth unauthorized")
            result("unauthorized")
            break
        default:
            print("statusBluetooth off")
            result("off")
        }
        break
    case "requestPermission":
        // there is no way to call request permission bluetooth now
        // so call it pass central manager init
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        break
    case "listenStateChange":
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        break
    case "cancelListenStateChange":
        // no need to do anything now
        break
    default:
        result("iOS " + UIDevice.current.systemVersion)
        break
    }
  }
   public func centralManagerDidUpdateState(_ central: CBCentralManager) {
       print("central manager update \(central.state)")
       switch central.state {
       case .poweredOn:
           methodChannel.invokeMethod("blueStateChange", arguments: "on")
           break
       case .unauthorized:
           methodChannel.invokeMethod("blueStateChange", arguments: "unauthorized")
           break
       default:
           methodChannel.invokeMethod("blueStateChange", arguments: "off")
       }
   }
}

