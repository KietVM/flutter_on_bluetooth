import 'dart:async';

import 'package:flutter/services.dart';
import 'package:on_bluetooth/src/bluetooth_status.dart';
import 'package:on_bluetooth/src/method.dart';

export 'package:on_bluetooth/src/bluetooth_status.dart';

class OnBluetooth {
  static const MethodChannel _channel = const MethodChannel(kPackageName);
  static StreamController<BluetoothStatus>? _stateChangeController =
      StreamController<BluetoothStatus>.broadcast();

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> turnOnBluetooth() async {
    final bool? success = await _channel.invokeMethod(kTurnOnBluetooth);
    if (success is bool) {
      return success;
    }
    return false;
  }

  /// get status bluetooth
  static Future<BluetoothStatus> bluetoothStatus() async {
    final statusString = await _channel.invokeMethod(kStatusBluetooth);
    if (statusString is String) {
      final bluetoothStatus = enumBluetoothStatusFromString(statusString);
      return bluetoothStatus;
    }
    return BluetoothStatus.unknown;
  }

  /// listen state change
  static Stream<BluetoothStatus> onStateChange() {
    _channel.invokeMethod('listenStateChange');
    if (_stateChangeController == null) {
      _stateChangeController = StreamController<BluetoothStatus>.broadcast();
    }
    return _stateChangeController!.stream;
  }

  ///
  static cancelStreamControl() {
    _channel.invokeMethod('cancelListenStateChange');
    _stateChangeController?.close();
    _stateChangeController = null;
  }

  /// request permission
  static void requestPermission() {
    _channel.invokeMethod('requestPermission');
  }

  static void setChannelMethodHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "permissionResult":
          {
            final result = call.arguments as bool?;
            if (result != null) {}
          }
          break;
        case kBlueStateChange:
          {
            final result = call.arguments as String?;
            print('state change $result');
            if (result != null) {
              switch (result) {
                case 'on':
                  _stateChangeController?.add(BluetoothStatus.on);
                  break;
                case 'unauthorized':
                  _stateChangeController?.add(BluetoothStatus.unauthorized);
                  break;
                default:
                  _stateChangeController?.add(BluetoothStatus.off);
              }
            }
          }
          break;
        default:
        // do nothing
      }
    });
  }
}
